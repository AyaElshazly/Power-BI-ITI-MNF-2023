--1. Display all the data from the Employee table (HumanResources Schema) 
--As an XML document “Use XML Raw”. “Use Adventure works DB” 
--A)Elements
--B)Attributes
select * from [HumanResources].employee
for xml raw('employee'),elements,root('employees')
--2.Display Each Department Name with its instructors. “Use ITI DB”
--A)Use XML Auto
--B)Use XML Path
use ITI;
select d.dept_name ,i.ins_name
from instructor i,Department d
where i.dept_id=d.dept_id
for xml auto
select dept_name "@department" ,ins_name "instructor" 
from instructor,Department
where instructor.dept_id=Department.dept_id
for xml path('employee')
declare @docs xml ='<customers>
              <customer FirstName="Bob" Zipcode="91126">
                     <order ID="12221">Laptop</order>
              </customer>
              <customer FirstName="Judy" Zipcode="23235">
                     <order ID="12221">Workstation</order>
              </customer>
              <customer FirstName="Howard" Zipcode="20009">
                     <order ID="3331122">Laptop</order>
              </customer>
              <customer FirstName="Mary" Zipcode="12345">
                     <order ID="555555">Server</order>
              </customer>
       </customers>'
declare @hdocs int
exec sp_xml_preparedocument @hdocs output , @docs
select * from 
openxml(@hdocs,'//customer')
with(c_name varchar(20) '@FirstName', zip_code int '@Zipcode', order_id int 'order/@ID', orders varchar(40) 'order')
exec sp_xml_removedocument @hdocs
--4.Create a stored procedure to show the number of students per department.[use ITI DB] 
use ITI;
create proc students 
as
select d.Dept_Name as 'department' ,count(s.St_Id)
from Student s INNER JOIN Department d
ON s.Dept_Id=d.Dept_Id
group by (d.Dept_Name)
--5.Create a stored procedure that will check
--for the # of employees in the project p1 if
--they are more than 3 print message to the user
--“'The number of employees in the project p1 is
--3 or more'” if they are less display a message
--to the user “'The following employees work for
--the project p1'” in addition to the first name 
--and last name of each one. [Company DB] 
use SD;
create proc num_emp
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
--6.Create a stored procedure that will be used in case
--there is an old employee has left the project and a new 
--one become instead of him. The procedure should take 3
--parameters (old Emp. number, new Emp. number and the 
--project number) and it will be used to update works_on
--table. [Company DB]
create proc employee @new_id int ,@projectno varchar(2),@old_id int 
as 
update Works_on set EmpNo=@new_id, ProjectN=@projectno
where EmpNo=@old_id
                   --employee 5,p2,1
--7.Create an Audit table with the following structure 
--ProjectNo 	UserName 	ModifiedDate 	Budget_Old   Budget_New 
--p2 	        Dbo 	    2008-01-31	    95000 	     200000 
--This table will be used to audit the update trials
--on the Budget column (Project table, Company DB)
/*Example:If a user updated the budget column then the project number, user name that made that update, the date of 
the modification and the value of the old and the new
budget will be inserted into the Audit table
Note: This process will take place only if the user updated the budget column*/
create table his_project
(
projectno varchar(2),
username varchar (20),
ModifiedDate  date,
Budget_Old  int,
Budget_New  int
)
create trigger t1
on [company].Project
for update 
as
if update(projectno)
begin
declare @pronum varchar(2), @bold int ,@bnew int
select @pronum=projectno  from inserted
select @bnew=budget   from inserted
select @bold=budget   from deleted
insert into his_project values(@pronum,suser_name(),getdate(),@bold,@bnew)
end
update [company].Project set ProjecNo='p3', ProjectName='new' , Budget=5000 where ProjecNo=3
--8.Create a trigger to prevent anyone from inserting a new 
--record in the Department table [ITI DB]
--“Print a message for user to tell him that he can’t insert a new record in that table”
use ITI;
create trigger t2 
on Department
instead of insert
as
select 'You can’t insert a new record in that table'
insert into Department values(90,'MMM','Multimedia','Alex',NULL,'2009-01-01')
--Create a trigger that prevents the insertion Process for Employee table in March [Company DB].
use SD;
create trigger t3
on [Human Resource].Employee
after  insert
as
if (format(getdate(),'MMMM') = 'November')
begin
SELECT 'YOU CANNOT INSERT IN November'
delete from hr.[Human Resource].Employee where EmpNo=(select EmpNo from inserted)
end