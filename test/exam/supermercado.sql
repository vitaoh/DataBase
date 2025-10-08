-- Prova DB : Tiago Setti Mendes e Victor Rodrigues Herculini

-- Criacao do banco Supermercado dentro do System

ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;

CREATE USER supermercado IDENTIFIED BY supermercado;

drop user supermercado;

ALTER USER supermercado QUOTA UNLIMITED ON users;

GRANT CREATE SESSION TO supermercado;
GRANT CREATE TABLE TO supermercado;
GRANT CREATE VIEW TO supermercado;
GRANT CREATE SEQUENCE TO supermercado;
GRANT CREATE SYNONYM TO supermercado;
GRANT CREATE ROLE TO supermercado;
GRANT CREATE USER TO supermercado;

ALTER USER supermercado
DEFAULT TABLESPACE users
TEMPORARY TABLESPACE temp;

-- (a) uma breve descrição o domínio escolhido;
-- Um sistema de supermercado para gerenciar como um todo todas requisições de um Supermercado como:
-- . Cadastro e controle de produtos em estoque
-- . Registro de clientes e seus dados
-- . Gerenciamento de fornecedores
-- . Controle de vendas realizadas e seus respectivos itens


-- (b) a criação de, pelo menos, 5 tabelas com suas devidas restrições de integridade (incluindo as chaves estrangeiras);

CREATE TABLE FORNECEDORES (
    ID INTEGER PRIMARY KEY,
    NOME VARCHAR2(30),
    CNPJ VARCHAR2(18)
);

CREATE TABLE PRODUTOS (
    ID INTEGER PRIMARY KEY,
    NOME VARCHAR2(30),
    PRECO NUMBER(10,2),
    ESTOQUE INTEGER,
    ID_FORNECEDOR INTEGER,
    FOREIGN KEY (ID_FORNECEDOR) REFERENCES FORNECEDORES(ID)
);

CREATE TABLE CLIENTES (
    CPF VARCHAR2(14) PRIMARY KEY,
    NOME VARCHAR2(30),
    EMAIL VARCHAR2(50)
);

CREATE TABLE VENDAS (
    ID_VENDA INTEGER PRIMARY KEY,
    CPF_CLIENTE VARCHAR2(14),
    DATA_VENDA DATE,
    VALOR_TOTAL NUMBER(10,2),
    FOREIGN KEY (CPF_CLIENTE) REFERENCES CLIENTES(CPF)
);

CREATE TABLE ITENS_VENDAS (
    ID_ITEM_VENDA INTEGER PRIMARY KEY,
    ID_VENDA INTEGER,
    ID_PRODUTO INTEGER,
    QUANTIDADE INTEGER,
    PRECO_UNITARIO NUMBER(10,2),
    FOREIGN KEY (ID_VENDA) REFERENCES VENDAS(ID_VENDA),
    FOREIGN KEY (ID_PRODUTO) REFERENCES PRODUTOS(ID)
);


-- (b.1) popularizando o banco Supermercado 

INSERT INTO FORNECEDORES (ID, NOME, CNPJ) VALUES (1, 'Alimentos S.A.', '12.345.678/0001-99');
INSERT INTO FORNECEDORES (ID, NOME, CNPJ) VALUES (2, 'Bebidas Ltda.', '98.765.432/0001-55');
INSERT INTO FORNECEDORES (ID, NOME, CNPJ) VALUES (3, 'Limpeza Rápida', '11.222.333/0001-00');

INSERT INTO PRODUTOS (ID, NOME, PRECO, ESTOQUE, ID_FORNECEDOR) VALUES (1, 'Arroz 5kg', 25.90, 50, 1);
INSERT INTO PRODUTOS (ID, NOME, PRECO, ESTOQUE, ID_FORNECEDOR) VALUES (2, 'Feijão 1kg', 8.50, 30, 1);
INSERT INTO PRODUTOS (ID, NOME, PRECO, ESTOQUE, ID_FORNECEDOR) VALUES (3, 'Refrigerante 2L', 6.75, 100, 2);
INSERT INTO PRODUTOS (ID, NOME, PRECO, ESTOQUE, ID_FORNECEDOR) VALUES (4, 'Sabão em pó 1kg', 12.00, 20, 3);
INSERT INTO PRODUTOS (ID, NOME, PRECO, ESTOQUE, ID_FORNECEDOR) VALUES (5, 'Detergente 500ml', 3.20, 10, 3);

