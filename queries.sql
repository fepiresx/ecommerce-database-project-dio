USE ecommerce_modelo_relacional;

-- =========================================================
-- queries.sql
-- Consultas de negócio para avaliação do projeto
-- =========================================================

-- Pergunta: Quais clientes estão ativos no sistema?
SELECT
    id_cliente,
    nome,
    email,
    tipo_cliente
FROM cliente
WHERE ativo = 1
ORDER BY nome;

-- Pergunta: Quais produtos ativos estão disponíveis no catálogo?
SELECT
    id_produto,
    nome,
    sku,
    preco
FROM produto
WHERE ativo = 1
ORDER BY nome;

-- Pergunta: Quais pedidos estão com status PAGO?
SELECT
    id_pedido,
    id_cliente,
    data_pedido,
    valor_total
FROM pedido
WHERE status_pedido = 'PAGO'
ORDER BY data_pedido;

-- Pergunta: Quantos pedidos cada cliente realizou?
SELECT
    c.id_cliente,
    c.nome,
    c.tipo_cliente,
    COUNT(p.id_pedido) AS quantidade_pedidos
FROM cliente c
LEFT JOIN pedido p
    ON p.id_cliente = c.id_cliente
GROUP BY c.id_cliente, c.nome, c.tipo_cliente
ORDER BY quantidade_pedidos DESC, c.nome;

-- Pergunta: Qual o valor total gasto por cliente em pedidos não cancelados?
SELECT
    c.id_cliente,
    c.nome,
    ROUND(COALESCE(SUM(p.valor_total), 0), 2) AS total_gasto
FROM cliente c
LEFT JOIN pedido p
    ON p.id_cliente = c.id_cliente
   AND p.status_pedido <> 'CANCELADO'
GROUP BY c.id_cliente, c.nome
ORDER BY total_gasto DESC, c.nome;

-- Pergunta: Quais pedidos possuem múltiplos pagamentos?
SELECT
    p.id_pedido,
    c.nome AS cliente,
    COUNT(pg.id_pagamento) AS qtde_pagamentos,
    ROUND(SUM(pg.valor), 2) AS valor_pago_registrado,
    p.valor_total
FROM pedido p
JOIN cliente c
    ON c.id_cliente = p.id_cliente
JOIN pagamento pg
    ON pg.id_pedido = p.id_pedido
GROUP BY p.id_pedido, c.nome, p.valor_total
HAVING COUNT(pg.id_pagamento) > 1
ORDER BY qtde_pagamentos DESC, p.id_pedido;

-- Pergunta: Existem vendedores que também são fornecedores?
SELECT
    tv.id_terceiro_vendedor,
    tv.razao_social AS vendedor,
    f.id_fornecedor,
    f.razao_social AS fornecedor,
    tv.documento
FROM terceiro_vendedor tv
JOIN fornecedor f
    ON f.cnpj = tv.documento
WHERE tv.tipo_documento = 'CNPJ'
ORDER BY tv.razao_social;

-- Pergunta: Quais produtos estão com baixo estoque?
SELECT
    p.id_produto,
    p.nome AS produto,
    e.nome AS estoque,
    pe.quantidade,
    pe.estoque_minimo,
    (CAST(pe.quantidade AS SIGNED) - CAST(pe.estoque_minimo AS SIGNED)) AS saldo_acima_minimo
FROM produto_estoque pe
JOIN produto p
    ON p.id_produto = pe.id_produto
JOIN estoque e
    ON e.id_estoque = pe.id_estoque
WHERE pe.quantidade <= pe.estoque_minimo
ORDER BY pe.quantidade ASC, p.nome;

-- Pergunta: Qual é a relação entre produtos, fornecedores e estoque consolidado?
SELECT
    p.id_produto,
    p.nome AS produto,
    c.nome AS categoria,
    GROUP_CONCAT(
        DISTINCT COALESCE(f.nome_fantasia, f.razao_social)
        ORDER BY COALESCE(f.nome_fantasia, f.razao_social)
        SEPARATOR ', '
    ) AS fornecedores,
    COALESCE(SUM(pe.quantidade), 0) AS estoque_total
