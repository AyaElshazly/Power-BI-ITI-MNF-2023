--lab9--bonus
use ITI;
--1. Create a scalar function that takes date and returns Month name of that date.
create proc name_month @date date
as
	declare @name varchar(20) 
	select @name= (format(@date,'MMMM'))
--calling
exec name_month '1-1-2000'
--2.takes 2 integers and returns the values between them.
alter proc value_between @x int,@y int
as
declare @t table (val int)      
declare @between int 
set @between= @x+1
while  @between<@y 
begin
insert into @t select @between
set @between+=1
end
--calling 
exec value_between 2,8
---------------------------------another solution for2---------------------------------
alter proc values_between @x int,@y int
as
declare @values table (vals int)  
if @x!=@y
begin try
	if @x>@y
	while @x>@y 
	begin
	set @y+=1
	if @x=@y
	break
	insert into @values(vals) values(@y)
	end
	else if @x<@y
	while @x<@y 
	begin
	set @x+=1
	if @x=@y
	break
	insert into @values(vals) values(@x)
	end
end try
begin catch
select 'No values Between'
end catch

exec values_between 2,3
--3  takes Student No and returns Department Name with Student full name.
create proc get_stu_info @id int
as
	 select d.Dept_Name,S.St_Fname+' '+s.St_Lname as Fullname
	 from Department d,Student s
	 where d.Dept_Id=s.Dept_Id and s.St_Id=@id
--calling
get_stu_info 4

--4. takes Student ID and returns a message to user 
create proc Pmessage @sid int
as
declare @messagee varchar(50)
declare @firstname varchar(20)
declare @lastname varchar(20)
select @firstname=st_fname from Student where St_Id=@sid
select @lastname=St_Lname from Student where St_Id=@sid
if @firstname is null and @lastname is null
	set @messagee= 'First name & last name are null'
else if @firstname is null
	set @messagee= 'First name is null'
else if @lastname is null
	select @messagee= 'last name is null'
else
	set @messagee= 'First name & last name are not null'
select @messagee
--a.	If first name and Last name are null then display 'First name & last name are null'
exec Pmessage 50   --First name & last name are null
--b.	If First name is null then display 'first name is null'
exec Pmessage 14   --First name is null
--c.	If Last name is null then display 'last name is null'
exec Pmessage 13    --last name is null
--d. Else display 'First name & last name are not null'
exec Pmessage 1     --First name & last name are not null

--5. takes integer which represents manager ID and
-- displays department name, Manager Name and hiring date 
create proc managergetdata @idm int
as
select ins_name,dept_name,manager_hiredate
from Instructor i inner join Department d
on d.Dept_Id=i.Dept_Id and i.ins_id=@idm

exec managergetdata 3

--6. takes a string
create proc student_name @name varchar(50)
as 
if @name='first name'
select ISNULL(st_fname,' ')from Student
else if @name='last name'
select ISNULL(St_Lname,' ')from Student
else if @name='full name'
select ISNULL(St_Fname+' '+St_Lname,' ')from Student
--If string='first name' returns student first name
exec student_name 'first name'
--If string='last name' returns student first name
exec student_name 'last name'
--If string='full name' returns Full Name from student table 
exec student_name 'full name'
--7. Write a query that returns the Student No and Student first name without the last char
create proc stNdata
as 
select st_id,LEFT(St_Fname,len(St_Fname)-1) as newFname from Student
--calling
exec stNdata
--another sol for 7 without function
select st_id,substring(St_Fname,1,len(St_Fname)-1) as newFname from Student
--8. write a query to delete all grades for students located in SD department
create proc delgrade
as
delete from Stud_Course 
from Student s inner join Department d
on s.Dept_Id = d.Dept_Id and d.Dept_Name ='SD'
where Stud_Course.St_Id = s.St_Id  
--calling
exec delgrade --(0 rows affected)



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

create proc batch_insert @stu_Fname varchar(20), @stu_Lname varchar(20)
as
	  declare s integer,  @e integer   
      set @s = 3000
	  set @e = 6000
      while @s <= @e
      begin
      insert into Student
        values (@s, @stu_Fname, @stu_Lname,Null,Null,Null,Null)
      set @s = @s+1
      end
--calling
--take input when calling, EX. Fname = 'Jane', Lname = 'Smith'
exec batch_insert 'Jane','Smith'
