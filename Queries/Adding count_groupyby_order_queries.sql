-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;
-- 'SELECT COUNT' gives us the total number of employees
-- 'LEFT JOIN' was used because we wante all employee numbers from Table 1 to be included
-- 'GROUP BY' gives us the number of employees retiring from each department
-- 'ORDER BY' puts the output data in order