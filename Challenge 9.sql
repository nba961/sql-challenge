-- Create new tables

CREATE TABLE departments (
	dept_no VARCHAR(30) NOT NULL PRIMARY KEY,
	dept_name VARCHAR(30) NOT NULL
);

CREATE TABLE dept_emp (
	emp_no INT,
	dept_no VARCHAR(30)
);

CREATE TABLE dept_manager (
	dept_no VARCHAR(30) NOT NULL,
	emp_no INT NOT NULL PRIMARY KEY
);

ALTER TABLE dept_manager
ADD FOREIGN KEY (dept_no) REFERENCES departments(dept_no);

CREATE TABLE employees (
	emp_no INT NOT NULL PRIMARY KEY,
	emp_title_id VARCHAR NOT NULL,
	birth_date DATE NOT NULL,
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	sex VARCHAR NOT NULL,
	hire_date DATE NOT NULL
);

ALTER TABLE employees
ADD FOREIGN KEY (emp_title_id) REFERENCES titles(title_id);

CREATE TABLE salaries (
	emp_no INT NOT NULL PRIMARY KEY,
	salary INT NOT NULL
);

CREATE TABLE titles (
	title_id VARCHAR NOT NULL PRIMARY KEY,
	title VARCHAR NOT NULL
);

-- View data in tables
SELECT * FROM departments;
SELECT * FROM dept_emp;
SELECT * FROM dept_manager;
SELECT * FROM employees;
SELECT * FROM salaries;
SELECT * FROM titles;

-- 1. List the employee number, last name, first name, sex, and salary of each employee
SELECT employees.emp_no, employees.last_name, employees.first_name, employees.sex, salaries.salary
FROM employees
INNER JOIN salaries ON employees.emp_no=salaries.emp_no;

-- 2. List the first name, last name, and hire date for the employees who were hired in 1986
SELECT first_name, last_name, hire_date
FROM employees
WHERE employees.hire_date BETWEEN '1986-01-01' AND '1986-12-31';

-- 3. List the manager of each department along with their department number, department name, employee number, last name, and first name
SELECT dept_manager.dept_no, departments.dept_name, dept_manager.emp_no, employees.last_name, employees.first_name
FROM ((dept_manager
	  INNER JOIN employees ON dept_manager.emp_no = employees.emp_no
	  INNER JOIN departments ON dept_manager.dept_no = departments.dept_no));
	 
-- 4. List the department number for each employee along with that employee’s employee number, last name, first name, and department name
SELECT dept_emp.dept_no, employees.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM ((dept_emp
	  INNER JOIN employees ON dept_emp.emp_no = employees.emp_no
	  INNER JOIN departments ON dept_emp.dept_no = departments.dept_no));
	  
-- 5. List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B
SELECT first_name, last_name, sex
FROM employees
WHERE first_name='Hercules' AND last_name LIKE 'B%';

-- 6. List each employee in the Sales department, including their employee number, last name, and first name
SELECT emp_no, last_name, first_name
FROM employees
WHERE EXISTS (SELECT dept_no FROM dept_emp WHERE dept_emp.emp_no = employees.emp_no AND dept_no = 'd007');

-- 7. List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name
SELECT dept_emp.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM ((dept_emp
	  INNER JOIN employees ON dept_emp.emp_no = employees.emp_no
	  INNER JOIN departments ON dept_emp.dept_no = departments.dept_no))
WHERE departments.dept_no = 'd007' OR departments.dept_no = 'd005';

-- 8. List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name)
SELECT COUNT(last_name), last_name
FROM employees
GROUP BY last_name
ORDER BY last_name DESC;