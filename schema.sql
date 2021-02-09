-- Creating tables for PH-EmployeeDB

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
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
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

CREATE TABLE titles (
  emp_no INT NOT NULL,
  title CHAR (20) NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL
);

--Delete the tables 
DROP TABLE departments CASCADE;
DROP TABLE employees CASCADE;
DROP TABLE dept_manager CASCADE;
DROP TABLE salaries CASCADE;
DROP TABLE dept_emp CASCADE;
DROP TABLE titles CASCADE;

--Check the tables 
SELECT * FROM departments;
SELECT * FROM employees;
SELECT * FROM dept_manager;
SELECT * FROM salaries;
SELECT * FROM dept_emp;
SELECT * FROM titles;

--Retirement Eligibility
--Creating a query to search for employees born between 1952 and 1955
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

--Creating a query to search for employees born in 1952
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

--Creating a query to search for employees born in 1953
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';

--Creating a query to search for employees born in 1954
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';

--Creating a query to search for employees born in 1955
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';

--Modified Retirement Eligibility
--Creating a query to search for employees born between 1952 and 1955 but hired between 1985 and 1988
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--Modified Retirement Eligibility incorporating the count() function
--Creating a query to search and count for employees born between 1952 and 1955 but hired between 1985 and 1988
-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--Creating new tables
--modified query that creates a new table
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
--Check the table
SELECT * FROM retirement_info;
--Delete the retirement_info.csv table
DROP TABLE retirement_info;

-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;

--Use Inner Join for Departments and dept-manager Tables
-- Joining departments and dept_manager tables
SELECT departments.dept_name,
     dept_manager.emp_no,
     dept_manager.from_date,
     dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;

--Use Aliases for Code Readability and condense the above code
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

--Use Left Join to Capture Retirement-info Table
-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
    retirement_info.first_name,
	retirement_info.last_name,
    dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;

--Use Aliases for Code Readability and condense the above code
SELECT ri.emp_no,
    ri.first_name,
ri.last_name,
    de.to_date
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no;

--Use Left Join for retirment_info and dept_emp tables
SELECT ri.emp_no,
    ri.first_name,
    ri.last_name,
de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');
--Check the table
SELECT * FROM current_emp;

-- Use Left Join for current_emp and dept_emp tables
-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;




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
