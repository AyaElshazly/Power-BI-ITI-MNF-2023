-- 1 testing
--1
insert into Works_on values(11111,1,'Manager','2000.1.1')
--The INSERT statement conflicted with the FOREIGN KEY constraint
-- 2.change 10102 to 11111
 update Works_on
 set EmpNo = 11111
 where EmpNo = 10102 --The INSERT statement conflicted with the FOREIGN KEY constraint

-- 3. 10102 to 22222
 update Employee
 set EmpNo = 22222
 where EmpNo = 10102
--4. delete employee id=10102
 delete from Employee where  EmpNo = 10102
 
--2 Table Modify
--1. add new column TelephoneNumber
 alter table Employee
 add TelephoneNumber varchar(10)
--2. drop column TelephoneNumber
 alter table Employee
 drop column TelephoneNumber
 -- create new schemas and transfer tabels
-- create schema company
create schema company
alter schema company transfer Department
--create schema Human Resources
create schema [Human Resource]
alter schema [Human Resource] transfer Employee
-- 3 display constraints and its type of Employee
 select constraint_name, constraint_type
 from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
 where table_name='Employee'
 -- 4 create synonym and run the following queries:
create synonym Emp for [Human Resource].Employee
select * from Employee    --Invalid object name 'Employee'.
select * from [Human Resource].Employee --display Emp data (7 rows,5columns)
select * from Emp  --display Emp data (7 rows,5columns)
select * from [Human Resource].Emp --Invalid object name 'Human Resource.Emp'.
-- 5. increase budget of project for managernumber = 10102 by 10%
update company.Project
set Budget+=Budget*0.10
from company.Project p inner join Works_on w
on p.ProjecNo=w.ProjectN 
where w.EmpNo=10102 and w.Job='Manager'
-- 6. change name of dept for employee James with new name "sales
update company.Department
set DeptName='Sales'
from company.Department d inner join [Human Resource].Employee e
on e.DeptNo=d.DeptNo and e.EmpFname='James'     -- 1 row affected Markiting ->> Sales
-- 7.
update Works_on 
set Enter_Date = '12.12.2007'
from Works_on w inner join Emp e
on w.EmpNo=e.EmpNo and w.ProjectN=1
inner join company.Department d
on e.DeptNo = d.DeptNo and d.DeptName='Sales' -- 2 rows affected

--8
delete from Works_on
from Works_on w inner join Emp e
on w.EmpNo = e.EmpNo
inner join company.Department d
on e.DeptNo=d.DeptNo and d.Location='KW' --3 rows affected
