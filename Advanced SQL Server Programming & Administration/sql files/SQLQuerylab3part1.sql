--1.	Display the Department id, name and id and the name of its manager.
SELECT d.Dnum, d.Dname, d.MGRSSN, CONCAT(e.Fname,' ',e.Lname) as "Manager Name"
FROM departments d 
INNER JOIN employee e 
ON (e.SSN=d.MGRSSN)
--2.	Display the name of the departments and the name of the projects under its control.
SELECT d.Dname, p.pname 
FROM departments d 
INNER JOIN Project p
ON (d.dnum = p.dnum)
--3.	Display the full data about all the dependence associated with the name of the employee they depend on him/her.
select d.*, e.Fname as "the name of the employee they depend on"
from Dependent d
Inner join Employee e
ON (e.SSN = d.ESSN)
--4.	Display the Id, name and location of the projects in Cairo or Alex city.
select Pnumber, Pname, Plocation
from Project
where City in ('Cairo', 'Alex')
--5.	Display the Projects full data of the projects with a name starts with "a" letter.
select * 
from Project
where Pname like 'a%'
--6.	display all the employees in department 30 whose salary from 1000 to 2000 LE monthly
select * 
from employee where Dno = 30 and Salary between 1000 and 2000
--7.	Retrieve the names of all employees in department 10 who works more than or equal10 hours per week on "AL Rabwah" project.
select e.Fname+' '+e.Lname as 'Employee Name'
from Employee e
inner join Works_for w
on e.SSN = w.ESSn
inner join Project p
on p.Pnumber = w.pno
and e.Dno =10 
and w.Hours >= 10 
and p.Pname = 'AL Rabwah'
--8.	Find the names of the employees who directly supervised with Kamel Mohamed.
select concat (e.Fname,' ' , e.Lname) as "Employee name", concat (s.Fname,' ' , s.Lname) as"Manager name"
from Employee e join Employee s
on s.SSN = e.Superssn
and s.Fname+' '+ s.Lname = 'Kamel Mohamed'
--9.	Retrieve the names of all employees and the names of the projects they are working on, sorted by the project name.
select e.Fname , p.Pname
from employee e
inner join Works_for w
on (e.SSN = w.ESSn)
inner join Project p
on (p.Pnumber = w.pno) 
order by p.Pname
--10.	For each project located in Cairo City , find the project number, the controlling department name ,the department manager last name ,address and birthdate.
select p.Pnumber, d.Dname,e.Lname, e.Bdate, e.Address
from Project p inner join Departments d
on (d.Dnum = p.Dnum) 
inner join employee e
on (e.SSN = d.MGRSSN)
where p.City = 'Cairo'
--11.	Display All Data of the managers
select e.* from Employee e  
inner join departments d
on e.SSN = d.MGRSSN
--12.	Display All Employees data and the data of their dependents even if they have no dependents
select e.*,d.*
from Employee e left outer join Dependent d
	on e.SSN = d.ESSN
--13.	Insert your personal data to the employee table as a new employee in department number 30, SSN = 102672, Superssn = 112233, salary=3000.
insert into Employee
values ('Aya','Mahmoud',102672,'2000-01-01','Mitberah','F',3000,112233,30)

--14.	Insert another employee with personal data your friend as new employee in department number 30, SSN = 102660, but don’t enter any value for salary or supervisor number to him.
insert into Employee
values ('Asmaa','Ahmed',102660,'2000-07-12','Mitberah','F',Null,NULL,30)
--15.	Upgrade your salary by 20 % of its last value.
update Employee
set Salary += Salary*0.20
where SSN=102672