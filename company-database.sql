/* TASK 1 : creating company database */

-- 1 employee table 
CREATE TABLE employee (
	emp_id INT PRIMARY KEY, -- set primary key
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    birth_date DATE,
    sex VARCHAR(1),
    salary INT,
    super_id INT,
    branch_id INT 
);

-- 2 branch table
CREATE TABLE branch (
	branch_id INT PRIMARY KEY,
    branch_name VARCHAR(50),
    mgr_id INT,
    mgr_start_date DATE,
    FOREIGN KEY(mgr_id) REFERENCES employee(emp_id) ON DELETE SET NULL
/* It specifies that the child data is set to NULL when the parent data is deleted. 
The child data is NOT deleted. */
);

-- add foreign keys to employee table created
AlTER TABLE employee
ADD FOREIGN KEY(branch_id)
REFERENCES branch(branch_id) ON DELETE SET NULL;

ALTER TABLE employee
ADD FOREIGN KEY(super_id)
REFERENCES employee(emp_id) ON DELETE SET NULL;

-- 3 client table
CREATE TABLE client (
	client_id INT PRIMARY KEY,
    client_name VARCHAR(50),
    branch_id INT,
    FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE SET NULL
);

-- 4 works_with table 
CREATE TABLE work_with (
	emp_id INT,
    client_id INT,
    total_sales INT,
    PRIMARY KEY(emp_id,client_id), -- Composite Key
    FOREIGN KEY(emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE,
    FOREIGN KEY(client_id) REFERENCES client(client_id) ON DELETE CASCADE
/*  It is used in conjunction with ON DELETE or ON UPDATE. 
It means that the child data is either deleted or updated when the parent data is deleted or updated. */
);

-- 5 branch supplier table
CREATE TABLE branch_supplier (
	branch_id INT,
    supplier_name VARCHAR(50),
    supply_type VARCHAR(40),
    PRIMARY KEY(branch_id,supplier_name), -- Composite Key
    FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE CASCADE
);

/* TASK 2 : inserting data/information */

# employee table and branch table 
--  for corporate branch
INSERT INTO employee VALUES(100,'David','Wallace','1967-11-17','M',250000,NULL,NULL);
-- NULL because branch_id is not created yet
INSERT INTO branch VALUES(1,'corporate',100,'2006-02-09');
-- Now we can update employee table davids branch id as it is added in branch table
UPDATE employee
SET branch_id=1
WHERE emp_id=100;
-- insert next employee info
INSERT INTO employee VALUES(101,'Jan','Levinson','1961-05-11','F',110000,100,1);

-- for scranton branch
INSERT INTO employee VALUE(102,'Michael','Scott','1964-03-15','M',75000,100,NULL);
INSERT INTO branch VALUE(2,'Scranton',102,'1992-04-06');

UPDATE employee
SET branch_id=2
WHERE emp_id=102;

INSERT INTO employee VALUES(103,'Angela','Martin','1964-03-15','F',63000,102,2);
INSERT INTO employee VALUES(104,'Kelly','Kapoor','1964-03-15','F',55000,102,2);
INSERT INTO employee VALUES(105,'Stanley','Hudson','1964-03-15','M',69000,102,2);

-- for stamford branch
INSERT INTO employee VALUES(106,'Josh','Porter','1969-09-05','M',78000,100,NULL);
INSERT INTO branch VALUES(3,'Stamford',106,'1998-02-13');

UPDATE employee SET branch_id=3 WHERE emp_id=106;
INSERT INTO employee VALUES(107,'Andy','Bernard','1973-07-22','M',65000,106,3);
INSERT INTO employee VALUES(108,'Jim','Halpert','1978-10-01','M',71000,106,3);

# for client table
INSERT INTO client VALUES(400, 'Dunmore Highschool', 2);
INSERT INTO client VALUES(401, 'Lackawana Country', 2);
INSERT INTO client VALUES(402, 'FedEx', 3);
INSERT INTO client VALUES(403, 'John Daly Law, LLC', 3);
INSERT INTO client VALUES(404, 'Scranton Whitepages', 2);
INSERT INTO client VALUES(405, 'Times Newspaper', 3);
INSERT INTO client VALUES(406, 'FedEx', 2);

# rename table name of work_with
ALTER TABLE work_with
RENAME TO works_with;

# for works_with table 
INSERT INTO works_with VALUES(105, 400, 55000);
INSERT INTO works_with VALUES(102, 401, 267000);
INSERT INTO works_with VALUES(108, 402, 22500);
INSERT INTO works_with VALUES(107, 403, 5000);
INSERT INTO works_with VALUES(108, 403, 12000);
INSERT INTO works_with VALUES(105, 404, 33000);
INSERT INTO works_with VALUES(107, 405, 26000);
INSERT INTO works_with VALUES(102, 406, 15000);
INSERT INTO works_with VALUES(105, 406, 130000);

# for branch supplier table
INSERT INTO branch_supplier VALUES(2, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Patriot Paper', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'J.T. Forms & Labels', 'Custom Forms');
INSERT INTO branch_supplier VALUES(3, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(3, 'Stamford Lables', 'Custom Forms');

/* Tables are created and data is populated not to check :*/
SELECT * FROM employee;
SELECT * FROM branch;
-- change corporate to Corporate
UPDATE branch
SET branch_name='Corporate'
WHERE branch_id=1;

SELECT * FROM client;
SELECT * FROM works_with;
SELECT * FROM branch_supplier;

/* TASK 3 : Queries to get the specific data - mentioned in Readme file */

-- Q1) Find all employees
SELECT * 
FROM employee;

-- Q2) Find all clients
SELECT * 
FROM client;

-- Q3) Find all employees ordered by salary
SELECT * 
FROM employee 
ORDER BY salary DESC;

