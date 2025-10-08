-- // 🧾 LISTA DE EXERCÍCIOS – Revisão para Prova de Database \\ --

-- 🔹 0. Criacao do Usuario Simulado

ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;

CREATE USER simulado IDENTIFIED BY simulado;

ALTER USER simulado QUOTA UNLIMITED ON users;

GRANT CREATE SESSION TO simulado;
GRANT CREATE TABLE TO simulado;
GRANT CREATE VIEW TO simulado;
GRANT CREATE SEQUENCE TO simulado;
GRANT CREATE SYNONYM TO simulado;

ALTER USER simulado
DEFAULT TABLESPACE users
TEMPORARY TABLESPACE temp;

-- 🔹 1. Índices e Sinônimos

CREATE TABLE PRODUTOS (
    ID NUMBER PRIMARY KEY,
    NOME VARCHAR2(30),
    PRECO NUMBER(10,2),
    ESTOQUE NUMBER
);

INSERT INTO PRODUTOS VALUES (1, 'Arroz', 28.99, 100);
INSERT INTO PRODUTOS VALUES (2, 'Feijao', 15.99, 80);
INSERT INTO PRODUTOS VALUES (3, 'Carne', 89.99, 50);
INSERT INTO PRODUTOS VALUES (4, 'Ovo', 19.99, 60);
INSERT INTO PRODUTOS VALUES (5, 'Frango', 29.99, 70);

-- Crie um índice não exclusivo sobre a coluna NOME.
CREATE INDEX IDX_PRODUTOS_NOME ON PRODUTOS(NOME);

-- Crie um índice exclusivo sobre a coluna ID.
CREATE UNIQUE INDEX UQ_PRODUTOS_ID ON PRODUTOS(ID);

-- Verifique os índices existentes com o comando apropriado.
SELECT INDEX_NAME, TABLE_NAME, UNIQUENESS FROM USER_INDEXES;

-- Crie um sinônimo chamado ITENS que aponte para PRODUTOS.
CREATE SYNONYM ITEMS FOR PRODUTOS;

SELECT * FROM ITENS;

-- Sinonimo publico tem a visibilidade para todos os usuarios que tenham a permissao,
-- ja o privado e exclusivamente do usario ou esquema.


-- 🔹 2. Junção (JOIN)

CREATE TABLE CLIENTES (
    ID INTEGER PRIMARY KEY,
    NOME VARCHAR2(30),
    CIDADE_ID INTEGER,
    FOREIGN KEY (CIDADE_ID) REFERENCES CIDADES(ID)
);

CREATE TABLE CIDADES (
    ID INTEGER PRIMARY KEY,
    NOME VARCHAR(30)
);

INSERT INTO CIDADES (ID, NOME) VALUES (1, 'São Paulo');
INSERT INTO CIDADES (ID, NOME) VALUES (2, 'Rio de Janeiro');
INSERT INTO CIDADES (ID, NOME) VALUES (3, 'Belo Horizonte');

INSERT INTO CLIENTES (ID, NOME, CIDADE_ID) VALUES (1, 'Victor', 1);
INSERT INTO CLIENTES (ID, NOME, CIDADE_ID) VALUES (2, 'Luiz', 2);
INSERT INTO CLIENTES (ID, NOME, CIDADE_ID) VALUES (3, 'Tiago', 3);

-- Faça um INNER JOIN para listar o nome do cliente e o nome da cidade.
SELECT cl.nome AS cliente, cd.nome AS cidade
FROM clientes cl
INNER JOIN cidades cd ON cl.cidade_id = cd.id;

-- Faça um LEFT JOIN para listar todos os clientes, mesmo sem cidade cadastrada.
SELECT cl.nome AS cliente, cd.nome AS cidade
FROM clientes cl
LEFT JOIN cidades cd ON cl.cidade_id = cd.id;

-- Faça um RIGHT JOIN para listar todas as cidades, mesmo sem clientes.
SELECT cl.nome AS cliente, cd.nome AS cidade
FROM clientes cl
RIGHT JOIN cidades cd ON cl.cidade_id = cd.id;

-- Faça um SELF JOIN (ex.: funcionários e seus gerentes).
-- Exemplo ilustrativo:
CREATE TABLE FUNCIONARIOS (
    ID NUMBER PRIMARY KEY,
    NOME VARCHAR2(30),
    GERENTE_ID NUMBER
);

