drop table employee
--A
CREATE TABLE Employee
(
    EID INT PRIMARY KEY,
    DEPT VARCHAR(10),
    SCORES DECIMAL(5,2)
);

INSERT INTO Employee (EID, DEPT, SCORES)
VALUES
(1, 'D1', 1.00),
(2, 'D1', 5.28),
(3, 'D1', 4.00),
(4, 'D2', 8.00),
(5, 'D1', 2.50),
(6, 'D2', 7.00),
(7, 'D3', 9.00),
(8, 'D4', 10.20);

update employee as e
set scores =(select max(scores) from employee 
where Dept=e.dept
)
select EID, DEPT, SCORES from employee


--B

CREATE TABLE SalesPerson
(
    seller_id INT PRIMARY KEY,
    name VARCHAR(50),
    city VARCHAR(50),
    commission INT
);

CREATE TABLE Company
(
    com_id INT PRIMARY KEY,
    name VARCHAR(50),
    city VARCHAR(50)
);

CREATE TABLE Orders
(
    order_id INT PRIMARY KEY,
    order_date DATE,
    com_id INT,
    seller_id INT,
    amount INT,
    FOREIGN KEY (com_id)
        REFERENCES Company(com_id),
    FOREIGN KEY (seller_id)
        REFERENCES SalesPerson(seller_id)
);

INSERT INTO SalesPerson
VALUES
(1,'John','New York',15),
(2,'Amy','Los Angeles',13),
(3,'Mark','Chicago',12),
(4,'Pam','Boston',15);

INSERT INTO Company
VALUES
(1,'RED','Boston'),
(2,'ORANGE','New York'),
(3,'YELLOW','Boston'),
(4,'GREEN','Austin');

INSERT INTO Orders
VALUES
(1,'2024-01-10',1,1,1200),
(2,'2024-01-12',2,1,800),
(3,'2024-01-15',3,2,2500),
(4,'2024-01-18',1,3,1500),
(5,'2024-01-22',4,2,700),
(6,'2024-01-25',2,3,2000),
(7,'2024-01-28',3,4,3000),
(8,'2024-01-30',4,4,200);

select seller_id from orders
group by seller_id
having sum(amount)=(
select max(a.amts) from
(select seller_id, sum(amount) as amts from orders
group by seller_id) as a)

-- C (IMP **)
drop table employee
CREATE TABLE Department
(
    id INT PRIMARY KEY,
    name VARCHAR(50)
);

INSERT INTO Department (id, name)
VALUES
(1, 'IT'),
(2, 'Sales');



CREATE TABLE Employee
(
    id INT PRIMARY KEY,
    name VARCHAR(50),
    salary INT,
    departmentId INT,
    FOREIGN KEY (departmentId)
    REFERENCES Department(id)
);

INSERT INTO Employee (id, name, salary, departmentId)
VALUES
(1, 'Joe',   85000, 1),
(2, 'Henry', 80000, 2),
(3, 'Sam',   60000, 2),
(4, 'Max',   90000, 1),
(5, 'Janet', 69000, 1),
(6, 'Randy', 85000, 1),
(7, 'Will',  70000, 1);

select * from employee

select d.name as department, e.name 
as employee, e.salary as salary from employee as e 
join department as d on
e.departmentid=d.id
where (
	SELECT COUNT(DISTINCT E2.SALARY)
	FROM EMPLOYEE AS E2
	WHERE E2.departmentId = e.departmentId
	AND 
	E2.SALARY > e.SALARY
)<3
order by d.name
