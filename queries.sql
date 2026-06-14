-- ==========================================
-- TASK 3: MULTI-TABLE OPERATIONS & JOINS
-- ==========================================

-- CREATE DATABASE
CREATE DATABASE company_db;
USE company_db;

-- ==========================================
-- TABLE CREATION
-- ==========================================

CREATE TABLE employees (
    emp_no INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gender CHAR(1)
);

CREATE TABLE departments (
    dept_no VARCHAR(10) PRIMARY KEY,
    dept_name VARCHAR(50)
);

CREATE TABLE dept_emp (
    emp_no INT,
    dept_no VARCHAR(10),
    from_date DATE,
    to_date DATE,
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
    FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
);

CREATE TABLE salaries (
    emp_no INT,
    salary INT,
    from_date DATE,
    to_date DATE,
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

CREATE TABLE titles (
    emp_no INT,
    title VARCHAR(50),
    from_date DATE,
    to_date DATE,
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

CREATE TABLE dept_manager (
    dept_no VARCHAR(10),
    emp_no INT,
    from_date DATE,
    to_date DATE,
    FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

-- ==========================================
-- INSERT DATA
-- ==========================================

INSERT INTO employees VALUES
(1001,'Padmaja','Patil','F'),
(1002,'Rahul','Sharma','M'),
(1003,'Priya','Patel','F'),
(1004,'Amit','Kumar','M'),
(1005,'Sneha','Joshi','F');

INSERT INTO departments VALUES
('D001','Development'),
('D002','Sales'),
('D003','HR');

INSERT INTO dept_emp VALUES
(1001,'D001','2023-01-01','9999-01-01'),
(1002,'D002','2023-01-01','9999-01-01'),
(1003,'D003','2023-01-01','9999-01-01'),
(1004,'D001','2023-01-01','9999-01-01'),
(1005,'D002','2023-01-01','2024-01-01');

INSERT INTO salaries VALUES
(1001,50000,'2023-01-01','9999-01-01'),
(1002,60000,'2023-01-01','9999-01-01'),
(1003,55000,'2023-01-01','9999-01-01'),
(1004,70000,'2023-01-01','9999-01-01'),
(1005,45000,'2023-01-01','2024-01-01');

INSERT INTO titles VALUES
(1001,'Engineer','2023-01-01','9999-01-01'),
(1002,'Sales Executive','2023-01-01','9999-01-01'),
(1003,'HR Manager','2023-01-01','9999-01-01'),
(1004,'Senior Engineer','2023-01-01','9999-01-01'),
(1005,'Sales Executive','2023-01-01','2024-01-01');

INSERT INTO dept_manager VALUES
('D001',1004,'2023-01-01','9999-01-01'),
('D002',1002,'2023-01-01','9999-01-01'),
('D003',1003,'2023-01-01','9999-01-01');

-- ==========================================
-- QUERY 1 : INNER JOIN
-- ==========================================

SELECT
e.emp_no,
CONCAT(e.first_name,' ',e.last_name) AS employee_name,
d.dept_name
FROM employees e
INNER JOIN dept_emp de
ON e.emp_no = de.emp_no
INNER JOIN departments d
ON de.dept_no = d.dept_no;

-- ==========================================
-- QUERY 2 : LEFT JOIN
-- ==========================================

SELECT
e.emp_no,
CONCAT(e.first_name,' ',e.last_name) AS employee,
CONCAT(m.first_name,' ',m.last_name) AS manager
FROM employees e
LEFT JOIN dept_emp de
ON e.emp_no = de.emp_no
LEFT JOIN dept_manager dm
ON de.dept_no = dm.dept_no
LEFT JOIN employees m
ON dm.emp_no = m.emp_no;

-- ==========================================
-- QUERY 3 : UNION ALL
-- ==========================================

SELECT
emp_no,
'Active' AS status
FROM dept_emp
WHERE to_date='9999-01-01'

UNION ALL

SELECT
emp_no,
'Former' AS status
FROM dept_emp
WHERE to_date<>'9999-01-01';

-- ==========================================
-- QUERY 4 : CORRELATED SUBQUERY
-- ==========================================

SELECT
e.emp_no,
e.first_name,
(
SELECT salary
FROM salaries s
WHERE s.emp_no=e.emp_no
LIMIT 1
) AS current_salary
FROM employees e;

-- ==========================================
-- QUERY 5 : DISTINCT
-- ==========================================

SELECT DISTINCT title
FROM titles;

-- ==========================================
-- QUERY 6 : GENDER RATIO
-- ==========================================

SELECT
d.dept_name,
ROUND(
100 * SUM(CASE WHEN e.gender='F' THEN 1 ELSE 0 END)
/ COUNT(*),2
) AS female_pct,
ROUND(
100 * SUM(CASE WHEN e.gender='M' THEN 1 ELSE 0 END)
/ COUNT(*),2
) AS male_pct
FROM departments d
JOIN dept_emp de
ON d.dept_no = de.dept_no
JOIN employees e
ON de.emp_no = e.emp_no
GROUP BY d.dept_name;

-- ==========================================
-- QUERY 7 : PERFORMANCE OPTIMIZATION
-- ==========================================

CREATE INDEX idx_emp
ON salaries(emp_no,salary,to_date);

EXPLAIN
SELECT
e.emp_no,
MAX(s.salary) AS max_salary
FROM employees e
JOIN salaries s
ON e.emp_no=s.emp_no
GROUP BY e.emp_no;