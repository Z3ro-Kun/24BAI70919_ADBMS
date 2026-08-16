---A.
CREATE TABLE Signups
(
    user_id INT PRIMARY KEY,
    time_stamp TIMESTAMP
);

CREATE TABLE Confirmations
(
    user_id INT,
    time_stamp TIMESTAMP,
    action VARCHAR(20),
    PRIMARY KEY(user_id, time_stamp),
    FOREIGN KEY(user_id)
    REFERENCES Signups(user_id)
);
INSERT INTO Signups
VALUES
(3,'2020-03-21 10:16:13'),
(7,'2020-01-04 13:57:59'),
(2,'2020-07-29 23:09:44'),
(6,'2020-12-09 10:39:37');


INSERT INTO Confirmations
VALUES
(3,'2021-01-06 03:30:46','timeout'),
(3,'2021-07-14 14:00:00','timeout'),
(7,'2021-06-12 11:57:29','confirmed'),
(7,'2021-06-13 12:58:28','confirmed'),
(7,'2021-06-14 13:59:27','confirmed'),
(2,'2021-01-22 00:00:00','confirmed'),
(2,'2021-02-28 23:59:59','timeout');



select s.user_id, round(Avg(
case 
	when c.action= 'confirmed' then 1
	else 0
	end), 2) from signups as s
left join confirmations as c
on s.user_id=c.user_id
group by s.user_id


---B.
CREATE TABLE Users
(
    users_id INT PRIMARY KEY,
    banned VARCHAR(3),
    role VARCHAR(20)
);

CREATE TABLE Trips
(
    id INT PRIMARY KEY,
    client_id INT,
    driver_id INT,
    city_id INT,
    status VARCHAR(30),
    request_at DATE
);

INSERT INTO Users
VALUES
(1,'No','client'),
(2,'Yes','client'),
(3,'No','client'),
(4,'No','client'),
(10,'No','driver'),
(11,'No','driver'),
(12,'No','driver'),
(13,'No','driver');

INSERT INTO Trips
VALUES
(1,1,10,1,'completed','2013-10-01'),
(2,2,11,1,'cancelled_by_driver','2013-10-01'),
(3,3,12,6,'completed','2013-10-01'),
(4,4,13,6,'cancelled_by_client','2013-10-01'),
(5,1,10,1,'completed','2013-10-02'),
(6,2,11,6,'completed','2013-10-02'),
(7,3,12,6,'completed','2013-10-02'),
(8,2,12,12,'completed','2013-10-03'),
(9,3,10,12,'completed','2013-10-03'),
(10,4,13,12,'cancelled_by_driver','2013-10-03');

select t.request_at, round(Avg(case 
when t.status<>'completed'
and 
t.request_at>='2013-10-01' 
and 
t.request_at<='2013-10-03' then 1
else 0
end),2 )from Trips as t
join users as u
on t.client_id=u.users_id  
join users as u2
on t.driver_id=u2.users_id 
WHERE u.banned = 'No'
  AND u2.banned = 'No'
group by t.request_at