INSERT INTO CLIENTES (CPF, NOME, EMAIL) VALUES ('123.456.789-00', 'João Silva', 'joao@email.com');
INSERT INTO CLIENTES (CPF, NOME, EMAIL) VALUES ('987.654.321-11', 'Maria Souza', 'maria@email.com');
INSERT INTO CLIENTES (CPF, NOME, EMAIL) VALUES ('111.222.333-44', 'Carlos Lima', 'carlos@email.com');

INSERT INTO VENDAS (ID_VENDA, CPF_CLIENTE, DATA_VENDA, VALOR_TOTAL) VALUES (1, '123.456.789-00', TO_DATE('2025-10-01', 'YYYY-MM-DD'), 34.40);
INSERT INTO VENDAS (ID_VENDA, CPF_CLIENTE, DATA_VENDA, VALOR_TOTAL) VALUES (2, '987.654.321-11', TO_DATE('2025-10-02', 'YYYY-MM-DD'), 50.15);
INSERT INTO VENDAS (ID_VENDA, CPF_CLIENTE, DATA_VENDA, VALOR_TOTAL) VALUES (3, '123.456.789-00', TO_DATE('2025-10-03', 'YYYY-MM-DD'), 13.50);
INSERT INTO VENDAS (ID_VENDA, CPF_CLIENTE, DATA_VENDA, VALOR_TOTAL) VALUES (4, '111.222.333-44', TO_DATE('2025-10-05', 'YYYY-MM-DD'), 75.00);

INSERT INTO ITENS_VENDAS (ID_ITEM_VENDA, ID_VENDA, ID_PRODUTO, QUANTIDADE, PRECO_UNITARIO)
VALUES (1, 1, 2, 2, 8.50); -- Feijão

INSERT INTO ITENS_VENDAS (ID_ITEM_VENDA, ID_VENDA, ID_PRODUTO, QUANTIDADE, PRECO_UNITARIO)
VALUES (2, 1, 5, 1, 3.20); -- Detergente

INSERT INTO ITENS_VENDAS (ID_ITEM_VENDA, ID_VENDA, ID_PRODUTO, QUANTIDADE, PRECO_UNITARIO)
VALUES (3, 2, 1, 2, 25.90); -- Arroz

INSERT INTO ITENS_VENDAS (ID_ITEM_VENDA, ID_VENDA, ID_PRODUTO, QUANTIDADE, PRECO_UNITARIO)
VALUES (4, 2, 4, 1, 12.00); -- Sabão

INSERT INTO ITENS_VENDAS (ID_ITEM_VENDA, ID_VENDA, ID_PRODUTO, QUANTIDADE, PRECO_UNITARIO)
VALUES (5, 3, 3, 2, 6.75); -- Refrigerante

INSERT INTO ITENS_VENDAS (ID_ITEM_VENDA, ID_VENDA, ID_PRODUTO, QUANTIDADE, PRECO_UNITARIO)
VALUES (6, 4, 1, 1, 25.90); -- Arroz

INSERT INTO ITENS_VENDAS (ID_ITEM_VENDA, ID_VENDA, ID_PRODUTO, QUANTIDADE, PRECO_UNITARIO)
VALUES (7, 4, 2, 2, 8.50); -- Feijão

INSERT INTO ITENS_VENDAS (ID_ITEM_VENDA, ID_VENDA, ID_PRODUTO, QUANTIDADE, PRECO_UNITARIO)
VALUES (8, 4, 3, 3, 6.75); -- Refrigerante


-- (c) a criação de 5 consultas complexas, com a explicação, para cada uma do porquê ela é uma consulta complexa;

-- Total de vendas por cliente, ordenado pelo maior valor
SELECT CPF_CLIENTE, SUM(VALOR_TOTAL) AS TOTAL_GASTO
FROM VENDAS
GROUP BY CPF_CLIENTE
ORDER BY TOTAL_GASTO DESC;
-- Complexa por usar agregação (SUM), GROUP BY e ORDER BY

-- Produtos mais vendidos (em quantidade)
SELECT P.NOME, SUM(IV.QUANTIDADE) AS TOTAL_VENDIDO
FROM ITENS_VENDAS IV
JOIN PRODUTOS P ON P.ID = IV.ID_PRODUTO
GROUP BY P.NOME
ORDER BY TOTAL_VENDIDO DESC;
-- Tem JOIN, agregação e ordenação

