USE ecommerce_modelo_relacional;

INSERT INTO cliente (id_cliente, nome, email, telefone, tipo_cliente, ativo) VALUES
(1, 'João da Silva', 'joao.silva@email.com', '11988887777', 'PF', 1),
(2, 'Maria Oliveira', 'maria.oliveira@email.com', '21977776666', 'PF', 1),
(3, 'Tech Solutions Ltda', 'compras@techsolutions.com.br', '1133334444', 'PJ', 1),
(4, 'Loja Alpha ME', 'contato@lojaalpha.com.br', '3132221111', 'PJ', 1),
(5, 'Carla Mendes', 'carla.mendes@email.com', '41966665555', 'PF', 1);

INSERT INTO cliente_pf (id_cliente, cpf, data_nascimento) VALUES
(1, '12345678901', '1992-03-15'),
(2, '98765432100', '1988-11-02'),
(5, '45612378900', '1995-07-21');

INSERT INTO cliente_pj (id_cliente, cnpj, razao_social, nome_fantasia, inscricao_estadual) VALUES
(3, '11222333000181', 'Tech Solutions Ltda', 'Tech Solutions', '123456789'),
(4, '99888777000155', 'Loja Alpha ME', 'Loja Alpha', '987654321');

INSERT INTO endereco
(id_endereco, id_cliente, tipo_endereco, apelido, logradouro, numero, complemento, bairro, cidade, estado, cep, pais, principal) VALUES
(1, 1, 'AMBOS', 'Casa', 'Rua das Flores', '120', 'Apto 12', 'Centro', 'São Paulo', 'SP', '01001000', 'Brasil', 1),
(2, 2, 'ENTREGA', 'Residencial', 'Av. Atlântica', '450', NULL, 'Copacabana', 'Rio de Janeiro', 'RJ', '22021001', 'Brasil', 1),
(3, 3, 'COBRANCA', 'Matriz', 'Rua da Tecnologia', '1000', '5º andar', 'Savassi', 'Belo Horizonte', 'MG', '30112000', 'Brasil', 1),
(4, 3, 'ENTREGA', 'CD BH', 'Av. Industrial', '2500', 'Galpão B', 'Distrito Industrial', 'Contagem', 'MG', '32210110', 'Brasil', 0),
(5, 4, 'AMBOS', 'Loja', 'Rua do Comércio', '89', NULL, 'Centro', 'Curitiba', 'PR', '80010000', 'Brasil', 1),
(6, 5, 'AMBOS', 'Apartamento', 'Rua das Acácias', '77', 'Bloco C', 'Jardins', 'Porto Alegre', 'RS', '90010020', 'Brasil', 1);

INSERT INTO categoria (id_categoria, nome, descricao, id_categoria_pai, ativa) VALUES
(1, 'Eletrônicos', 'Produtos eletrônicos em geral', NULL, 1),
(2, 'Informática', 'Equipamentos de informática', 1, 1),
(3, 'Acessórios', 'Acessórios para dispositivos', 1, 1),
(4, 'Casa Inteligente', 'Dispositivos smart home', 1, 1);

INSERT INTO produto (id_produto, id_categoria, nome, descricao, sku, preco, peso_kg, ativo) VALUES
(1, 2, 'Notebook Pro 14', 'Notebook profissional 14 polegadas', 'SKU-NB-001', 4599.90, 1.450, 1),
(2, 2, 'Mouse Sem Fio', 'Mouse ergonômico bluetooth', 'SKU-MS-002', 129.90, 0.090, 1),
(3, 3, 'Teclado Mecânico', 'Teclado mecânico RGB ABNT2', 'SKU-TC-003', 349.90, 0.850, 1),
(4, 4, 'Lâmpada Smart Wi-Fi', 'Lâmpada inteligente compatível com assistentes', 'SKU-LP-004', 79.90, 0.120, 1),
(5, 2, 'Monitor 27 4K', 'Monitor UHD de 27 polegadas', 'SKU-MN-005', 1899.00, 4.300, 1),
(6, 3, 'Headset Gamer', 'Headset com microfone e som surround', 'SKU-HS-006', 299.00, 0.400, 1);

INSERT INTO fornecedor (id_fornecedor, razao_social, nome_fantasia, cnpj, email, telefone, ativo) VALUES
(1, 'Distribuidora Tech Supply Ltda', 'Tech Supply', '44555666000199', 'vendas@techsupply.com.br', '1130304040', 1),
(2, 'Importadora Vision S/A', 'Vision Import', '22333444000177', 'comercial@vision.com.br', '2120203030', 1),
(3, 'Loja Alpha ME', 'Loja Alpha', '99888777000155', 'compras@lojaalpha.com.br', '3132221111', 1);

INSERT INTO terceiro_vendedor (id_terceiro_vendedor, razao_social, nome_fantasia, documento, tipo_documento, localidade, email, telefone, ativo) VALUES
(1, 'Marketplace Alpha Ltda', 'Alpha Seller', '66777888000144', 'CNPJ', 'São Paulo', 'seller@alpha.com.br', '1144445555', 1),
(2, 'Loja Alpha ME', 'Loja Alpha', '99888777000155', 'CNPJ', 'Curitiba', 'vendas@lojaalpha.com.br', '3132221111', 1),
(3, 'Carlos Pereira', 'Carlos Tech', '12312312399', 'CPF', 'Recife', 'carlos@tech.com', '81999990000', 1);

