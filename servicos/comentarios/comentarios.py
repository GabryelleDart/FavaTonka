import os
import time

from flask import Flask, jsonify, request
import mysql.connector as mysql
from werkzeug.exceptions import HTTPException

servico = Flask("comentarios")

DESCRICAO = "serviço de listagem, cadastro e remoção de comentários do FavaTonka"
VERSAO = "1.0"

SERVIDOR_BANCO = os.environ.get("SERVIDOR_BANCO", "banco")
USUARIO_BANCO = os.environ.get("USUARIO_BANCO", "root")
SENHA_BANCO = os.environ.get("SENHA_BANCO", "admin")
NOME_BANCO = os.environ.get("NOME_BANCO", "favatonka")

TAMANHO_MAXIMO_PAGINA = 50
TAMANHO_MAXIMO_COMENTARIO = 500


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


def montar_comentario(linha):
    return {
        "id": linha["id"],
        "perfume_id": linha["perfume_id"],
        "nome": linha["nome"],
        "email": linha["email"],
        "texto": linha["texto"],
        "data": linha["data"].isoformat(),
    }


@servico.get("/")
def get_info():
    return jsonify(descricao=DESCRICAO, versao=VERSAO)


@servico.get("/<int:perfume_id>/<int:ultimo_comentario>/<int:tamanho_pagina>")
def get_comentarios(perfume_id, ultimo_comentario, tamanho_pagina):
    """Lazy-loading: devolve os comentários mais novos que ainda não foram entregues
    (id menor que ultimo_comentario), do mais recente para o mais antigo."""
    tamanho_pagina = max(1, min(tamanho_pagina, TAMANHO_MAXIMO_PAGINA))

    conexao = get_conexao_bd()
    try:
        cursor = conexao.cursor(dictionary=True)
        cursor.execute(
            """
SELECT id, perfume_id, nome, email, texto, data
FROM comentarios
WHERE perfume_id = %s AND id < %s
ORDER BY id DESC
LIMIT %s
            """,
            (perfume_id, ultimo_comentario, tamanho_pagina),
        )
        linhas = cursor.fetchall()
        cursor.close()
    finally:
        conexao.close()

    return jsonify([montar_comentario(linha) for linha in linhas])


@servico.post("/<int:perfume_id>")
def adicionar_comentario(perfume_id):
    """Corpo (JSON): {"nome": "...", "email": "...", "texto": "..."}"""
    corpo = request.get_json(silent=True) or {}
    nome = str(corpo.get("nome", "")).strip()
    email = str(corpo.get("email", "")).strip()
    texto = str(corpo.get("texto", "")).strip()

    if not nome or not email or not texto:
        return jsonify(erro="nome, email e texto são obrigatórios"), 400
    if len(texto) > TAMANHO_MAXIMO_COMENTARIO:
        return jsonify(erro="o comentário passou de 500 caracteres"), 400

    conexao = get_conexao_bd()
    try:
        cursor = conexao.cursor(dictionary=True)
        cursor.execute("SELECT id FROM perfumes WHERE id = %s", (perfume_id,))
        if cursor.fetchone() is None:
            cursor.close()
            return jsonify(erro="perfume não encontrado"), 404

        try:
            cursor.execute(
                "INSERT INTO comentarios (perfume_id, nome, email, texto, data) VALUES (%s, %s, %s, %s, NOW())",
                (perfume_id, nome, email, texto),
            )
            conexao.commit()
        except Exception as erro:
            conexao.rollback()
            servico.logger.error(erro)
            cursor.close()
            return jsonify(erro="erro ao salvar o comentário"), 500

        novo_id = cursor.lastrowid
        cursor.close()
    finally:
        conexao.close()

    return jsonify(id=novo_id), 201


@servico.delete("/<int:comentario_id>")
def remover_comentario(comentario_id):
    """Só o autor apaga o próprio comentário: DELETE /<id>?email=autor@email.com"""
    email = request.args.get("email", "").strip()
    if not email:
        return jsonify(erro="informe o email do autor"), 400

    conexao = get_conexao_bd()
    try:
        cursor = conexao.cursor()
        try:
            cursor.execute(
                "DELETE FROM comentarios WHERE id = %s AND email = %s", (comentario_id, email)
            )
            conexao.commit()
            apagados = cursor.rowcount
        except Exception as erro:
            conexao.rollback()
            servico.logger.error(erro)
            cursor.close()
            return jsonify(erro="erro ao apagar o comentário"), 500
        cursor.close()
    finally:
        conexao.close()

    if apagados == 0:
        return jsonify(erro="comentário não encontrado para este usuário"), 404
    return jsonify(situacao="ok"), 200


if __name__ == "__main__":
    servico.run(host="0.0.0.0", debug=True)
