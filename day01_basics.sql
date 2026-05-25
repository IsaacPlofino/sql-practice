-- ============================================
-- Day 01: SQL Fundamentals
-- Topics: SELECT, WHERE, ORDER BY, BETWEEN, 
--         INNER JOIN, LEFT JOIN, NULL handling
-- Date: May 2026
-- ============================================

-- SETUP: Create Tables
CREATE TABLE departments (
    id INTEGER PRIMARY KEY,
    name TEXT
);

CREATE TABLE employees (
    id INTEGER PRIMARY KEY,
    name TEXT,
    department_id INTEGER,
    salary INTEGER
);

-- SETUP: Insert Data
INSERT INTO departments VALUES (1, 'Finance');
INSERT INTO departments VALUES (2, 'Technology');
INSERT INTO departments VALUES (3, 'Compliance');
INSERT INTO departments VALUES (4, 'Operations');

INSERT INTO employees VALUES (1, 'Maria Santos', 1, 55000);
INSERT INTO employees VALUES (2, 'Jose Reyes', 2, 72000);
INSERT INTO employees VALUES (3, 'Anna Lim', 2, 68000);
INSERT INTO employees VALUES (4, 'Carlos Tan', 3, 61000);
INSERT INTO employees VALUES (5, 'Rosa Cruz', 1, 49000);
INSERT INTO employees VALUES (6, 'Miguel Bautista', 3, 58000);
INSERT INTO employees VALUES (7, 'Patricia Go', NULL, 45000);

-- ============================================
-- QUERIES
-- ============================================

-- Q1: Select all columns from employees
SELECT *
FROM employees;

-- Q2: Select only name and salary
SELECT name, salary
FROM employees;

-- Q3: Select department names
SELECT name
FROM departments;

-- Q4: Employees earning more than 60000
SELECT name, salary
FROM employees
WHERE salary > 60000;

-- Q5: Employees in department 2
SELECT name
FROM employees
WHERE department_id = 2;

-- Q6: Employees earning between 50000 and 70000
SELECT name, salary
FROM employees
WHERE salary BETWEEN 50000 AND 70000;

-- Q7: All employees ordered by salary highest to lowest
SELECT name, salary
FROM employees
ORDER BY salary DESC;

-- Q8: All employees ordered alphabetically
SELECT name
FROM employees
ORDER BY name;

-- Q9: INNER JOIN — employee names with department names
-- Patricia Go disappears because she has no department
SELECT e.name, d.name AS department_name
FROM employees e
INNER JOIN departments d
ON e.department_id = d.id;

-- Q10: LEFT JOIN — all employees including no department
-- Patricia Go appears with NULL department
SELECT e.name, d.name AS department_name
FROM employees e
LEFT JOIN departments d
ON e.department_id = d.id;
