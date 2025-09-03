-- 1. 
-- Consultar o primeiro nome, sobrenome e data de contratação dos empregados que trabalham no mesmo departamento que o empregado com sobrenome Zlotkey (excluindo ele próprio)

select e.first_name, e.last_name, e.hire_date
from employees e
where department_id = (select department_id
    from employees
    where last_name = 'Zlotkey')
and e.last_name <> 'Zlotkey';

-- 2. 
-- Consultar o primeiro nome, sobrenome e data de contratação dos empregados que foram contratados depois do empregado com sobrenome Davies

select e.first_name, e.last_name, e.hire_date
from employees e
where hire_date > (select hire_date
    from employees
    where last_name = 'Davies')
;

-- 3
-- Consultar os sobrenomes dos empregados que são gerentes de departamento
SELECT last_name
FROM employees
WHERE employee_id in (
    SELECT manager_id
    FROM departments d
    WHERE d.manager_id IS NOT NULL
); 

-- 4
-- Consultar o sobrenome e o id do cargo dos empregados que não trabalham em departamentos que contêm a palavra ‘sales’ no nome do departamento
SELECT last_name, job_id
FROM employees
WHERE department_id not in (
    SELECT department_id
    FROM departments d
    WHERE lower(d.department_name) like '%sales%'
);

-- 5
--Consultar o sobrenome e o salário dos empregados cujo salário é menor que o salário de algum empregado com id de cargo ‘ST_MAN’
