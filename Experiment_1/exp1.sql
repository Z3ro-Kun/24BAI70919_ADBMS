------------EXPERIMENT 01------------------

--(A): 
CREATE TABLE Accounts (
    account_id INT PRIMARY KEY,
    income INT NOT NULL
);

INSERT INTO Accounts (account_id, income) VALUES 
(3, 108939), 
(2, 12747),  
(8, 87709),  
(6, 91738),  
(7, 45169); 


select 'Low Salary' as Category, 
count(account_id) as account_count from accounts
where income<20000
union all
select 'Average Salary' as Category, 
count(account_id) as account_count from accounts
where income>=20000 and income<=50000
union all
select 'High Salary' as Category, 
count(account_id) as account_count from accounts
where income>50000


drop table departments;
drop table employees;
drop table salaries;


--(B): 
CREATE TABLE Departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL
);

CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    dept_id INT REFERENCES Departments(dept_id)
);

CREATE TABLE Salaries (
    emp_id INT PRIMARY KEY REFERENCES Employees(emp_id) ON DELETE CASCADE,
    salary INT NOT NULL
);


INSERT INTO Departments (dept_id, dept_name) VALUES 
(10, 'HR'), (20, 'IT'), (30, 'Sales');

INSERT INTO Employees (emp_id, name, dept_id) VALUES 
(1, 'Alice', 10), (2, 'Bob', 10), (3, 'Charlie', 20), (4, 'David', 20), (5, 'Emma', 30);

INSERT INTO Salaries (emp_id, salary) VALUES 
(1, 50000), (2, 25000), (3, 80000), (4, 40000), (5, 45000);

select e.name, d.dept_name from employees as e
inner join departments as d
on e.dept_id=d.dept_id
inner join salaries as s
on e.emp_id=s.emp_id




update salaries 
set salary = salary + salary*0.10
where emp_id in (
select e.emp_id from employees as e
join departments as d
on e.dept_id=d.dept_id
where d.dept_name='HR'
)

DELETE FROM Salaries
WHERE salary <30000;



select * from employees as e
join salaries as s
on e.emp_id=s.emp_id
where s.salary>(select avg(salary) from salaries)



(C)
CREATE TABLE pizza_toppings (
    topping_name VARCHAR(50) PRIMARY KEY,
    ingredient_cost NUMERIC(4,2) NOT NULL
);


INSERT INTO pizza_toppings (topping_name, ingredient_cost) VALUES 
('Pepperoni', 0.50),
('Sausage', 0.70),
('Chicken', 0.55),
('Onions', 0.25),
('Extra Cheese', 0.40);



SELECT
    (a.topping_name,
    b.topping_name,
    c.topping_name) as pizza,
	a.ingredient_cost + b.ingredient_cost + c.ingredient_cost as total_cost
FROM pizza_toppings a, pizza_toppings b, pizza_toppings c
WHERE a.topping_name < b.topping_name
  AND b.topping_name < c.topping_name
order by total_cost desc, pizza asc;






(D)
CREATE TABLE amazon_transactions (
    id INT PRIMARY KEY,
    user_id INT NOT NULL,
    item VARCHAR(50),
    created_at TIMESTAMP NOT NULL,
    revenue INT
);


INSERT INTO amazon_transactions (id, user_id, item, created_at, revenue) VALUES 
(1, 101, 'biscuit', '2026-03-01 10:00:00', 12),
(2, 101, 'milk',    '2026-03-01 14:00:00', 5),  
(3, 101, 'bread',   '2026-03-05 09:00:00', 8),  
(4, 102, 'banana',  '2026-03-10 12:00:00', 4),
(5, 102, 'apple',   '2026-03-25 11:00:00', 6),  
(6, 103, 'milk',    '2026-03-15 08:00:00', 5),
(7, 103, 'bread',   '2026-03-16 08:00:00', 7);  

SELECT DISTINCT a.user_id
FROM amazon_transactions a,
     amazon_transactions b
WHERE a.user_id = b.user_id
  AND b.created_at > a.created_at
  AND b.created_at - a.created_at >= INTERVAL '1 day'
  AND b.created_at - a.created_at <= INTERVAL '7 days'
ORDER BY a.user_id;