INSERT INTO FUNCIONARIOS VALUES (1, 'Carlos', NULL);
INSERT INTO FUNCIONARIOS VALUES (2, 'Ana', 1);
INSERT INTO FUNCIONARIOS VALUES (3, 'Pedro', 1);

SELECT f1.nome AS funcionario, f2.nome AS gerente
FROM funcionarios f1
LEFT JOIN funcionarios f2 ON f1.gerente_id = f2.id;

-- Faça um CROSS JOIN entre CLIENTES e CIDADES.
SELECT cl.nome AS cliente, cd.nome AS cidade
FROM clientes cl
CROSS JOIN cidades cd;

-- Explique o que aconteceria se o critério de junção fosse omitido.
-- Sem critério de junção, ocorre um produto cartesiano, combinando todos os registros
-- de uma tabela com todos da outra, podendo gerar milhares de linhas desnecessárias.


-- 🔹 3. Processamento de Transações

CREATE TABLE CONTA (
    ID NUMBER PRIMARY KEY,
    TITULAR VARCHAR2(30),
    SALDO NUMBER(10,2)
);

INSERT INTO CONTA VALUES (1, 'Victor', 1000);
INSERT INTO CONTA VALUES (2, 'Luiz', 500);

-- Inicie uma transação
SAVEPOINT inicio_transacao;

-- Transfira R$100 da conta 1 para a conta 2
UPDATE CONTA SET SALDO = SALDO - 100 WHERE ID = 1;
UPDATE CONTA SET SALDO = SALDO + 100 WHERE ID = 2;

-- Use ROLLBACK e verifique se as alterações foram desfeitas.
ROLLBACK TO inicio_transacao;

-- Repita a operação e finalize com COMMIT.
UPDATE CONTA SET SALDO = SALDO - 100 WHERE ID = 1;
UPDATE CONTA SET SALDO = SALDO + 100 WHERE ID = 2;
COMMIT;

-- Rollback esta inserido para cancelar mudancas feitas e cancelando o passo de alteracao para o resultado final.
-- Commit e um comando para salvar as mudancas feitas em uma banco.

-- Atomicidade, Consistência, Isolamento e Durabilidade.
-- Garante integridade e confiabilidade dos dados, Evita perda de dados ou inconsistência em operações críticas e é essencial para sistemas financeiros, e-commerce, ERPs, e qualquer aplicação que manipule informações importantes.


-- 🔹 4. Revisão de SELECT

-- Faça um SELECT com alias de colunas e de tabela.
SELECT p.nome AS produto, p.preco AS valor FROM produtos p;

-- Liste os 3 primeiros registros usando FETCH FIRST.
SELECT * FROM produtos FETCH FIRST 3 ROWS ONLY;

-- Ordene por nome em ordem decrescente.
SELECT * FROM produtos ORDER BY nome DESC;

-- Selecione apenas produtos com preço maior que 100.
SELECT * FROM produtos WHERE preco > 100;

-- Utilize DISTINCT para eliminar valores repetidos.
SELECT DISTINCT nome FROM produtos;

-- Use BETWEEN, IN, LIKE e IS NULL em consultas separadas.
SELECT * FROM produtos WHERE preco BETWEEN 20 AND 50;
SELECT * FROM produtos WHERE id IN (1,3,5);
SELECT * FROM produtos WHERE nome LIKE '%a%';
SELECT * FROM produtos WHERE estoque IS NULL;

-- Faça um SELECT aninhado (subconsulta no WHERE).
SELECT * FROM produtos WHERE preco > (SELECT AVG(preco) FROM produtos);

-- Utilize uma função de agregação (COUNT, AVG, MAX, SUM).
SELECT COUNT(*) AS total, AVG(preco) AS media, MAX(preco) AS maior, SUM(estoque) AS total_estoque FROM produtos;


-- 🔹 5. Sequências (SEQUENCE)

CREATE SEQUENCE SEQ_CLIENTE START WITH 1 INCREMENT BY 1;

INSERT INTO clientes VALUES (SEQ_CLIENTE.NEXTVAL, 'Mateus', 1);

SELECT SEQ_CLIENTE.CURRVAL AS atual, SEQ_CLIENTE.NEXTVAL AS proximo FROM dual;

-- Explique o que acontece se uma sequência for usada em transações com ROLLBACK.
-- Mesmo que o ROLLBACK seja executado, o valor da sequência não volta atrás,
-- pois ela é independente das transações.


