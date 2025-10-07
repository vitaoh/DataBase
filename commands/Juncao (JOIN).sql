-- 1
-- Consultar sobrenome e salário dos empregados cujo título do cargo é ‘Sales Representative’ ou ‘Stock Clerk’
select salary, last_name
from employees e
inner join jobs j on e.job_id = j.job_id
where j.job_title = 'Sales Representative' OR j.job_title = 'Stock Clerk';

-- 2
-- Consultar os nomes dos países e os nomes das regiões onde estão localizados
select country_name, r.region_name
from countries c
inner join regions r on c.region_id = r.region_id;

-- 3
-- Consultar o nome do departamento e o sobrenome de seu gerente. Caso o departamento não tenha gerente, liste o nome do departamento e indique null para o gerente
select department_name, e.last_name
from departments d
left join employees e on d.manager_id = e.manager_id;

-- 4
-- Consultar primeiro nome e sobrenome dos empregados que trabalham em departamentos localizados em cidades cujo nome inicia-se com a letra S
select first_name, last_name
from employees e
join departments d on e.department_id = d.department_id
join locations l on d.location_id = l.location_id
where l.city LIKE 'S%';

-- 5
-- Faça uma consulta para elaborar um relatório dos empregados e seus respectivos gerentes contendo sobrenome do empregado, id de seu cargo (job_id), sobrenome do seu gerente e id do
-- cargo (job_id) do gerente. Caso o empregado não tenha gerente, exiba null como sobrenome do gerente
select e.first_name, e.last_name, m.first_name, m.last_name
from employees e
LEFT JOIN employees m on e.manager_id = m.employee_id;

-- 6
-- Liste o nome de todos os departamentos cadastrados e, caso tenha, exiba o nome e o sobrenome de seu gerente
select department_name, e.first_name, e.last_name
from departments d
left join employees e on d.manager_id = e.manager_id;

-- 7 
-- Considerando o histórico de cargos (tabela JOB_HISTORY), consulte sobrenome do empregado, id de cargo (job_id), data de início e data de encerramento registrados no histórico,
-- considerando todos empregados cadastrados, incluindo também aqueles que não possuem registro no histórico de cargos
select e.last_name, e.employee_id, h.start_date, h.end_date
from employees e
left join job_history h on e.employee_id = h.employee_id;