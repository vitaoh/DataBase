-- 1. 
-- Recuperar o primeiro nome e o sobrenome dos funcionários com salário maior que 5000
SELECT first_name, last_name, department_id, salary
FROM employees
WHERE salary > 5000;

-- 2.
--Recuperar o primeiro nome e o sobrenome dos funcionários cujos salários estejam dentro da faixa de 8000 a 10000
SELECT first_name, last_name, department_id, salary
FROM employees
WHERE salary > 8000 AND salary < 10000;

-- 3. 
-- Recuperar o sobrenome, telefone e o email dos funcionários com job_title = ‘Programmer’
SELECT last_name, phone_number, email
FROM employees e
JOIN jobs j ON e.job_id = j.job_id
where j.job_title = 'Programmer';

-- 4.
-- Recuperar o primeiro nome e o sobrenome dos funcionários do departamento com nome ‘Marketing’
SELECT last_name, phone_number
FROM employees e
JOIN departments d ON e.department_id = d.department_id
where d.department_name = 'Marketing';

-- 5.
-- Recuperar todos os dados das localizações situadas no país de nome ‘Canada’
SELECT l.*
FROM locations l
JOIN countries c ON l.country_id = c.country_id
where c.country_name = 'Canada';

-- 6. 
-- Recuperar os nomes dos países localizados na região ‘Europe’
SELECT country_name
FROM countries c
JOIN regions r ON c.region_id = r.region_id
where r.region_name = 'Europe';

-- 7.
-- Para cada departamento, recuperar o nome do departamento e o sobrenome do seu gerente
SELECT e.first_name, e.last_name, d.department_name
FROM departments d
JOIN employees e ON d.manager_id = e.employee_id;

-- 8.
-- Para cada departamento, recuperar o nome do departamento e sua cidade
SELECT d.department_name,
       (SELECT city 
        FROM locations 
        WHERE locations.location_id = d.location_id) AS city
FROM departments d;

-- 9.
-- Para cada departamento, recuperar o nome do departamento, sua cidade e o nome do país
SELECT d.department_name,
       (SELECT l.city
          FROM locations l
         WHERE l.location_id = d.location_id) AS city,
       (SELECT c.country_name
          FROM countries c
         WHERE c.country_id = 
               (SELECT l.country_id
                  FROM locations l
                 WHERE l.location_id = d.location_id)
       ) AS country_name
FROM departments d;

-- 10.
-- Para cada departamento, recuperar o nome do departamento, sua cidade e o nome do país, para países que contenham ‘United’ no nome
SELECT d.department_name,
       (SELECT l.city
        FROM locations l
        WHERE l.location_id = d.location_id) AS city,
       (SELECT c.country_name
        FROM countries c
        WHERE c.country_id = 
            (SELECT l.country_id FROM locations l WHERE l.location_id = d.location_id)
            AND c.country_name LIKE 'United'
       ) AS country_name
FROM departments d
WHERE (SELECT c.country_name
         FROM countries c
        WHERE c.country_id = 
              (SELECT l.country_id FROM locations l WHERE l.location_id = d.location_id)
) LIKE 'United';


-- 11.
-- Recuperar o primeiro nome, o sobrenome e o email dos funcionários que trabalham em departamentos localizados na região = ‘Europe’
SELECT e.first_name,
       e.last_name,
       e.email
FROM employees e
WHERE e.department_id IN (
    SELECT d.department_id
    FROM departments d
    WHERE d.location_id IN (
        SELECT l.location_id
        FROM locations l
        WHERE l.country_id IN (
            SELECT c.country_id
            FROM countries c
            WHERE c.region_id IN (
                SELECT r.region_id
                FROM regions r
                WHERE r.region_name = 'Europe'
            )
        )
    )
);