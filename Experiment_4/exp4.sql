-------Experiment 04----------

--A.
CREATE TABLE tbl_happiness
(
    sno INT PRIMARY KEY,
    rankings INT,
    country VARCHAR(50)
);

INSERT INTO tbl_happiness
VALUES
(1,1,'Finland'),
(2,2,'Denmark'),
(3,3,'Iceland'),
(4,4,'Israel'),
(5,5,'Netherlands'),
(6,6,'Sweden'),
(7,7,'Norway'),
(8,126,'India'),
(9,128,'Sri Lanka');

select *,
case 
when country = 'India' then 1
when country = 'Sri Lanka' then 2
else 3
end as rank
from tbl_happiness
order by rank asc, rankings asc


CREATE TABLE Employees
(
    employee_id INT PRIMARY KEY,
    name VARCHAR(50),
    reports_to INT,
    age INT
);

INSERT INTO Employees (employee_id, name, reports_to, age)
VALUES
(9,  'Hercy',   NULL, 43),
(6,  'Alice',   9,    41),
(4,  'Bob',     9,    36),
(2,  'Winston', NULL, 37);

select e.employee_id, e.name, 
count(e.employee_id) as reports_count, 
round(avg(e2.age)) from employees as e
join employees as e2
on e2.reports_to=e.employee_id
group by e.employee_id
