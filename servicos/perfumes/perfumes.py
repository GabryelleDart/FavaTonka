import os
import re
import time
import unicodedata

from flask import Flask, jsonify, request
import mysql.connector as mysql
from werkzeug.exceptions import HTTPException

servico = Flask("perfumes")

DESCRICAO = "serviço de consulta de perfumes, famílias olfativas e notas do FavaTonka"
VERSAO = "1.0"

SERVIDOR_BANCO = os.environ.get("SERVIDOR_BANCO", "banco")
USUARIO_BANCO = os.environ.get("USUARIO_BANCO", "root")
SENHA_BANCO = os.environ.get("SENHA_BANCO", "admin")
NOME_BANCO = os.environ.get("NOME_BANCO", "favatonka")

TAMANHO_MAXIMO_PAGINA = 50
PALAVRAS_IGNORADAS = {"de", "da", "do", "das", "dos"}


# ---------------------------------------------------------------- banco de dados

def get_conexao_bd():
    """Abre uma conexão com o banco. Tenta algumas vezes porque o MySQL pode demorar a ficar pronto."""
    ultimo_erro = None
    for _ in range(10):
        try:
            return mysql.connect(
                host=SERVIDOR_BANCO, user=USUARIO_BANCO, password=SENHA_BANCO,
                database=NOME_BANCO, connection_timeout=5,
            )
        except mysql.Error as erro:
            ultimo_erro = erro
            time.sleep(2)
    raise ultimo_erro


def consultar(sql, parametros=()):
    conexao = get_conexao_bd()
    try:
        cursor = conexao.cursor(dictionary=True)
        cursor.execute(sql, parametros)
        linhas = cursor.fetchall()
        cursor.close()
        return linhas
    finally:
        conexao.close()


# ---------------------------------------------------------------- CORS (permite o app rodar no Chrome)

@servico.after_request
def liberar_cors(resposta):
    resposta.headers["Access-Control-Allow-Origin"] = "*"
    resposta.headers["Access-Control-Allow-Methods"] = "GET, POST, DELETE, OPTIONS"
    resposta.headers["Access-Control-Allow-Headers"] = "Content-Type"
    return resposta


@servico.errorhandler(Exception)
def tratar_erro(erro):
    if isinstance(erro, HTTPException):
        return erro  # 404, 405... seguem com o código original
    servico.logger.error(erro)
    return jsonify(erro="erro interno do serviço"), 500


# ---------------------------------------------------------------- busca

def normalizar(texto):
    """minúsculas, sem acentos e sem apóstrofos ("J'adore" vira "jadore"; "Nº" vira "no")."""
    texto = unicodedata.normalize("NFKD", texto.lower())
    texto = "".join(c for c in texto if not unicodedata.combining(c))
    return re.sub(r"['’`´]", "", texto)


def palavras(texto):
    return [p for p in re.split(r"[^a-z0-9]+", normalizar(texto)) if p and p not in PALAVRAS_IGNORADAS]


def compactar(texto):
    return re.sub(r"[^a-z0-9]", "", normalizar(texto))


# ---------------------------------------------------------------- montagem das respostas

def marcadores(quantidade):
    return ",".join(["%s"] * quantidade)


def montar_perfume(linha):
    return {
        "id": linha["id"],
        "slug": linha["slug"],
        "nome": linha["nome"],
        "marca": linha["marca"],
        "ano": linha["ano"],
        "genero": linha["genero"],
        "foto": "perfumes/" + linha["slug"] + ".jpg",
    }


def carregar_familias(ids):
    familias = {i: [] for i in ids}
    if not ids:
        return familias
    linhas = consultar(
        f"SELECT perfume_id, familia FROM perfume_familias WHERE perfume_id IN ({marcadores(len(ids))}) ORDER BY familia",
        tuple(ids),
    )
    for linha in linhas:
        familias[linha["perfume_id"]].append(linha["familia"])
    return familias


def carregar_notas(ids):
    """Notas de cada perfume, em ordem de pirâmide (topo, coração, fundo)."""
    notas = {i: [] for i in ids}
    if not ids:
        return notas
    linhas = consultar(
        f"""
SELECT pn.perfume_id, pn.nivel, n.chave, n.nome, n.emoji, n.cor1, n.cor2
FROM perfume_notas pn
JOIN notas n ON n.chave = pn.nota_chave
WHERE pn.perfume_id IN ({marcadores(len(ids))})
ORDER BY pn.perfume_id,
         CASE pn.nivel WHEN 'topo' THEN 1 WHEN 'coracao' THEN 2 ELSE 3 END,
         pn.ordem
        """,
        tuple(ids),
    )
    for linha in linhas:
        notas[linha["perfume_id"]].append({
            "chave": linha["chave"], "nome": linha["nome"], "emoji": linha["emoji"],
            "cor1": linha["cor1"], "cor2": linha["cor2"], "nivel": linha["nivel"],
        })
    return notas


