------------------------------Part1---------------------------------------
--1
create view Vstudent 
as 
select st_fname+' '+st_lname as Fullname, crs_name
from Student s inner join Stud_Course sc
on s.St_Id=sc.St_Id
inner join Course c
on c.Crs_Id=sc.Crs_Id and grade>50

select * from Vstudent

--2
alter view Vinstructor with encryption
as
select ins_name as Mangername, Top_Name as Topicname
from Instructor i, Department d, Ins_Course ic, Course c, Topic t
where i.Ins_Id=d.Dept_Manager 
and i.Ins_Id=ic.Ins_Id 
and c.Crs_Id=ic.Crs_Id 
and c.Top_Id=t.Top_Id

select * from Vinstructor

--3
create view Viname_dep
as
  select ins_name, dept_name
  from Instructor i inner join Department d
  on d.Dept_Id=i.Dept_Id and d.Dept_Name in ('SD','JAVA')

select * from Viname_dep

--4 
create view V1 as
	   select * from Student where St_Address in ('Alex','Cairo')
	   with check option
select * from V1
--5
use SD;
create view Vpname_enum as
select count(e.EmpNo) as [Num Of Employee], p.ProjectName
from [Human Resource].Employee e inner join Works_on w
on e.EmpNo = w.EmpNo
inner join [company].Project p 
on p.ProjecNo=w.ProjectN
group by p.ProjectName

select * from Vpname_enum

--6 
create clustered index hire on Department(Manager_hiredate)
--Cann't create more than on clustered index on view 'department', so we can drop the existing and make our clustered index

--7
create unique index i on Student(St_Age)
-- duplicate key was found for the object name 'dbo.Student'
--8
create table daliy_transacation
		  (
		  Userid int primary key,
		  Tamount int
		  )
insert into daliy_transacation values(1,1000),(2,2000),(3,1000)

create table last_transacation
		  (
		  Userid int primary key,
		  Tamount int
		  )
insert into last_transacation values(1,4000),(4,2000),(2,10000)

merge into last_transacation as t
using daliy_transacation as s
on t.Userid=s.Userid
when matched then
update set t.Tamount = s.Tamount
when not matched by source then delete;

select * from last_transacation

-----------------------------Part2---------------------------------------
use SD;
--1
create view v_clerk
as
select e.EmpNo,ProjecNo,Enter_Date
from [Human Resource].Employee e inner join Works_on w
on  e.EmpNo=w.EmpNo inner join [company].Project p
on  p.ProjecNo=w.ProjectN and Job='clerk'

select * from v_clerk

--2
create view v_without_budget
as
select p.ProjecNo,p.ProjectName from [company].Project p

select * from v_without_budget	
/*1   Apollo
2     Gemini
3     Mercury*/
--3
create view v_count 
as
select ProjectName,count(Job) as [Num of Jobs]
from [company].Project p, Works_on w
where p.ProjecNo = w.ProjectN
group by ProjectName

select * from v_count

--4
alter view v_project_p2
as
select EmpNo
from v_clerk where ProjecNo=2
select * from v_project_p2
--select * from v_clerk
--5
alter view v_without_budget
as
select p.ProjecNo,p.ProjectName from [company].Project p
where p.ProjecNo in (1,2)

select * from v_without_budget	
/*1
1	Apollo
2	Gemini*/
--6
drop view v_count
drop view v_clerk
--7
create view Vdep
as
select e.EmpNo, e.EmpLname
from [Human Resource].Employee e inner join [company].Department d
on e.DeptNo=d.DeptNo and d.DeptNo=2

select * from Vdep

--8
create view vdep1
as 
select * from Vdep where EmpLname like '%J%'

select * from Vdep1

--9
create view v_dept
as
select DeptNo,DeptName
from [company].Department

select * from v_dept

--10
insert into v_dept values (4,'Development')

--11
create view v_2006_check
as
select EmpNo,ProjectN,Enter_Date
from works_on where Enter_Date between '1-1-2006' and '12-31-2006'
with check option

select * from v_2006_check
--insert validation--
insert into v_2006_check values(3434,1,'2007-2-6')
