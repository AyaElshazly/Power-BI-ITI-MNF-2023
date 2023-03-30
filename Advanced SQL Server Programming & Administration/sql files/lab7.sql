use ITI;
--1. Create a scalar function that takes date and returns Month name of that date.
alter function get_name_month(@date date)
returns varchar(20)
begin
	declare @name varchar(20) = (format(@date,'MMMM'))
	return @name
end
select dbo. get_name_month(getdate())

--2. Create a multi-statements table-valued function that takes 2 integers and returns the values between them.
create function getvalue_between(@x int,@y int)
returns @t table
         (val int)
          as
              begin
              declare @between int = @x+1
              while  @between<@y 
              begin
              insert into @t select @between
              select @between+=1
              end
              return
              end
select*from dbo.getvalue_between(1,10) 
		  
--3  Create inline function that takes Student No and returns Department Name with Student full name.
create function getinfo(@id int)
	 returns table
	 as
	 return
	 (
	 select Dept_Name,S.St_Fname+' '+s.St_Lname as Fullname
	 from Department d,Student s
	 where d.Dept_Id=s.Dept_Id and St_Id=@id
	 
	 )
select *from getinfo(1)

--4. Create a scalar function that takes Student ID and returns a message to user 
create function mesage(@sid int)
returns varchar(50)
begin
declare @messagee varchar(50)
declare @firstname varchar(20)
declare @lastname varchar(20)
select @firstname=st_fname from Student where St_Id=@sid
select @lastname=St_Lname from Student where St_Id=@sid
if @firstname is null and @lastname is null
	select @messagee= 'First name & last name are null'
else if @firstname is null
	select @messagee= 'First name is null'
else if @lastname is null
	select @messagee= 'last name is null'
else
	select @messagee= 'First name & last name are not null'
return @messagee
end
--a.	If first name and Last name are null then display 'First name & last name are null'
select dbo.mesage(50)
--b.	If First name is null then display 'first name is null'
select dbo.mesage(14)
--c.	If Last name is null then display 'last name is null'
select dbo.mesage(13)
--d. Else display 'First name & last name are not null'
select dbo.mesage(1)

--5. Create inline function that takes integer which represents manager ID and
-- displays department name, Manager Name and hiring date 
create function managerdata (@idm int)
returns table
as
return
(
select ins_name,dept_name,manager_hiredate
from Instructor i,Department d
where i.Ins_Id=d.Dept_Manager and d.Dept_Manager=@idm
)

select * from managerdata(3)

--6. Create multi-statements table-valued function that takes a string
--Note: Use “ISNULL” function
create function stdname(@name varchar(20))
returns @t table
(
name varchar(30)
)
as  begin
if @name='first name'
insert into @t
select ISNULL(st_fname,' ')from Student
else if @name='last name'
insert into @t
select ISNULL(St_Lname,' ')from Student
else if @name='full name'
insert into @t
select ISNULL(St_Fname+' '+St_Lname,' ')from Student
return
end
--If string='first name' returns student first name
select * from stdname('first name')
--If string='last name' returns student first name
select * from stdname('last name')
--If string='full name' returns Full Name from student table 
select * from stdname('full name')

--7. Write a query that returns the Student No and Student first name without the last char
create function stdata()
returns table
as return
         (select st_id,LEFT(St_Fname,len(St_Fname)-1) as newFname from Student)
select * from stdata()
--another sol for 7 without function
select st_id,substring(St_Fname,1,len(St_Fname)-1) as newFname from Student
--8. write a query to delete all grades for students located in SD department
delete from Stud_Course 
from Student s inner join Department d
on s.Dept_Id = d.Dept_Id and d.Dept_Name ='SD'
where Stud_Course.St_Id = s.St_Id   --(24 rows affected)
--Bonus
--1
-- using hierarchyid in replicated tabels {one-directional, Bi-directional replication}
-- Example: some methods used with hierarchyid (GetRoot, GetDescendant,...)
-- uses of hierarchyid: file system
--2. create a batch that inserts 3000 rows in student table
/*declare @i integer, @e integer     
declare @stu_Fname char(20), @stu_Lname char(20)
      set @i = (select max(St_Id)+1 from Student)
	  set @e = (select max(St_Id)+3000 from Student)
	  set @stu_Fname = 'Jane'
      set @stu_Lname = 'Smith'
      while @i <= @e
      begin
      insert into Student
        values (@i, @stu_Fname, @stu_Lname,Null,Null,Null,Null)
      set @i = @i+1
      end*/
--
declare @i integer,  @e integer   
declare @stu_Fname varchar(20), @stu_Lname varchar(20)
      set @i = 3000
	  set @e = 6000
	  set @stu_Fname = 'Jane'
      set @stu_Lname = 'Smith'
      while @i <= @e
      begin
      insert into Student
        values (@i, @stu_Fname, @stu_Lname,Null,Null,Null,Null)
      set @i = @i+1
      end

select count(*) from Student

delete from Student 
where St_Id between 15 and 3014