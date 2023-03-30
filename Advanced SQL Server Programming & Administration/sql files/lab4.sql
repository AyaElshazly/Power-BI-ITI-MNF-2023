use Company_SD
--1 a)
select d.Dependent_name as 'Dependent name' , d.Sex as 'Dependent gender'
from Dependent d, Employee e
where d.Sex = 'F'  and e.SSN=d.ESSn and e.Sex='F'
union 
select d.Dependent_name as 'Dependent name' , d.Sex as 'Dependent gender'
from Dependent d,Employee e
where d.Sex = 'M'  and e.SSN=d.ESSn and e.Sex='M'
--2 For each project, list the project name and the total hours per week (for all employees) spent on that project.
select p.Pname, sum(isnull(w.Hours,0))
from Project p inner join Works_for w on p.Pnumber=w.Pno
group by P.Pname
--3 Display the data of the department which has the smallest employee ID over all employees' ID.
select d.* 
from Departments d
inner join Employee e 
on d.Dnum = e.Dno and SSN = (select min(SSN) from Employee)

--4 For each department, retrieve the department name and the maximum, minimum and average salary of its employees.
select Dname, min(Salary) as "Min Salary", max(Salary) as "Max Salary",avg(Salary) as "avg Salary" 
from Employee e inner join Departments d
on e.Dno=d.Dnum
group by Dname
--5 	List the full name of all managers who have no dependents.
select e.Fname +' '+e.Lname as 'Full name'
from Departments d, Employee e
where e.SSN = d.MGRSSN and MGRSSN in (select ESSn from Dependent)
--6.	For each department-- if its average salary is less than the average salary of all employees-- display its number, name and number of its employees.
select d.Dnum, d.Dname, COUNT(e.SSN) countEmp
from Departments d inner join Employee e
on d.Dnum = e.Dno
group by d.Dnum, d.Dname
having avg(e.Salary)  < (select avg(Salary) from Employee)
--7.	Retrieve a list of employees names and the projects names they are working on ordered by department number
--and within each department, ordered alphabetically by last name, first name.
select d.Dnum, e.Fname+' '+e.Lname as 'Full name', p.Pname
from Employee e, Departments d, Project p, works_for w
where d.Dnum = e.Dno
and e.SSN = w.ESSn and w.Pno = p.Pnumber
order by d.Dname, e.Lname, e.Fname
--8.	Try to get the max 2 salaries using subquery
select (select max(Salary) from Employee) as '1-st max',
(select max(Salary) from Employee where Salary not in (select max(Salary) from Employee)) as '2-ndt max'
--9.	Get the full name of employees that is similar to any dependent name
SELECT e.Fname+' '+e.Lname as 'Full name'
	FROM Employee e
	INNER JOIN Dependent d ON d.Essn = e.SSN
	WHERE e.Fname+' '+e.Lname = d.Dependent_name

--10.	Display the employee number and name if at least one of them have dependents (use exists keyword) self-study.
select SSN,Fname,Lname from Employee e
where exists(select * from Dependent where e.SSN=ESSn)
--11.	In the department table insert new department called "DEPT IT" ,
--with id 100, employee with SSN = 112233 as a manager for this department. The start date for this manager is '1-11-2006'
insert into Departments VALUES ('DEPT IT', 100, 112233, '1-11-2006')

--12.	Do what is required if you know that : Mrs.Noha Mohamed(SSN=968574)  moved to be the manager of the new department (id = 100), 
--and they give you(your SSN =102672) her position (Dept. 20 manager) 
--a.	First try to update her record in the department table
UPDATE Departments
SET MGRSSN=968574
WHERE Dnum=100;
update Employee set Dno=100 where SSN=968574 
--b.	Update your record to be department 20 manager.
UPDATE Departments
SET MGRSSN=102672
WHERE Dnum=20;
update Employee set Dno=20 where SSN=102672 
--c.	Update the data of employee number=102660 to be in your teamwork (he will be supervised by you) (your SSN =102672)
update Employee
set Dno=20, Superssn=102672
where SSN = 102660
--13.	Unfortunately the company ended the contract with Mr. Kamel Mohamed (SSN=223344) 
--so try to delete his data from your database in case you know that you will be temporarily in his position.
--Hint: (Check if Mr. Kamel has dependents, works as a department manager, 
--supervises any employees or works in any projects and handle these cases).
select SSN from Employee where Superssn=223344 --(112233,123456)
select * from Departments where MGRSSN=223344 --(DP1,Dnum=10)
select * from Works_for where ESSn=223344 --(4 rows Pno=100,200,300,500)
select * from Dependent where ESSN=223344 --
update Employee set Superssn=102672 where SSN in (select SSN from Employee where Superssn=223344);
update Departments set MGRSSN=102672 where MGRSSN=223344;
update Works_for set ESSn = 102672 where ESSn=223344;

delete from Dependent where ESSn=223344;

delete from Employee where SSN = 223344;

--14.	Try to update all salaries of employees who work in Project ‘Al Rabwah’ by 30%
update Employee
set Salary+=Salary*0.30
where SSN in (select Essn from Works_for w
inner join Project p
on w.Pno=p.Pnumber and Pname='Al Rabwah')