-- 🔹 6. Subconsultas

-- Liste todos os produtos cujo preço é maior que a média dos preços.
SELECT * FROM produtos WHERE preco > (SELECT AVG(preco) FROM produtos);

-- Liste clientes que não fizeram pedidos (NOT IN).
-- Exemplo (supondo tabela PEDIDOS):
CREATE TABLE PEDIDOS (
    ID NUMBER PRIMARY KEY,
    CLIENTE_ID NUMBER,
    FOREIGN KEY (CLIENTE_ID) REFERENCES CLIENTES(ID)
);

INSERT INTO PEDIDOS VALUES (1, 1);
INSERT INTO PEDIDOS VALUES (2, 2);

SELECT * FROM clientes WHERE id NOT IN (SELECT cliente_id FROM pedidos);

-- Liste os produtos que aparecem em pelo menos um pedido (EXISTS).
-- Exemplo (supondo tabela ITENS_PEDIDO):
CREATE TABLE ITENS_PEDIDO (
    ID NUMBER PRIMARY KEY,
    PRODUTO_ID NUMBER,
    FOREIGN KEY (PRODUTO_ID) REFERENCES PRODUTOS(ID)
);

INSERT INTO ITENS_PEDIDO VALUES (1, 1);
INSERT INTO ITENS_PEDIDO VALUES (2, 3);

SELECT * FROM produtos p WHERE EXISTS (SELECT 1 FROM itens_pedido ip WHERE ip.produto_id = p.id);

-- Compare o resultado de uma subconsulta correlacionada e não correlacionada.
-- A correlacionada depende de cada linha da consulta externa,
-- já a não correlacionada executa apenas uma vez, independentemente da consulta externa.


-- 🔹 7. Usuários e Privilégios

CREATE USER teste_user IDENTIFIED BY 1234;

GRANT CREATE SESSION TO teste_user;
GRANT SELECT ON produtos TO teste_user;

REVOKE SELECT ON produtos FROM teste_user;

-- GRANT concede privilégios a um usuário, enquanto REVOKE remove esses privilégios.

-- Privilégios de sistema permitem executar ações no banco (como criar tabelas),
-- enquanto privilégios de objeto se aplicam a objetos específicos (como SELECT em uma tabela).

-- Um papel (ROLE) é um conjunto de privilégios que pode ser atribuído a vários usuários.
-- Já um usuário (USER) é uma conta individual que pode receber papéis e permissões específicas.


-- 🔹 8. Visões (VIEWS)

CREATE TABLE CLIENTES_STATUS (
    ID NUMBER PRIMARY KEY,
    NOME VARCHAR2(30),
    STATUS VARCHAR2(10)
);

INSERT INTO CLIENTES_STATUS VALUES (1, 'Victor', 'Ativo');
INSERT INTO CLIENTES_STATUS VALUES (2, 'Luiz', 'Inativo');
INSERT INTO CLIENTES_STATUS VALUES (3, 'Tiago', 'Ativo');

CREATE VIEW VW_CLIENTES_ATIVOS AS
SELECT * FROM CLIENTES_STATUS WHERE STATUS = 'Ativo';

SELECT * FROM VW_CLIENTES_ATIVOS;

-- Tente fazer um UPDATE na view e explique o resultado.
UPDATE VW_CLIENTES_ATIVOS SET nome = 'Vitor' WHERE id = 1;
-- O UPDATE só é permitido se a view for simples (baseada em uma única tabela e sem funções de grupo).

-- Crie uma view com junção entre CLIENTES e PEDIDOS.
CREATE VIEW VW_CLIENTES_PEDIDOS AS
SELECT c.nome AS cliente, p.id AS pedido_id
FROM clientes c
INNER JOIN pedidos p ON c.id = p.cliente_id;

-- Crie uma view com alias de colunas.
CREATE VIEW VW_PRODUTOS_ALIAS (codigo, descricao, valor) AS
SELECT id, nome, preco FROM produtos;

-- Explique a diferença entre view simples e view complexa.
-- View simples baseia-se em uma única tabela e permite DML (INSERT, UPDATE, DELETE).
-- View complexa envolve junções, funções de grupo ou subconsultas e geralmente é apenas leitura.

-- Explique o que acontece se a tabela base de uma view for removida.
-- Se a tabela base for removida, a view se torna inválida e não pode mais ser consultada
-- até que a tabela original seja recriada.