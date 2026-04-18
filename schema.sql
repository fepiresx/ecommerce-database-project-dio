-- =========================================================
-- Projeto: ecommerce_modelo_relacional
-- Desafio DIO - E-commerce
-- SGBD: MySQL 8+
-- Versão ajustada para evitar alertas de depreciação no Workbench
-- =========================================================

DROP DATABASE IF EXISTS ecommerce_modelo_relacional;
CREATE DATABASE ecommerce_modelo_relacional
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_0900_ai_ci;

USE ecommerce_modelo_relacional;

-- =========================================================
-- TABELAS PRINCIPAIS
-- =========================================================

CREATE TABLE cliente (
    id_cliente INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL,
    telefone VARCHAR(20) NULL,
    tipo_cliente ENUM('PF','PJ') NOT NULL,
    ativo TINYINT UNSIGNED NOT NULL DEFAULT 1,
    data_cadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_cliente),
    UNIQUE KEY uk_cliente_email (email),
    CONSTRAINT ck_cliente_ativo CHECK (ativo IN (0,1))
) ENGINE=InnoDB;

CREATE TABLE cliente_pf (
    id_cliente INT UNSIGNED NOT NULL,
    cpf CHAR(11) NOT NULL,
    data_nascimento DATE NULL,
    PRIMARY KEY (id_cliente),
    UNIQUE KEY uk_cliente_pf_cpf (cpf),
    CONSTRAINT ck_cliente_pf_cpf CHECK (cpf REGEXP '^[0-9]{11}$'),
    CONSTRAINT fk_cliente_pf_cliente
        FOREIGN KEY (id_cliente) REFERENCES cliente (id_cliente)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE cliente_pj (
    id_cliente INT UNSIGNED NOT NULL,
    cnpj CHAR(14) NOT NULL,
    razao_social VARCHAR(150) NOT NULL,
    nome_fantasia VARCHAR(150) NULL,
    inscricao_estadual VARCHAR(20) NULL,
    PRIMARY KEY (id_cliente),
    UNIQUE KEY uk_cliente_pj_cnpj (cnpj),
    CONSTRAINT ck_cliente_pj_cnpj CHECK (cnpj REGEXP '^[0-9]{14}$'),
    CONSTRAINT fk_cliente_pj_cliente
        FOREIGN KEY (id_cliente) REFERENCES cliente (id_cliente)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE endereco (
    id_endereco INT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_cliente INT UNSIGNED NOT NULL,
    tipo_endereco ENUM('ENTREGA','COBRANCA','AMBOS') NOT NULL DEFAULT 'ENTREGA',
    apelido VARCHAR(50) NULL,
    logradouro VARCHAR(150) NOT NULL,
    numero VARCHAR(20) NOT NULL,
    complemento VARCHAR(100) NULL,
    bairro VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    estado CHAR(2) NOT NULL,
    cep CHAR(8) NOT NULL,
    pais VARCHAR(60) NOT NULL DEFAULT 'Brasil',
    principal TINYINT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (id_endereco),
    UNIQUE KEY uk_endereco_cliente_composto (id_endereco, id_cliente),
    KEY idx_endereco_cliente (id_cliente),
    CONSTRAINT ck_endereco_principal CHECK (principal IN (0,1)),
    CONSTRAINT fk_endereco_cliente
        FOREIGN KEY (id_cliente) REFERENCES cliente (id_cliente)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE categoria (
    id_categoria INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome VARCHAR(80) NOT NULL,
    descricao VARCHAR(255) NULL,
    id_categoria_pai INT UNSIGNED NULL,
    ativa TINYINT UNSIGNED NOT NULL DEFAULT 1,
    PRIMARY KEY (id_categoria),
    UNIQUE KEY uk_categoria_nome (nome),
    KEY idx_categoria_pai (id_categoria_pai),
    CONSTRAINT ck_categoria_ativa CHECK (ativa IN (0,1)),
    CONSTRAINT fk_categoria_pai
        FOREIGN KEY (id_categoria_pai) REFERENCES categoria (id_categoria)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE produto (
    id_produto INT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_categoria INT UNSIGNED NOT NULL,
    nome VARCHAR(120) NOT NULL,
    descricao VARCHAR(500) NULL,
    sku VARCHAR(50) NOT NULL,
    preco DECIMAL(12,2) NOT NULL,
    peso_kg DECIMAL(8,3) NULL,
    ativo TINYINT UNSIGNED NOT NULL DEFAULT 1,
    data_cadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_produto),
    UNIQUE KEY uk_produto_sku (sku),
    KEY idx_produto_categoria (id_categoria),
    CONSTRAINT ck_produto_preco CHECK (preco >= 0),
    CONSTRAINT ck_produto_ativo CHECK (ativo IN (0,1)),
    CONSTRAINT fk_produto_categoria
        FOREIGN KEY (id_categoria) REFERENCES categoria (id_categoria)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE fornecedor (
    id_fornecedor INT UNSIGNED NOT NULL AUTO_INCREMENT,
    razao_social VARCHAR(150) NOT NULL,
    nome_fantasia VARCHAR(150) NULL,
    cnpj CHAR(14) NOT NULL,
    email VARCHAR(150) NULL,
    telefone VARCHAR(20) NULL,
    ativo TINYINT UNSIGNED NOT NULL DEFAULT 1,
    PRIMARY KEY (id_fornecedor),
    UNIQUE KEY uk_fornecedor_cnpj (cnpj),
    CONSTRAINT ck_fornecedor_ativo CHECK (ativo IN (0,1))
) ENGINE=InnoDB;

CREATE TABLE terceiro_vendedor (
    id_terceiro_vendedor INT UNSIGNED NOT NULL AUTO_INCREMENT,
    razao_social VARCHAR(150) NOT NULL,
    nome_fantasia VARCHAR(150) NULL,
    documento VARCHAR(14) NOT NULL,
    tipo_documento ENUM('CPF','CNPJ') NOT NULL,
    localidade VARCHAR(100) NULL,
    email VARCHAR(150) NULL,
    telefone VARCHAR(20) NULL,
    ativo TINYINT UNSIGNED NOT NULL DEFAULT 1,
    PRIMARY KEY (id_terceiro_vendedor),
    UNIQUE KEY uk_terceiro_vendedor_documento (documento),
    CONSTRAINT ck_terceiro_vendedor_ativo CHECK (ativo IN (0,1)),
    CONSTRAINT ck_terceiro_vendedor_documento CHECK (
        (tipo_documento = 'CPF' AND documento REGEXP '^[0-9]{11}$')
        OR
        (tipo_documento = 'CNPJ' AND documento REGEXP '^[0-9]{14}$')
    )
) ENGINE=InnoDB;

CREATE TABLE estoque (
    id_estoque INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    localidade VARCHAR(100) NOT NULL,
    ativo TINYINT UNSIGNED NOT NULL DEFAULT 1,
    PRIMARY KEY (id_estoque),
    UNIQUE KEY uk_estoque_nome (nome),
    CONSTRAINT ck_estoque_ativo CHECK (ativo IN (0,1))
) ENGINE=InnoDB;

-- =========================================================
-- TABELAS ASSOCIATIVAS
-- =========================================================

CREATE TABLE fornecedor_produto (
    id_fornecedor INT UNSIGNED NOT NULL,
    id_produto INT UNSIGNED NOT NULL,
    custo_compra DECIMAL(12,2) NULL,
    prazo_reposicao_dias SMALLINT UNSIGNED NULL,
    ativo TINYINT UNSIGNED NOT NULL DEFAULT 1,
    PRIMARY KEY (id_fornecedor, id_produto),
    KEY idx_fornecedor_produto_produto (id_produto),
    CONSTRAINT ck_fornecedor_produto_custo CHECK (custo_compra IS NULL OR custo_compra >= 0),
    CONSTRAINT ck_fornecedor_produto_ativo CHECK (ativo IN (0,1)),
    CONSTRAINT fk_fornecedor_produto_fornecedor
        FOREIGN KEY (id_fornecedor) REFERENCES fornecedor (id_fornecedor)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT fk_fornecedor_produto_produto
        FOREIGN KEY (id_produto) REFERENCES produto (id_produto)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE vendedor_produto (
    id_terceiro_vendedor INT UNSIGNED NOT NULL,
    id_produto INT UNSIGNED NOT NULL,
    quantidade INT UNSIGNED NOT NULL DEFAULT 0,
    preco_oferta DECIMAL(12,2) NULL,
    ativo TINYINT UNSIGNED NOT NULL DEFAULT 1,
    PRIMARY KEY (id_terceiro_vendedor, id_produto),
    KEY idx_vendedor_produto_produto (id_produto),
    CONSTRAINT ck_vendedor_produto_qtd CHECK (quantidade >= 0),
    CONSTRAINT ck_vendedor_produto_preco CHECK (preco_oferta IS NULL OR preco_oferta >= 0),
    CONSTRAINT ck_vendedor_produto_ativo CHECK (ativo IN (0,1)),
    CONSTRAINT fk_vendedor_produto_vendedor
        FOREIGN KEY (id_terceiro_vendedor) REFERENCES terceiro_vendedor (id_terceiro_vendedor)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT fk_vendedor_produto_produto
        FOREIGN KEY (id_produto) REFERENCES produto (id_produto)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE produto_estoque (
    id_produto INT UNSIGNED NOT NULL,
    id_estoque INT UNSIGNED NOT NULL,
    quantidade INT UNSIGNED NOT NULL DEFAULT 0,
    estoque_minimo INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (id_produto, id_estoque),
    KEY idx_produto_estoque_estoque (id_estoque),
    CONSTRAINT ck_produto_estoque_quantidade CHECK (quantidade >= 0),
    CONSTRAINT ck_produto_estoque_minimo CHECK (estoque_minimo >= 0),
    CONSTRAINT fk_produto_estoque_produto
        FOREIGN KEY (id_produto) REFERENCES produto (id_produto)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT fk_produto_estoque_estoque
        FOREIGN KEY (id_estoque) REFERENCES estoque (id_estoque)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE pedido (
    id_pedido BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_cliente INT UNSIGNED NOT NULL,
    id_endereco_entrega INT UNSIGNED NOT NULL,
    status_pedido ENUM('CRIADO','AGUARDANDO_PAGAMENTO','PAGO','EM_SEPARACAO','ENVIADO','ENTREGUE','CANCELADO') NOT NULL DEFAULT 'CRIADO',
    descricao VARCHAR(255) NULL,
    data_pedido DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    valor_produtos DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    valor_frete DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    valor_desconto DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    valor_total DECIMAL(12,2) GENERATED ALWAYS AS ((valor_produtos + valor_frete) - valor_desconto) STORED,
    PRIMARY KEY (id_pedido),
    KEY idx_pedido_cliente (id_cliente),
    KEY idx_pedido_status (status_pedido),
    KEY idx_pedido_endereco (id_endereco_entrega, id_cliente),
    CONSTRAINT ck_pedido_valor_produtos CHECK (valor_produtos >= 0),
    CONSTRAINT ck_pedido_valor_frete CHECK (valor_frete >= 0),
    CONSTRAINT ck_pedido_valor_desconto CHECK (valor_desconto >= 0),
    CONSTRAINT ck_pedido_total CHECK (((valor_produtos + valor_frete) - valor_desconto) >= 0),
    CONSTRAINT fk_pedido_cliente
        FOREIGN KEY (id_cliente) REFERENCES cliente (id_cliente)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT fk_pedido_endereco_cliente
        FOREIGN KEY (id_endereco_entrega, id_cliente)
        REFERENCES endereco (id_endereco, id_cliente)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE item_pedido (
    id_pedido BIGINT UNSIGNED NOT NULL,
    id_produto INT UNSIGNED NOT NULL,
    quantidade INT UNSIGNED NOT NULL,
    preco_unitario DECIMAL(12,2) NOT NULL,
    desconto_item DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    status_item ENUM('ATIVO','SEPARADO','ENVIADO','CANCELADO') NOT NULL DEFAULT 'ATIVO',
    PRIMARY KEY (id_pedido, id_produto),
    KEY idx_item_pedido_produto (id_produto),
    CONSTRAINT ck_item_pedido_quantidade CHECK (quantidade > 0),
    CONSTRAINT ck_item_pedido_preco CHECK (preco_unitario >= 0),
    CONSTRAINT ck_item_pedido_desconto CHECK (desconto_item >= 0),
    CONSTRAINT fk_item_pedido_pedido
        FOREIGN KEY (id_pedido) REFERENCES pedido (id_pedido)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_item_pedido_produto
        FOREIGN KEY (id_produto) REFERENCES produto (id_produto)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE pagamento (
    id_pagamento BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_pedido BIGINT UNSIGNED NOT NULL,
    forma_pagamento ENUM('PIX','CARTAO_CREDITO','CARTAO_DEBITO','BOLETO','CARTEIRA_DIGITAL','TRANSFERENCIA') NOT NULL,
    status_pagamento ENUM('PENDENTE','AUTORIZADO','PAGO','RECUSADO','ESTORNADO','CANCELADO') NOT NULL DEFAULT 'PENDENTE',
    valor DECIMAL(12,2) NOT NULL,
    transacao_externa VARCHAR(100) NULL,
    data_pagamento DATETIME NULL,
    data_criacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_pagamento),
    UNIQUE KEY uk_pagamento_transacao_externa (transacao_externa),
    KEY idx_pagamento_pedido (id_pedido),
    CONSTRAINT ck_pagamento_valor CHECK (valor >= 0),
    CONSTRAINT fk_pagamento_pedido
        FOREIGN KEY (id_pedido) REFERENCES pedido (id_pedido)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE entrega (
    id_entrega BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_pedido BIGINT UNSIGNED NOT NULL,
    status_entrega ENUM('PREPARANDO','EM_TRANSITO','ENTREGUE','ATRASADA','DEVOLVIDA','CANCELADA') NOT NULL DEFAULT 'PREPARANDO',
    codigo_rastreio VARCHAR(40) NOT NULL,
    transportadora VARCHAR(100) NULL,
    data_envio DATETIME NULL,
    data_entrega_prevista DATE NULL,
    data_entrega_real DATETIME NULL,
    PRIMARY KEY (id_entrega),
    UNIQUE KEY uk_entrega_pedido (id_pedido),
    UNIQUE KEY uk_entrega_codigo_rastreio (codigo_rastreio),
    CONSTRAINT fk_entrega_pedido
        FOREIGN KEY (id_pedido) REFERENCES pedido (id_pedido)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =========================================================
-- TRIGGERS PARA GARANTIR EXCLUSIVIDADE PF/PJ
-- =========================================================

DELIMITER $$

CREATE TRIGGER trg_cliente_pf_bi
BEFORE INSERT ON cliente_pf
FOR EACH ROW
BEGIN
    DECLARE v_tipo VARCHAR(2);
    DECLARE v_qtd INT DEFAULT 0;

    SELECT tipo_cliente INTO v_tipo
      FROM cliente
     WHERE id_cliente = NEW.id_cliente;

    IF v_tipo IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cliente inexistente para cliente_pf.';
    END IF;

    IF v_tipo <> 'PF' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Apenas clientes PF podem ser inseridos em cliente_pf.';
    END IF;

    SELECT COUNT(*) INTO v_qtd
      FROM cliente_pj
     WHERE id_cliente = NEW.id_cliente;

    IF v_qtd > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cliente ja cadastrado como PJ.';
    END IF;
END$$

CREATE TRIGGER trg_cliente_pj_bi
BEFORE INSERT ON cliente_pj
FOR EACH ROW
BEGIN
    DECLARE v_tipo VARCHAR(2);
    DECLARE v_qtd INT DEFAULT 0;

    SELECT tipo_cliente INTO v_tipo
      FROM cliente
     WHERE id_cliente = NEW.id_cliente;

    IF v_tipo IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cliente inexistente para cliente_pj.';
    END IF;

    IF v_tipo <> 'PJ' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Apenas clientes PJ podem ser inseridos em cliente_pj.';
    END IF;

    SELECT COUNT(*) INTO v_qtd
      FROM cliente_pf
     WHERE id_cliente = NEW.id_cliente;

    IF v_qtd > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cliente ja cadastrado como PF.';
    END IF;
END$$

DELIMITER ;
