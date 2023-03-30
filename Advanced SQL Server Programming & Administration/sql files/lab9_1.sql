--1
create proc pstudents
as
	select count(s.St_Id) as NumOfStudents, d.Dept_Name as 'Department'
	from Student s INNER JOIN Department d
	ON s.Dept_Id=d.Dept_Id
	group by (d.Dept_Name)
-- calling
pstudents
--2
create proc check_num_emp
as
	declare @x int
	select @x=count(e.EmpNo)
	from [Human Resource].Employee e inner join  Works_on w
	on e.EmpNo= w.EmpNo and ProjectN=1
	
	if (@x>=3)
	select 'The number of employees in the project p1 is 3 or more'
	else 
	select 'The following employees work for the project p1',' '
	union
	select e.EmpFname ,e.EmpLname
	from [Human Resource].Employee e inner join  Works_on w
	on e.EmpNo= w.EmpNo and ProjectN=1

--calling
check_num_emp

--3
alter proc pemployee  @old_id int , @new_id int , @projectno varchar(2)
as 
	begin try
	update Works_on 
	set EmpNo=@new_id, ProjectN=@projectno
	where EmpNo=@old_id and ProjectN=@projectno
	end try
	begin catch
	select 'Error, Wrong Emp id'
	end catch
-- calling
pemployee 2581,9031,'p2'
--4
-- add budget col
alter table Project
add budget int
-- create audit table
create table history_project
(
projectno varchar(2),
username varchar (100),
ModifiedDate  date,
Budget_Old  int,
Budget_New  int
)
alter trigger t1
on Project
instead of update 
as 
	if update(budget)
		begin
		declare @pronum varchar(2), @bold int ,@bnew int
		select @pronum=Pnumber from deleted
		select @bnew=budget from inserted
		select @bold=budget from deleted
		insert into history_project values(@pronum,suser_name(),getdate(),@bold,@bnew)
		end

update Project set budget=20000 where Pnumber=700
--5
create trigger tDept
on Department
instead of insert
as
select 'You can’t insert a new record in that table'

insert into Department values(90,'MMM','Multimedia','Alex',NULL,'2009-01-01')

--6
create trigger prevent_insert 
on Employee
after insert 
as
	if (format(getdate(),'MMMM')='March')
	begin
	select 'Not allowed, YOU CANNOT INSERT IN MARCH'
	delete from Employee where SSN=(select SSN from inserted)
	end
--7
--create audit table
create table history_student
(
servername varchar (100),
_Date  date,
Note varchar(50)
)
create trigger tstudent
on student
after insert
as
declare @Note varchar(50)
select @Note=suser_name()+' '+'inserted new row, with key= '+(select convert(varchar(10),st_id) from inserted)+'in table student'
insert into history_student 
values(suser_name(),getdate(),@Note)

--8
create trigger tdelstudent
on student
instead of delete
as
declare @Note varchar(50)
select @Note=suser_name()+' '+'try to delete row, with key= '+(select convert(varchar(10),st_id) from deleted)+'in table student'
insert into history_student 
values(suser_name(),getdate(),@Note)

delete from student where st_id=12