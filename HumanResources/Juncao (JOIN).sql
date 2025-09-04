-- 1
-- Consultar sobrenome e salário dos empregados cujo título do cargo é ‘Sales Representative’ ou ‘Stock Clerk’
select salary, last_name
from employees e
inner join jobs j on e.job_id = j.job_id
where j.job_title = 'Sales Representative' OR j.job_title = 'Stock Clerk';

-- 2
-- Consultar os nomes dos países e os nomes das regiões onde estão localizados


-- 3
-- Consultar o nome do departamento e o sobrenome de seu gerente. Caso o departamento não tenha gerente, liste o nome do departamento e indique null para o gerente


-- 4
-- Consultar primeiro nome e sobrenome dos empregados que trabalham em departamentos localizados em cidades cujo nome inicia-se com a letra S


-- 5
-- Faça uma consulta para elaborar um relatório dos empregados e seus respectivos gerentes contendo sobrenome do empregado, id de seu cargo (job_id), sobrenome do seu gerente e id do
-- cargo (job_id) do gerente. Caso o empregado não tenha gerente, exiba null como sobrenome do gerente


-- 6
-- Liste o nome de todos os departamentos cadastrados e, caso tenha, exiba o nome e o sobrenome de seu gerente


-- 7 
-- Considerando o histórico de cargos (tabela JOB_HISTORY), consulte sobrenome do empregado, id de cargo (job_id), data de início e data de encerramento registrados no histórico,
-- considerando todos empregados cadastrados, incluindo também aqueles que não possuem registro no histórico de cargos