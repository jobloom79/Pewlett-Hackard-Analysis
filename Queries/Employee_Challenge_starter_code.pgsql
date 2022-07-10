-- Determine the number of retiring employees per title, and identify employees 
-- who are eligible to participate in a mentorship program. Then, you’ll write 
-- a report that summarizes your analysis and helps prepare Bobby’s manager for 
-- the “silver tsunami” as many current employees reach retirement age.

-- Deliverable 1: The Number of Retiring Employees by Title
    -- Create a Retirement Titles table that holds all the titles of employees who were born between January 1, 1952 and December 31, 1955. 
    -- Use the DISTINCT ON statement to create a table that contains the most recent title of each employee.
DROP TABLE IF EXISTS ret_emp_title;
SELECT DISTINCT (e.emp_no),
    t.title,
    e.last_name,
    e.first_name,
    de.to_date
INTO ret_emp_title
FROM employees as e
    INNER JOIN titles as t
    ON (e.emp_no = t.emp_no)
    INNER JOIN dept_emp as de
    ON (e.emp_no = de.emp_no)
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
    AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31')
    AND (de.to_date = '9999-01-01');

SELECT COUNT (re.emp_no), t.title
FROM ret_emp_title as re
LEFT JOIN titles as t
ON re.emp_no = t.emp_no    
GROUP BY t.title
ORDER BY t.title;

SELECT * FROM ret_emp_title
LIMIT 10;

COPY ret_emp_title TO
    'C:\Users\josep\Documents\GitHub\Pewlett-Hackard-Analysis\Data\ret_emp_title.csv'
DELIMITER ',' CSV HEADER;

-- Deliverable 2: The Employees Eligible for the Mentorship Program
-- Deliverable 3: A written report on the employee database analysis (README.md)