INSERT INTO estoque (id_estoque, nome, localidade, ativo) VALUES
(1, 'CD São Paulo', 'São Paulo', 1),
(2, 'CD Minas Gerais', 'Contagem', 1),
(3, 'Loja Curitiba', 'Curitiba', 1);

INSERT INTO fornecedor_produto (id_fornecedor, id_produto, custo_compra, prazo_reposicao_dias, ativo) VALUES
(1, 1, 3900.00, 15, 1),
(1, 2, 80.00, 10, 1),
(1, 3, 220.00, 12, 1),
(2, 4, 45.00, 20, 1),
(2, 5, 1500.00, 18, 1),
(3, 6, 210.00, 7, 1);

INSERT INTO vendedor_produto (id_terceiro_vendedor, id_produto, quantidade, preco_oferta, ativo) VALUES
(1, 2, 45, 124.90, 1),
(1, 4, 60, 75.90, 1),
(2, 3, 12, 339.90, 1),
(2, 6, 8, 289.00, 1),
(3, 2, 5, 127.50, 1);

INSERT INTO produto_estoque (id_produto, id_estoque, quantidade, estoque_minimo) VALUES
(1, 1, 15, 5),
(2, 1, 120, 30),
(3, 1, 40, 10),
(4, 2, 18, 20),
(5, 2, 9, 6),
(6, 3, 6, 8);

INSERT INTO pedido
(id_pedido, id_cliente, id_endereco_entrega, status_pedido, descricao, data_pedido, valor_produtos, valor_frete, valor_desconto) VALUES
(1001, 1, 1, 'PAGO', 'Pedido com notebook e mouse', '2026-04-10 10:15:00', 4729.80, 39.90, 100.00),
(1002, 2, 2, 'ENVIADO', 'Pedido de acessórios', '2026-04-11 14:20:00', 648.80, 25.00, 0.00),
(1003, 3, 4, 'AGUARDANDO_PAGAMENTO', 'Pedido corporativo de monitores', '2026-04-12 09:05:00', 3798.00, 120.00, 150.00),
(1004, 5, 6, 'ENTREGUE', 'Pedido de lâmpadas smart', '2026-04-13 19:40:00', 239.70, 18.00, 10.00),
(1005, 4, 5, 'PAGO', 'Pedido loja Alpha', '2026-04-14 11:30:00', 299.00, 20.00, 0.00);

INSERT INTO item_pedido
(id_pedido, id_produto, quantidade, preco_unitario, desconto_item, status_item) VALUES
(1001, 1, 1, 4599.90, 100.00, 'ATIVO'),
(1001, 2, 1, 129.90, 0.00, 'ATIVO'),
(1002, 2, 2, 129.90, 0.00, 'ENVIADO'),
(1002, 3, 1, 349.00, 0.00, 'ENVIADO'),
(1002, 6, 1, 40.00, 0.00, 'ENVIADO'),
(1003, 5, 2, 1899.00, 0.00, 'ATIVO'),
(1004, 4, 3, 79.90, 10.00, 'ENVIADO'),
(1005, 6, 1, 299.00, 0.00, 'ATIVO');

INSERT INTO pagamento
(id_pagamento, id_pedido, forma_pagamento, status_pagamento, valor, transacao_externa, data_pagamento, data_criacao) VALUES
(1, 1001, 'PIX', 'PAGO', 2000.00, 'PIX1001A', '2026-04-10 10:20:00', '2026-04-10 10:16:00'),
(2, 1001, 'CARTAO_CREDITO', 'PAGO', 2669.70, 'CC1001B', '2026-04-10 10:22:00', '2026-04-10 10:17:00'),
(3, 1002, 'BOLETO', 'PAGO', 673.80, 'BL1002A', '2026-04-11 16:00:00', '2026-04-11 14:25:00'),
(4, 1003, 'TRANSFERENCIA', 'PENDENTE', 3768.00, 'TR1003A', NULL, '2026-04-12 09:10:00'),
(5, 1004, 'CARTEIRA_DIGITAL', 'PAGO', 247.70, 'CD1004A', '2026-04-13 19:45:00', '2026-04-13 19:41:00'),
(6, 1005, 'CARTAO_DEBITO', 'AUTORIZADO', 319.00, 'DB1005A', '2026-04-14 11:33:00', '2026-04-14 11:31:00');

INSERT INTO entrega
(id_entrega, id_pedido, status_entrega, codigo_rastreio, transportadora, data_envio, data_entrega_prevista, data_entrega_real) VALUES
(1, 1001, 'PREPARANDO', 'BRTRK1001', 'Log Brasil', '2026-04-10 16:00:00', '2026-04-15', NULL),
(2, 1002, 'EM_TRANSITO', 'BRTRK1002', 'Rápido Express', '2026-04-12 08:30:00', '2026-04-16', NULL),
(3, 1003, 'PREPARANDO', 'BRTRK1003', 'Cargo Minas', NULL, '2026-04-20', NULL),
(4, 1004, 'ENTREGUE', 'BRTRK1004', 'Sul Delivery', '2026-04-14 09:00:00', '2026-04-16', '2026-04-15 13:22:00'),
(5, 1005, 'PREPARANDO', 'BRTRK1005', 'PR Log', '2026-04-14 18:10:00', '2026-04-18', NULL);
