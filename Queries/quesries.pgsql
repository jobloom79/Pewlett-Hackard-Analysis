--Creating tables for PH-EmployeesDB
CREATE TABLE departments (
	dept_no VARCHAR(4) NOT NULL,
	dept_name VARCHAR(40) NOT NULL,
	PRIMARY KEY (dept_no),
	UNIQUE (dept_name)
);

CREATE TABLE employees (
	emp_no INT NOT NULL,
	birth_date DATE NOT NULL,
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	gender VARCHAR NOT NULL,
	hire_date DATE NOT NULL,
	PRIMARY KEY (emp_no)
);

CREATE TABLE dept_manager (
dept_no VARCHAR(4) NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE salaries (
	emp_no INT NOT NULL,
	salary VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no)
);

CREATE TABLE titles (
	emp_no INT NOT NULL,
	title VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no, title, from_date)
);

CREATE TABLE dept_emp (
	emp_no INT NOT NULL,
	dept_no VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

SELECT * FROM departments;
SELECT * FROM employees;
SELECT * FROM dept_manager;
SELECT * FROM salaries;
SELECT * FROM titles;
SELECT * FROM dept_emp;

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';

-- Retirement eligibility

SELECT first_name, last_name
    FROM employees
    WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
    AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--Number of employees retiring

SELECT COUNT(first_name)
    FROM employees
    WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
    AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT first_name, last_name
    INTO retirement_info
    FROM employees
    WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
    AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

	-- Adding employee number to retirement_info table
DROP TABLE IF EXISTS retirement_info;

--Create new table for retiring employees
SELECT emp_no, first_name, last_name
    INTO retirement_info
    FROM employees
    WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
    AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
    
SELECT * FROM retirement_info;

-- Joining deparment data with manager table
    --to get employees in a certiain date range
SELECT departments.dept_name,
    dept_manager.emp_no,
    dept_manager.from_date,
    dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;

SELECT d.dept_name,
    dm.emp_no,
    dm.from_date,
    dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

--Capture retirement_info
SELECT retirement_info.emp_no,
    retirement_info.first_name,
retirement_info.last_name,
    dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;

SELECT ri.emp_no,
    ri.first_name,
    ri.last_name,
    de.to_date
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no;

--Finding current employees set to retire
SELECT ri.emp_no,
    ri.first_name,
    ri.last_name, 
    de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

SELECT * FROM current_emp;

--Join current employees and dept employees
--group the employees by dept_no and write to new table
--create a new csv containing the employees by count leaving the dept
SELECT * FROM current_emp
LIMIT 10;

SELECT * FROM dept_emp
LIMIT 10;

SELECT * FROM dept_emp
LIMIT 10;

DROP TABLE IF EXISTS current_dept_emp;

SELECT COUNT(ce.emp_no),
    de.dept_no
INTO ce_dept_emp_count
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no 
ORDER BY de.dept_no ASC;

SELECT * FROM ce_dept_emp_count;

COPY ce_dept_emp_count TO 
    'C:\Users\josep\Documents\GitHub\Pewlett-Hackard-Analysis\Data\7.3.4.csv'
DELIMITER ',' CSV HEADER; 

--Employee Information: A list of employees containing their unique 
    --employee number, their last name, first name, gender, and salary
    --by recreating the table of retiring employees
    --and joining the salary and new table
    --while joining the dept_emp table to get retirement dates
DROP TABLE IF EXISTS emp_info;
SELECT e.emp_no,
    e.last_name,
    e.first_name,
    e.gender,
    s.salary,
    de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
    AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31')
    AND (de.to_date = '9999-01-01');

SELECT * FROM emp_info
LIMIT 10;

COPY emp_info TO
    'C:\Users\josep\Documents\GitHub\Pewlett-Hackard-Analysis\Data\emp_info.csv'
DELIMITER ',' CSV HEADER;

-- List 2: Management
-- The next list to work on involves the management side of the business. 
-- This list includes the manager's employee number, first name, last name, 
-- and their starting and ending employment dates. 
-- Look at the ERD again and see where the data we need resides
SELECT * FROM current_emp
    LIMIT 10;
DROP TABLE IF EXISTS manager_info;

SELECT dm.dept_no,
    d.dept_name,
    dm.emp_no,
	ce.first_name,
	ce.last_name,
	dm.from_date,
	dm.to_date
INTO manager_info
FROM dept_manager as dm
    INNER JOIN departments as d
    ON dm.dept_no = d.dept_no
    INNER JOIN current_emp as ce
    ON dm.emp_no = ce.emp_no;

SELECT * FROM manager_info
LIMIT 10;

COPY manager_info TO
    'C:\Users\josep\Documents\GitHub\Pewlett-Hackard-Analysis\Data\manager_info.csv'
DELIMITER ',' CSV HEADER;