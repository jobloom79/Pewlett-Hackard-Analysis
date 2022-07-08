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