# ---------------------------------------------------------------- rotas

@servico.get("/")
def get_info():
    return jsonify(descricao=DESCRICAO, versao=VERSAO)


@servico.get("/familias")
def get_familias():
    linhas = consultar("SELECT DISTINCT familia FROM perfume_familias ORDER BY familia")
    return jsonify([linha["familia"] for linha in linhas])


@servico.get("/<int:ultimo_id>/<int:tamanho_pagina>")
def get_perfumes(ultimo_id, tamanho_pagina):
    """Lazy-loading: devolve a próxima página de perfumes depois de ultimo_id.
    Parâmetros opcionais na URL: ?busca=texto&familia=Floral"""
    tamanho_pagina = max(1, min(tamanho_pagina, TAMANHO_MAXIMO_PAGINA))
    busca = request.args.get("busca", "").strip()
    familia = request.args.get("familia", "").strip()

    condicoes = ["p.id > %s"]
    parametros = [ultimo_id]

    termos = palavras(busca)
    if termos:
        # cada termo digitado precisa ser o começo de alguma palavra do perfume
        partes = []
        for termo in termos:
            partes.append(
                "EXISTS (SELECT 1 FROM perfume_palavras w WHERE w.perfume_id = p.id AND w.palavra LIKE %s)"
            )
            parametros.append(termo + "%")
        sql_busca = "(" + " AND ".join(partes) + ")"

        # também aceita o nome "colado": "j adore" -> "jadore", "no 5" -> "no5"
        compacto = compactar(busca)
        if compacto:
            sql_busca = "(" + sql_busca + " OR p.nome_compacto LIKE %s)"
            parametros.append(compacto + "%")
        condicoes.append(sql_busca)

    if familia:
        condicoes.append(
            "EXISTS (SELECT 1 FROM perfume_familias f WHERE f.perfume_id = p.id AND f.familia = %s)"
        )
        parametros.append(familia)

    parametros.append(tamanho_pagina)

    linhas = consultar(
        "SELECT p.id, p.slug, p.nome, p.marca, p.ano, p.genero FROM perfumes p WHERE "
        + " AND ".join(condicoes)
        + " ORDER BY p.id ASC LIMIT %s",
        tuple(parametros),
    )

    ids = [linha["id"] for linha in linhas]
    familias = carregar_familias(ids)
    notas = carregar_notas(ids)

    resultado = []
    for linha in linhas:
        perfume = montar_perfume(linha)
        todas = notas[linha["id"]]
        coracao = [n for n in todas if n["nivel"] == "coracao"]
        perfume["familias"] = familias[linha["id"]]
        perfume["notas_preview"] = (coracao if coracao else todas)[:4]
        perfume["total_notas"] = len(todas)
        resultado.append(perfume)

    return jsonify(resultado)


@servico.get("/<int:id>")
def get_perfume(id):
    linhas = consultar(
        "SELECT id, slug, nome, marca, ano, genero, descricao FROM perfumes WHERE id = %s", (id,)
    )
    if not linhas:
        return jsonify(erro="perfume não encontrado"), 404

    linha = linhas[0]
    perfume = montar_perfume(linha)
    perfume["descricao"] = linha["descricao"]
    perfume["familias"] = carregar_familias([id])[id]

    piramide = {"topo": [], "coracao": [], "fundo": []}
    for nota in carregar_notas([id])[id]:
        piramide[nota["nivel"]].append(nota)
    perfume["notas"] = piramide

    return jsonify(perfume)


@servico.get("/notas/<string:chave>/perfumes")
def get_perfumes_da_nota(chave):
    """Perfumes que têm determinada nota (janela que abre ao tocar numa nota)."""
    linhas = consultar(
        """
SELECT DISTINCT p.id, p.slug, p.nome, p.marca, p.ano, p.genero
FROM perfumes p
JOIN perfume_notas pn ON pn.perfume_id = p.id
WHERE pn.nota_chave = %s
ORDER BY p.id
        """,
        (chave,),
    )
    ids = [linha["id"] for linha in linhas]
    familias = carregar_familias(ids)

    resultado = []
    for linha in linhas:
        perfume = montar_perfume(linha)
        perfume["familias"] = familias[linha["id"]]
        resultado.append(perfume)
    return jsonify(resultado)


if __name__ == "__main__":
    servico.run(host="0.0.0.0", debug=True)
