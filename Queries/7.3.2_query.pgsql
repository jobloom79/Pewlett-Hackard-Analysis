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
SELECT * FROM current_emp
LIMIT 10;

SELECT * FROM dept_emp
LIMIT 10;

SELECT COUNT(ce.emp_no),
    de.dept_no
INTO current_dept_emp
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no 
ORDER BY de.dept_no ASC

SELECT * FROM current_dept_emp;

COPY current_dept_emp TO 
    'C:\Users\josep\Documents\GitHub\Pewlett-Hackard-Analysis\Data\7.3.4.csv'
    DELIMITER ',' CSV HEADER; 


