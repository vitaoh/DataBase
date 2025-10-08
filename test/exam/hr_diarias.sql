-- Prova DB : Tiago Setti Mendes e Victor Rodrigues Herculini

-- Questão 1. Considerando esse contexto, realize as seguintes operações:

-- a) Definir o novo usuário “hr_diarias”. Atribua a ele uma cota de 5MB para o tablespace padrão USERS e utilize o tablespace TEMP para dados temporários.

ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE; -- (dentro do SYSTEM)

CREATE USER hr_diarias
IDENTIFIED BY senha123
DEFAULT TABLESPACE users
TEMPORARY TABLESPACE temp
QUOTA 5M ON users; -- (dentro do SYSTEM)


-- b) Conceda ao usuário “hr_diarias” os privilégios necessários para conectar sessões de BD, criar tabelas, criar sequências, criar visões, consultar e referenciar as tabelas necessárias do usuário HR.

GRANT CONNECT, CREATE SESSION, CREATE TABLE, CREATE SEQUENCE, CREATE VIEW TO hr_diarias; -- (dentro do SYSTEM)

GRANT SELECT, REFERENCES ON hr.employees TO hr_diarias; -- (dentro do SYSTEM)
GRANT SELECT, REFERENCES ON hr.departments TO hr_diarias; -- (dentro do SYSTEM)


-- c) Conectado como o usuário “hr_diarias”, crie a tabela “DIARIAS”, considerando as restrições de integridade necessárias.

CREATE TABLE diarias (
    id_diaria     NUMBER(4,0) PRIMARY KEY,
    employee_id   NUMBER(6,0) NOT NULL,
    motivo        VARCHAR2(100),
    data_ida      DATE,
    destino       VARCHAR2(50),
    qtd_diarias   INT,
    CONSTRAINT fk_diarias_employees FOREIGN KEY (employee_id)
        REFERENCES hr.employees(employee_id)
);


-- d) Conectado como o usuário “hr_diarias”, defina uma sequência para gerar valores para a coluna “id_diaria” da tabela “DIARIAS”.

CREATE SEQUENCE seq_id_diaria
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

INSERT INTO diarias (id_diaria, employee_id, motivo, data_ida, destino, qtd_diarias)
VALUES (seq_id_diaria.NEXTVAL, 100, 'Reunião com cliente', TO_DATE('2025-09-10','YYYY-MM-DD'), 'Rio de Janeiro', 3);

INSERT INTO diarias (id_diaria, employee_id, motivo, data_ida, destino, qtd_diarias)
VALUES (seq_id_diaria.NEXTVAL, 101, 'Treinamento interno', TO_DATE('2025-09-15','YYYY-MM-DD'), 'São Paulo', 2);

INSERT INTO diarias (id_diaria, employee_id, motivo, data_ida, destino, qtd_diarias)
VALUES (seq_id_diaria.NEXTVAL, 102, 'Evento corporativo', TO_DATE('2025-09-20','YYYY-MM-DD'), 'Brasília', 4);


-- Conectado como o usuário “hr_diarias”, responda às questões 2 a 7. Conceda ao usuário
-- “hr_diarias” os privilégios necessários para realizar as consultas. Adicione dados nas tabelas para que as consultas retornem resultados.

-- Questão 2. A empresa deseja um relatório das solicitações de diárias e respectivos
-- empregados solicitantes. Para isso, elabore a visão EMP_DIARIAS_VIEW contendo os seguintes
-- dados devidamente relacionados: id do empregado, nome e sobrenome do empregado, nome
-- do departamento do empregado, id da solicitação de diária, motivo da solicitação, data de ida,
-- destino e quantidade de diárias solicitadas. Defina a VIEW de modo que não seja possível
-- modificar seu conteúdo. Conceda ao usuário “hr_diarias” os privilégios necessários para criar essa visão.

GRANT CREATE VIEW TO hr_diarias; -- (dentro do SYSTEM)

CREATE OR REPLACE VIEW emp_diarias_view AS
SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    d.department_name,
    di.id_diaria,
    di.motivo,
    di.data_ida,
    di.destino,
    di.qtd_diarias
FROM
    hr.employees e
JOIN hr.departments d ON e.department_id = d.department_id
JOIN diarias di ON e.employee_id = di.employee_id
WITH READ ONLY;


-- Questão 3. Consulte sobrenomes de empregados que possuem diárias com destino = ‘Rio de Janeiro’.

SELECT DISTINCT e.last_name
FROM hr.employees e
JOIN diarias d ON e.employee_id = d.employee_id
WHERE d.destino = 'Rio de Janeiro';


-- Questão 4. Liste sobrenome de empregados e dados de suas solicitações de diárias (data de ida e destino), incluindo no resultado também os sobrenomes de empregados que possuem nenhuma solicitação de diárias. Ordene os resultados pelo destino da viagem em ordem alfabética.

SELECT
    e.last_name,
    d.data_ida,
    d.destino
FROM hr.employees e
LEFT JOIN diarias d ON e.employee_id = d.employee_id
ORDER BY d.destino;


-- Questão 5. Elabore uma consulta que retorne nome e sobrenome do empregado que solicitou a maior quantidade de diárias dentre todas as solicitações registradas.

SELECT e.first_name, e.last_name
FROM hr.employees e
JOIN diarias d ON e.employee_id = d.employee_id
WHERE d.qtd_diarias = (
    SELECT MAX(qtd_diarias) FROM diarias
);


-- Questão 6. Liste sobrenomes de empregados que possuem nenhuma solicitação de diárias.

SELECT e.last_name
FROM hr.employees e
WHERE e.employee_id NOT IN (
    SELECT DISTINCT employee_id FROM diarias
);


-- Questão 7. Para cada sobrenome de empregado, consulte a quantidade média de diárias solicitadas por ele.

SELECT
    e.last_name,
    ROUND(AVG(d.qtd_diarias), 2) AS media_diarias
FROM hr.employees e
JOIN diarias d ON e.employee_id = d.employee_id
GROUP BY e.last_name;