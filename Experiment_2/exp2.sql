--A.
drop table departments
drop table students
drop table subjects
drop table marks
CREATE TABLE Departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL
);

CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50) NOT NULL,
    dept_id INT REFERENCES Departments(dept_id)
);

CREATE TABLE Subjects (
    subject_id INT PRIMARY KEY,
    subject_name VARCHAR(50) NOT NULL
);

CREATE TABLE Marks (
    student_id INT REFERENCES Students(student_id),
    subject_id INT REFERENCES Subjects(subject_id),
    marks_scored INT NOT NULL,
    PRIMARY KEY (student_id, subject_id)
);


INSERT INTO Departments (dept_id, dept_name) VALUES 
(1, 'Computer Science'),
(2, 'Mathematics');

INSERT INTO Students (student_id, student_name, dept_id) VALUES 
(101, 'Alex', 1),
(102, 'Bella', 1),
(103, 'Charlie', 2);

INSERT INTO Subjects (subject_id, subject_name) VALUES 
(501, 'Data Structures'),
(502, 'Calculus');

INSERT INTO Marks (student_id, subject_id, marks_scored) VALUES 
(101, 501, 85),
(101, 502, 90),
(102, 501, 75),
(103, 502, 95);

Select d.dept_name as Department, round(avg(m.marks_scored), 2) as "Average Marks" from Departments as d 
join students as s 
on d.dept_id =s.dept_id
join marks as m
on m.student_id=s.student_id
group by d.dept_name
order by "Average Marks" Desc




--B.
-- Create Table A
CREATE TABLE A
(
    EmpID INT,
    Ename VARCHAR(50),
    Salary INT
);

-- Create Table B
CREATE TABLE B
(
    EmpID INT,
    Ename VARCHAR(50),
    Salary INT
);

INSERT INTO A (EmpID, Ename, Salary)
VALUES
(1, 'AA', 1000),
(2, 'BB', 300);

INSERT INTO B (EmpID, Ename, Salary)
VALUES
(2, 'BB', 400),
(3, 'CC', 100);

select C.empid, min(c.ename), min(c.salary) from
(select * from A
union all
select * from B) as C
group by c.empid



drop table employee

--C. 
CREATE TABLE Department
(
    id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

CREATE TABLE Employee
(
    id INT PRIMARY KEY,
    name VARCHAR(50),
    salary INT,
    department_id INT,
    FOREIGN KEY(department_id)
    REFERENCES Department(id)
);

INSERT INTO Department
VALUES
(1,'IT'),
(2,'SALES');

INSERT INTO Employee
VALUES
(1,'JOE',70000,1),
(2,'JIM',90000,1),
(3,'HENRY',80000,2),
(4,'SAM',60000,2),
(5,'MAX',90000,1);


select d.dept_name, e.name, e.salary from Employee as e
join department as d
on d.id=e.department_id
where e.salary = (select max(e2.salary) from employee as e2
where e2.department_id=d.id)