FROM produto p
JOIN categoria c
    ON c.id_categoria = p.id_categoria
LEFT JOIN fornecedor_produto fp
    ON fp.id_produto = p.id_produto
LEFT JOIN fornecedor f
    ON f.id_fornecedor = fp.id_fornecedor
LEFT JOIN produto_estoque pe
    ON pe.id_produto = p.id_produto
GROUP BY p.id_produto, p.nome, c.nome
ORDER BY estoque_total DESC, p.nome;

-- Pergunta: Qual é o ticket médio por cliente considerando apenas pedidos pagos, enviados ou entregues?
SELECT
    c.id_cliente,
    c.nome,
    COUNT(p.id_pedido) AS pedidos_validos,
    ROUND(AVG(p.valor_total), 2) AS ticket_medio
FROM cliente c
JOIN pedido p
    ON p.id_cliente = c.id_cliente
WHERE p.status_pedido IN ('PAGO', 'ENVIADO', 'ENTREGUE')
GROUP BY c.id_cliente, c.nome
HAVING COUNT(p.id_pedido) >= 1
ORDER BY ticket_medio DESC;

-- Pergunta: Qual o faturamento por categoria considerando a receita líquida dos itens vendidos?
SELECT
    cat.nome AS categoria,
    ROUND(SUM((ip.preco_unitario * ip.quantidade) - ip.desconto_item), 2) AS receita_liquida,
    SUM(ip.quantidade) AS unidades_vendidas
FROM item_pedido ip
JOIN produto pr
    ON pr.id_produto = ip.id_produto
JOIN categoria cat
    ON cat.id_categoria = pr.id_categoria
JOIN pedido p
    ON p.id_pedido = ip.id_pedido
WHERE p.status_pedido <> 'CANCELADO'
GROUP BY cat.nome
HAVING SUM(ip.quantidade) > 0
ORDER BY receita_liquida DESC;

-- Pergunta: Quais pedidos apresentam potencial atraso de entrega?
SELECT
    p.id_pedido,
    c.nome AS cliente,
    en.status_entrega,
    en.codigo_rastreio,
    en.data_entrega_prevista,
    DATEDIFF(CURDATE(), en.data_entrega_prevista) AS dias_em_atraso
FROM entrega en
JOIN pedido p
    ON p.id_pedido = en.id_pedido
JOIN cliente c
    ON c.id_cliente = p.id_cliente
WHERE en.status_entrega IN ('PREPARANDO', 'EM_TRANSITO')
  AND en.data_entrega_prevista < CURDATE()
ORDER BY dias_em_atraso DESC, p.id_pedido;

-- Pergunta: Qual é a visão analítica dos clientes com seu documento principal e total em pedidos?
SELECT
    c.id_cliente,
    c.nome,
    c.tipo_cliente,
    CASE
        WHEN c.tipo_cliente = 'PF' THEN CONCAT('CPF: ', pf.cpf)
        WHEN c.tipo_cliente = 'PJ' THEN CONCAT('CNPJ: ', pj.cnpj)
    END AS documento_principal,
    COUNT(DISTINCT p.id_pedido) AS pedidos,
    ROUND(COALESCE(SUM(p.valor_total), 0), 2) AS total_em_pedidos
FROM cliente c
LEFT JOIN cliente_pf pf
    ON pf.id_cliente = c.id_cliente
LEFT JOIN cliente_pj pj
    ON pj.id_cliente = c.id_cliente
LEFT JOIN pedido p
    ON p.id_cliente = c.id_cliente
GROUP BY c.id_cliente, c.nome, c.tipo_cliente, pf.cpf, pj.cnpj
ORDER BY total_em_pedidos DESC, c.nome;

-- Pergunta: Quais produtos estão acima da média de preço do catálogo?
SELECT
    p.id_produto,
    p.nome,
    p.preco
FROM produto p
WHERE p.preco > (
    SELECT AVG(p2.preco)
    FROM produto p2
    WHERE p2.ativo = 1
)
ORDER BY p.preco DESC, p.nome;