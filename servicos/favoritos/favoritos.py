import os
import time

from flask import Flask, jsonify
import mysql.connector as mysql
from werkzeug.exceptions import HTTPException

servico = Flask("favoritos")

DESCRICAO = "serviço de favoritos dos usuários do FavaTonka"
VERSAO = "1.0"

SERVIDOR_BANCO = os.environ.get("SERVIDOR_BANCO", "banco")
USUARIO_BANCO = os.environ.get("USUARIO_BANCO", "root")
SENHA_BANCO = os.environ.get("SENHA_BANCO", "admin")
NOME_BANCO = os.environ.get("NOME_BANCO", "favatonka")

TAMANHO_MAXIMO_PAGINA = 50


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


@servico.get("/")
def get_info():
    return jsonify(descricao=DESCRICAO, versao=VERSAO)


@servico.get("/<string:email>/ids")
def get_ids(email):
    """Ids de todos os perfumes favoritados pelo usuário (usado para pintar os corações)."""
    conexao = get_conexao_bd()
    try:
        cursor = conexao.cursor(dictionary=True)
        cursor.execute("SELECT perfume_id FROM favoritos WHERE email = %s", (email,))
        linhas = cursor.fetchall()
        cursor.close()
    finally:
        conexao.close()
    return jsonify([linha["perfume_id"] for linha in linhas])


@servico.get("/<string:email>/<int:perfume_id>")
def get_favorito(email, perfume_id):
    conexao = get_conexao_bd()
    try:
        cursor = conexao.cursor(dictionary=True)
        cursor.execute(
            "SELECT COUNT(*) AS quantidade FROM favoritos WHERE email = %s AND perfume_id = %s",
            (email, perfume_id),
        )
        quantidade = cursor.fetchone()["quantidade"]
        cursor.close()
    finally:
        conexao.close()
    return jsonify(favorito=quantidade > 0)


@servico.get("/<string:email>/<int:ultimo_favorito>/<int:tamanho_pagina>")
def get_favoritos(email, ultimo_favorito, tamanho_pagina):
    """Lazy-loading: próxima página de favoritos do usuário depois de ultimo_favorito."""
    tamanho_pagina = max(1, min(tamanho_pagina, TAMANHO_MAXIMO_PAGINA))

    conexao = get_conexao_bd()
    try:
        cursor = conexao.cursor(dictionary=True)
        cursor.execute(
            """
SELECT f.id AS favorito_id, p.id, p.slug, p.nome, p.marca, p.ano, p.genero
FROM favoritos f
JOIN perfumes p ON p.id = f.perfume_id
WHERE f.email = %s AND f.id > %s
ORDER BY f.id ASC
LIMIT %s
            """,
            (email, ultimo_favorito, tamanho_pagina),
        )
        linhas = cursor.fetchall()

        familias = {linha["id"]: [] for linha in linhas}
        if familias:
            ids = list(familias.keys())
            cursor.execute(
                "SELECT perfume_id, familia FROM perfume_familias WHERE perfume_id IN ("
                + ",".join(["%s"] * len(ids))
                + ") ORDER BY familia",
                tuple(ids),
            )
            for linha in cursor.fetchall():
                familias[linha["perfume_id"]].append(linha["familia"])
        cursor.close()
    finally:
        conexao.close()

    resultado = []
    for linha in linhas:
        resultado.append({
            "favorito_id": linha["favorito_id"],
            "id": linha["id"],
            "slug": linha["slug"],
            "nome": linha["nome"],
            "marca": linha["marca"],
            "ano": linha["ano"],
            "genero": linha["genero"],
            "familias": familias[linha["id"]],
            "foto": "perfumes/" + linha["slug"] + ".jpg",
        })
    return jsonify(resultado)


@servico.post("/<string:email>/<int:perfume_id>")
def favoritar(email, perfume_id):
    conexao = get_conexao_bd()
    try:
        cursor = conexao.cursor(dictionary=True)
        cursor.execute("SELECT id FROM perfumes WHERE id = %s", (perfume_id,))
        if cursor.fetchone() is None:
            cursor.close()
            return jsonify(erro="perfume não encontrado"), 404

        try:
            # INSERT IGNORE: favoritar duas vezes não gera erro nem duplica
            cursor.execute(
                "INSERT IGNORE INTO favoritos (perfume_id, email) VALUES (%s, %s)", (perfume_id, email)
            )
            conexao.commit()
        except Exception as erro:
            conexao.rollback()
            servico.logger.error(erro)
            cursor.close()
            return jsonify(erro="erro ao favoritar"), 500
        cursor.close()
    finally:
        conexao.close()
    return jsonify(situacao="ok"), 201


@servico.delete("/<string:email>/<int:perfume_id>")
def desfavoritar(email, perfume_id):
    conexao = get_conexao_bd()
    try:
        cursor = conexao.cursor()
        try:
            cursor.execute(
                "DELETE FROM favoritos WHERE email = %s AND perfume_id = %s", (email, perfume_id)
            )
            conexao.commit()
        except Exception as erro:
            conexao.rollback()
            servico.logger.error(erro)
            cursor.close()
            return jsonify(erro="erro ao desfavoritar"), 500
        cursor.close()
    finally:
        conexao.close()
    return jsonify(situacao="ok"), 200


if __name__ == "__main__":
    servico.run(host="0.0.0.0", debug=True)
