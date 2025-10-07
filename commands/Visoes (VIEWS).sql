-- 1.
-- Criar uma view EMP_ST_CLERK que contenha dados dos empregados com função ‘ST_CLERK’
--      Colunas: employee_id, last_name, email, hire_date, job_id
CREATE VIEW EMP_ST_CLERK AS
SELECT employee_id as codigo, last_name as sobrenome, email, hire_date as contratacao, job_id as codigo_trabalho
FROM employees
WHERE job_id = 'ST_CLERK';

-- 2.
-- Criar (ou alterar) a view de modo que não seja possível alterar seu conteúdo com funções de empregado diferentes de ‘ST_CLERK’
CREATE VIEW EMP_ST_CLERK AS
SELECT employee_id as codigo, last_name as sobrenome, email, hire_date as contratacao, job_id as codigo_trabalho
FROM employees
WHERE job_id = 'ST_CLERK'
WITH CHECK OPTION;

-- 3
-- Adicione um novo empregado na view EMP_ST_CLERK, com a função ‘ST_CLERK’
INSERT INTO EMP_ST_CLERK (codigo, sobrenome, email, contratacao, codigo_trabalho)
VALUES (999, 'Herculini', 'vherculini@email.com', SYSDATE, 'ST_CLERK');

-- 4 
-- Explique o que aconteceu na tabela Employees

-- Foi adicionado com sucesso na tabela Employees!

-- 5. Atualize EMP_ST_CLERK de modo que o empregado adicionado tenha a função ‘IT_PROG’
UPDATE EMP_ST_CLERK
SET codigo_trabalho = 'IT_PROG'
WHERE codigo = 999;

-- 6. Explique o que aconteceu

-- A cláusula WITH CHECK OPTION bloqueia a atualização do job_id para valor fora do filtro da view.

-- 7. Remova da view o empregado adicionado anteriormente
DELETE FROM EMP_ST_CLERK 
WHERE codigo = 999;

--8. Explique o que aconteceu na tabela Employees

-- Não excluiu da tabela, ele ainda continou presente!

--9. 
-- Criar uma visão DEPT_MAN_VIEW que contenha dados dos gerentes de departamento
--      Colunas: nome do gerente, título de sua função, salário anual, nome do departamento, cidade
CREATE OR REPLACE VIEW DEPT_MAN_VIEW AS
SELECT e.last_name AS nome_gerente,
       e.job_id AS titulo_funcao,
       e.salary * 12 AS salario_anual,
       d.department_name,
       l.city
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN locations l ON d.location_id = l.location_id
WHERE e.job_id LIKE '%MAN%';

--10 
-- É possível atualizar DEPT_MAN_VIEW? Justifique.

-- Não, pois a view possui junções (joins) e cálculo (salário anual), o que torna a view não atualizável.

--11 
-- Criar uma visão DEPT_JOB_VIEW que contenha uma relação da quantidade de empregados por função e por nome de departamento
--      Colunas: nome do departamento, nome da função, quantidade de empregados que exercem a função no referido departamento
CREATE OR REPLACE VIEW DEPT_JOB_VIEW AS
SELECT d.department_name,
       j.job_title,
       COUNT(e.employee_id) AS quantidade_empregados
FROM employees e
JOIN jobs j ON e.job_id = j.job_id
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name, j.job_title;

--12 
-- É possível atualizar DEPT_JOB_VIEW? Justifique.

-- Não, pois esta view usa agregação (GROUP BY) e não é atualizável.