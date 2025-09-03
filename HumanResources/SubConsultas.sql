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
SELECT last_name, salary
FROM employees
WHERE salary < ANY (
    SELECT salary
    FROM employees e
    WHERE e.job_id like 'ST_MAN'
); 

-- 6
-- Consultar o sobrenome e o salário dos empregados cujo salário é maior que o salário de todos os empregados do departamento com id = 50
SELECT last_name, salary
FROM employees 
WHERE salary > ALL (
    SELECT salary
    FROM employees 
    where department_id = 50
);

-- 7
-- Consultar o primeiro nome, sobrenome e salário dos empregados que possuem o mesmo cargo que o empregado com sobrenome Zlotkey e ganham salário maior que ele
SELECT first_name, last_name, salary
FROM employees
WHERE job_id = (
    SELECT job_id
    FROM employees
    WHERE last_name = 'Zlotkey'
) and salary > (
    SELECT salary
    FROM employees
    WHERE last_name = 'Zlotkey'
);

-- 8 
-- Consultar id de países que possuem departamentos da empresa (usar EXISTS)
SELECT country_id
FROM countries c
WHERE EXISTS (
    SELECT 1
    FROM locations l
    JOIN departments d ON l.location_id = d.location_id
    WHERE l.country_id = c.country_id
);