-- Q4) Find all employees ordered by sex then name
SELECT * 
FROM employee 
ORDER BY sex, first_name;

-- Q5) Find the first 5 employees in the table
SELECT * 
FROM employee 
LIMIT 5;

-- Q6) Find the first and last names of all employees
SELECT first_name,last_name 
FROM employee;

-- Q7) Find the forename and surnames names of all employees
SELECT first_name AS forename, last_name AS surname
FROM employee;

-- Q8) Find out all the different genders
SELECT DISTINCT sex
FROM employee;

-- Q9) Find all male employees
SELECT *
FROM employee
WHERE sex='M';

-- Q10) Find all employees at branch 2
SELECT *
FROM employee
WHERE branch_id = 2;

-- Q11) Find all employee's id's and names who were born after 1969
SELECT emp_id,first_name
FROM employee
WHERE birth_date>= 1969-01-01;

-- Q12) Find all female employees at branch 2
SELECT *
FROM employee
WHERE sex='F' AND branch_id=2;

-- Q13) Find all employees who are female & born after 1969 or who make over 80000
SELECT *
FROM employee
WHERE (sex='F' AND birth_date>= 1969-01-01) OR salary>80000;

-- Q14)  Find all employees born between 1970 and 1975
SELECT *
FROM employee
WHERE birth_date BETWEEN '1970-01-01' AND '1975-01-01';

-- Q15)  Find all employees named Jim, Michael, Johnny or David
SELECT *
FROM employee
WHERE first_name IN ('Jim','Michael','Johnny','David');

-- Q16)  Find the number of employees
SELECT COUNT(emp_id)
FROM employee;

-- Q17)  Find the average of all employee's salaries
SELECT ROUND(AVG(salary),2)
FROM employee;

-- Q18)  Find the sum of all employee's salaries
SELECT ROUND(SUM(salary),2)
FROM employee;

-- Q19)  Find out how many males and females there are
SELECT COUNT(sex),sex
FROM employee
GROUP BY sex;

-- Q20)  Find the total sales of each salesman
SELECT SUM(total_sales),emp_id
FROM works_with
GROUP BY emp_id;

-- Q21)  Find the total amount of money spent by each client
SELECT SUM(total_sales),client_id
FROM works_with
GROUP BY client_id;

-- % = any # characters, _ = one character
-- Q22)  Find any client's who are an LLC
SELECT *
FROM client
WHERE client_name LIKE '%LLC';

-- Q23)  Find any branch suppliers who are in the label business
SELECT *
FROM branch_supplier
WHERE supplier_name LIKE '%label%';

-- Q24)  Find any employee born on the 10th day of the month
SELECT *
FROM employee
WHERE birth_date LIKE '________10';

-- Q25)  Find any clients who are schools
SELECT *
FROM client
WHERE client_name LIKE '%school%';

-- Unions
-- Q26)  Find a list of employee and branch names
SELECT employee.first_name AS Employee_Branch_Name
FROM employee
UNION
SELECT branch.branch_name
FROM branch;

-- Q27)  Find a list of all clients & branch suppliers' names
SELECT client.client_name AS Non_Employee_Entities
FROM client
UNION
SELECT branch_supplier.supplier_name
FROM branch_supplier;

-- Joins
-- Q28) Find all branches and the name of their managers
SELECT employee.emp_id, employee.first_name, branch.branch_name
FROM employee
JOIN branch 							-- inner/general/normal JOIN - 1
on employee.emp_id = branch.mgr_id;

SELECT employee.emp_id, employee.first_name, branch.branch_name
FROM employee
LEFT JOIN branch 							-- LEFT JOIN - 2
ON employee.emp_id = branch.mgr_id;

INSERT INTO branch VALUES(4,'Temp',NULL,NULL); -- to see the difference while doing right join

SELECT employee.emp_id, employee.first_name, branch.branch_name
FROM employee
RIGHT JOIN branch 							--  RIGHT JOIN - 3, (4 FULL JOIN)
ON employee.emp_id = branch.mgr_id;

-- Nested quaries
-- Q29) Find names of all employees who have sold over 50,000
SELECT first_name,last_name
FROM employee
WHERE emp_id IN (SELECT works_with.emp_id 
				 FROM works_with 
                 WHERE total_sales > 50000);

-- Q30) Find all clients who are handles by the branch that Michael Scott manages
-- Assuming I know Michael's ID : 102
SELECT client.client_name
FROM client
WHERE branch_id = (SELECT branch.branch_id
					FROM branch
                    WHERE mgr_id = 102);

-- Assuming I DONT'T know Michael's ID
SELECT client.client_name
FROM client
WHERE client.branch_id = (SELECT branch.branch_id
						  FROM branch
						  WHERE branch.mgr_id = (SELECT employee.emp_id
												 FROM employee
                                                 WHERE employee.first_name = 'Michael'));
-- Q31) Find the names of employees who work with clients handled by the scranton branch
SELECT employee.first_name,employee.last_name
FROM employee
WHERE employee.emp_id IN (SELECT works_with.emp_id FROM works_with)
						AND employee.branch_id = (SELECT branch.branch_id 
												  FROM branch
                                                  WHERE branch_name='Scranton');

-- Q32) Find the names of all clients who have spent more than 100,000 dollars
SELECT client.client_name
FROM client
WHERE client.client_id IN ( SELECT client_id AS k100_id
							FROM (
									SELECT SUM(works_with.total_sales) AS total_spent, client_id
                                    FROM works_with
                                    GROUP BY client_id) AS total_client_spent
							WHERE total_spent > 100000 );

                                    