-- Vendas realizadas em um período específico (últimos 30 dias)
SELECT * FROM VENDAS
WHERE DATA_VENDA >= SYSDATE - 30;
-- Usa função de data (SYSDATE)

-- Produtos com estoque abaixo ou igual a 30 unidades
SELECT * FROM PRODUTOS
WHERE ESTOQUE <= 30;
-- Filtro condicional (<=)

-- Valor médio gasto por cliente
SELECT CPF_CLIENTE, AVG(VALOR_TOTAL) AS VALOR_MEDIO
FROM VENDAS
GROUP BY CPF_CLIENTE
HAVING AVG(VALOR_TOTAL) > 50;
-- Usa função agregada (AVG), GROUP BY e HAVING


-- (d) a criação de 3 subconsultas, com a explicação do porquê de sua classificação como subconsulta;

-- Clientes que fizeram pelo menos uma compra
SELECT * FROM CLIENTES
WHERE CPF IN (SELECT CPF_CLIENTE FROM VENDAS);
-- Subconsulta por causa do IN

-- Produto mais caro
SELECT * FROM PRODUTOS
WHERE PRECO = (SELECT MAX(PRECO) FROM PRODUTOS);
-- Subconsulta que retorna um valor

-- Fornecedores com produtos em estoque
SELECT * FROM FORNECEDORES
WHERE ID IN (
    SELECT ID_FORNECEDOR FROM PRODUTOS WHERE ESTOQUE > 0
);
-- Subconsulta dependente de outra tabela


-- (e) a criação de, pelo menos, 3 visões. Dê preferência para as visões que teriam maior utilidade para os usuários e explique o motivo da sua escolha;

-- Visão de produtos com estoque baixo
CREATE VIEW VW_ESTOQUE_BAIXO AS
SELECT ID, NOME, ESTOQUE
FROM PRODUTOS
WHERE ESTOQUE < 10;
-- Útil para equipe de compras monitorar estoque

-- Visão de vendas com dados do cliente
CREATE VIEW VW_VENDAS_CLIENTES AS
SELECT V.ID_VENDA, V.DATA_VENDA, V.VALOR_TOTAL, C.NOME, C.CPF
FROM VENDAS V
JOIN CLIENTES C ON C.CPF = V.CPF_CLIENTE;
-- Facilita relatórios de vendas dividido por cliente

-- Visão de faturamento por produto
CREATE VIEW VW_FATURAMENTO_PRODUTO AS
SELECT P.NOME, SUM(IV.QUANTIDADE * IV.PRECO_UNITARIO) AS FATURAMENTO
FROM ITENS_VENDAS IV
JOIN PRODUTOS P ON P.ID = IV.ID_PRODUTO
GROUP BY P.NOME;
-- Mostra o desempenho por produto

-- Visões
select * from VW_ESTOQUE_BAIXO;
select * from VW_VENDAS_CLIENTES;
select * from VW_FATURAMENTO_PRODUTO;

-- (f) a criação de, pelo menos, 3 papéis (roles) e explicação do motivo da sua escolha;

-- Papel para equipe de vendas
CREATE ROLE VENDAS_ROLE;
GRANT SELECT, INSERT ON VENDAS TO VENDAS_ROLE;
GRANT SELECT, INSERT ON ITENS_VENDAS TO VENDAS_ROLE;

-- Papel para equipe de estoque
CREATE ROLE ESTOQUE_ROLE;
GRANT SELECT, UPDATE ON PRODUTOS TO ESTOQUE_ROLE;

-- Papel para gerência
CREATE ROLE GERENCIA_ROLE;
GRANT SELECT ON VW_FATURAMENTO_PRODUTO TO GERENCIA_ROLE;
GRANT SELECT ON VW_VENDAS_CLIENTES TO GERENCIA_ROLE;


-- (g) a criação de, pelo menos 5 usuários e a aplicação de seus papéis.

CREATE USER tiago IDENTIFIED BY tiago;
CREATE USER victor IDENTIFIED BY victor;
CREATE USER luiz IDENTIFIED BY luiz;
CREATE USER cauan IDENTIFIED BY cauan;
CREATE USER lucas IDENTIFIED BY lucas;
CREATE USER leal IDENTIFIED BY leal;

GRANT GERENCIA_ROLE TO leal; -- leal é o gerente do supermercado
GRANT VENDAS_ROLE TO tiago, victor; -- tiago e victor são da equipe de venda
GRANT ESTOQUE_ROLE TO luiz, cauan, lucas; -- lucas, luiz e cauan são da equipe de estoque