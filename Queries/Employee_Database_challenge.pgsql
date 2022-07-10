-- Module 7 Challenge - Determine the number of retiring employees per title, and identify employees who are eligible to participate in a mentorship program. Then, you’ll write a report that summarizes your analysis and helps prepare Bobby’s manager for the “silver tsunami” as many current employees reach retirement age.

-- Deliverable 1: The Number of Retiring Employees by Title
    -- Create a Retirement Titles table that holds all the titles of employees who were born between January 1, 1952 and December 31, 1955. 
DROP TABLE IF EXISTS retirement_titles;
SELECT e.emp_no,
    e.first_name,
    e.last_name,
    t.title,
    t.from_date,
    t.to_date
INTO retirement_titles
FROM employees as e
    INNER JOIN titles as t
    ON (e.emp_no = t.emp_no)
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no;
-- SELECT * FROM retirement_titles
-- LIMIT 10;
COPY retirement_titles TO
    'C:\Users\josep\Documents\GitHub\Pewlett-Hackard-Analysis\Data\retirement_titles.csv'
DELIMITER ',' CSV HEADER;
    -- Use the DISTINCT ON statement to create a table that contains the most recent title of each employee.
DROP TABLE IF EXISTS unique_titles;
SELECT DISTINCT ON (rt.emp_no)
    rt.emp_no,
    rt.first_name,
    rt.last_name,
    rt.title
INTO unique_titles
FROM retirement_title as rt
WHERE (rt.to_date = '9999-01-01')
ORDER BY rt.emp_no ASC, rt.to_date DESC;
-- SELECT * FROM unique_titles
-- LIMIT 10;
COPY unique_titles TO
    'C:\Users\josep\Documents\GitHub\Pewlett-Hackard-Analysis\Data\unique_titles.csv'
DELIMITER ',' CSV HEADER;
    -- Retrieve the number of employees by their most recent job title who are about to retire.
DROP TABLE IF EXISTS retiring_titles;
SELECT COUNT (ut.title), ut.title
INTO retiring_titles
FROM unique_titles as ut
GROUP BY ut.title
ORDER BY COUNT DESC;
SELECT * FROM retiring_titles
LIMIT 10;
COPY retiring_titles TO
    'C:\Users\josep\Documents\GitHub\Pewlett-Hackard-Analysis\Data\retiring_titles.csv'
DELIMITER ',' CSV HEADER;

-- Deliverable 2: The Employees Eligible for the Mentorship Program
-- Deliverable 3: A written report on the employee database analysis (README.md)