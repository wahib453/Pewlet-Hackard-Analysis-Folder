---- DELIVERABLE 1: The Number of Retiring Employees by Title----
-- Creating retirement_titles.csv table
SELECT e.emp_no,		
	   e.first_name,
	   e.last_name,
	   t.title,
	   t.from_date,
	   t.to_date
INTO retirement_titles
FROM employees as e
INNER JOIN titles as t
ON e.emp_no = t.emp_no
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no;
--Check the table
SELECT * FROM retirement_titles;
-- Delete the table
DROP TABLE retirement_titles;

-- Creating unique_titles.csv table
SELECT DISTINCT ON (rt.emp_no) rt.emp_no,
	rt.first_name,
	rt.last_name,
	rt.title
INTO unique_titles
FROM retirement_titles as rt
ORDER BY rt.emp_no, rt.to_date DESC;
--Check the table
SELECT * FROM unique_titles;
-- Delete the table
DROP TABLE unique_titles;

-- Creating retiring_titles.csv table 
SELECT COUNT(ut.emp_no), ut.title
INTO retiring_titles
FROM unique_titles as ut
GROUP BY ut.title
ORDER BY COUNT (ut.emp_no) DESC;
--Check the table
SELECT * FROM retiring_titles;
-- Delete the table
DROP TABLE retiring_titles;


---- DELIVERABLE 2: The Employees Eligible for the Mentorship Program ----
SELECT DISTINCT ON (e.emp_no) e.emp_no,
    e.first_name,
    e.last_name,
    e.birth_date,
    de.from_date,
    de.to_date,
    t.title
INTO mentorship_eligibility
FROM employees as e
INNER JOIN dept_emp as de
ON e.emp_no = de.emp_no
INNER JOIN titles as t
ON e.emp_no = t.emp_no
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
	AND (de.to_date = '9999-01-01')
ORDER BY e.emp_no;
--Check the table
SELECT * FROM mentorship_eligibility;
-- Delete the table
DROP TABLE mentorship_eligibility;
