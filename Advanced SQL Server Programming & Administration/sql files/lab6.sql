--create Department table
CREATE TABLE Department
(DeptNo int, DeptName varchar(30), Location varchar(40)
, CONSTRAINT DeptNo_PK Primary Key (DeptNo) )

-- insert data into Department table
insert into Department values
('d1','Research','NY'),
('d2','Acounting','DS'),
('d3','Markiting','KW')

-- create rule for location
create rule r1 AS @list IN ('NY', 'DS', 'KW')
create default def as 'NY'
--create default loc
sp_addtype loc, 'nchar(2)'
sp_bindrule r1,loc
sp_bindefault def,loc



--create Employee table
Create table Employee
(EmpNo int, EmpFname varchar(40) not null, EmpLname varchar(40) not null, DeptNo int, Salary int,
CONSTRAINT EmpNo_PK Primary Key(EmpNo),
CONSTRAINT Dept_Emp_FK Foreign Key (DeptNo) references  Department(DeptNo),
CONSTRAINT c1 unique(Salary)
)
-- insert into Employee
insert into Employee values
(2581,'Elisa','Hansel','d2',3600),
(9031,'Lisa','Bertoni','d2',4000),
(10102,'Ann','Jones','d3',3000),
(18316,'John','Barrimore','d1',2400),
(25348,'Mathew','Smith','d3',2500),
(28559,'Sybl','Moser','d1',2900),
(29346,	'James','James','d2',2800)

-- create rule for salary
create rule s AS @s1 < 6000
sp_bindrule s, 'Employee.Salary'

