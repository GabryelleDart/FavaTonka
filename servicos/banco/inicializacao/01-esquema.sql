-- FavaTonka: esquema do banco de dados (executado automaticamente na primeira vez que o container "banco" sobe)
SET NAMES utf8mb4;

USE favatonka;

-- Cadastro das notas olfativas (nome, emoji e cores do círculo)
CREATE TABLE notas (
    chave VARCHAR(40)  NOT NULL PRIMARY KEY,
    nome  VARCHAR(60)  NOT NULL,
    emoji VARCHAR(16)  NOT NULL,
    cor1  CHAR(7)      NOT NULL,
    cor2  CHAR(7)      NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE perfumes (
    id            INT          NOT NULL PRIMARY KEY AUTO_INCREMENT,
    slug          VARCHAR(60)  NOT NULL UNIQUE,
    nome          VARCHAR(80)  NOT NULL,
    nome_compacto VARCHAR(80)  NOT NULL,
    marca         VARCHAR(80)  NOT NULL DEFAULT '',
    ano           INT          NULL,
    genero        VARCHAR(20)  NOT NULL DEFAULT '',
    descricao     TEXT         NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Classificação (família olfativa) de cada perfume
CREATE TABLE perfume_familias (
    perfume_id INT         NOT NULL,
    familia    VARCHAR(40) NOT NULL,
    PRIMARY KEY (perfume_id, familia),
    FOREIGN KEY (perfume_id) REFERENCES perfumes(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Pirâmide olfativa: em qual nível (topo, coração ou fundo) está cada nota
CREATE TABLE perfume_notas (
    perfume_id INT         NOT NULL,
    nota_chave VARCHAR(40) NOT NULL,
    nivel      ENUM('topo', 'coracao', 'fundo') NOT NULL,
    ordem      INT         NOT NULL,
    PRIMARY KEY (perfume_id, nota_chave, nivel),
    FOREIGN KEY (perfume_id) REFERENCES perfumes(id) ON DELETE CASCADE,
    FOREIGN KEY (nota_chave) REFERENCES notas(chave)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Palavras pesquisáveis (sem acento, minúsculas) de cada perfume: nome, marca e notas.
-- A busca "começa com" usa esta tabela.
CREATE TABLE perfume_palavras (
    perfume_id INT         NOT NULL,
    palavra    VARCHAR(60) NOT NULL,
    PRIMARY KEY (perfume_id, palavra),
    FOREIGN KEY (perfume_id) REFERENCES perfumes(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE comentarios (
    id         INT          NOT NULL PRIMARY KEY AUTO_INCREMENT,
    perfume_id INT          NOT NULL,
    nome       VARCHAR(80)  NOT NULL,
    email      VARCHAR(120) NOT NULL,
    texto      VARCHAR(500) NOT NULL,
    data       DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_comentarios_perfume (perfume_id, id),
    FOREIGN KEY (perfume_id) REFERENCES perfumes(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE favoritos (
    id         INT          NOT NULL PRIMARY KEY AUTO_INCREMENT,
    perfume_id INT          NOT NULL,
    email      VARCHAR(120) NOT NULL,
    data       DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_favorito (perfume_id, email),
    INDEX idx_favoritos_email (email, id),
    FOREIGN KEY (perfume_id) REFERENCES perfumes(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
