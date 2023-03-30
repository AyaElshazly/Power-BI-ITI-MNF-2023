--1. Retrieve number of students who have a value in their age
select count(St_Id) as 'Number of Students'
from Student
where St_Age is not null

--2. Get all instructors Names without repetition
select distinct(Ins_Name)
from Instructor

--3. Display student with the following Format (use isNull function)
select st_id as "Student ID",concat(s.St_Fname ,' ', s.St_Lname) as "Student Full Name",ISNULL(Dept_Name,'No department') as "Department name"
from Student s, Department d
where s.Dept_Id = d.Dept_Id

/*4. Display instructor Name and Department Name.
Note: display all the instructors if they are attached to a department or not.*/
select Ins_Name,Dept_Name
from  Instructor i left outer join Department d
on i.Dept_Id = d.Dept_Id

--5. Display student full name and the name of the course he is taking, For only courses which have a grade
select St_Fname +' '+ St_Lname as "Full Name", c.Crs_Name 
from Student s , Stud_Course sc , Course c
where s.St_Id = sc.St_Id and c.Crs_Id = sc.Crs_Id and sc.Grade is not null

--6. Display number of courses for each topic name
select Top_Name , count(Crs_Id) as "Number of courses"
from Topic t , Course c
where t.Top_Id = c.Top_Id
group by Top_Name

--7. Display max and min salary for instructors
select max(Salary) as "Maximum Salary", min(Salary) as "Minimum Salary"
from Instructor

--8. Display instructors who have salaries less than the average salary of all instructors
select *
from Instructor
where Salary < (select AVG(isnull(Salary,0)) from Instructor)

--9. Display the Department name that contains the instructor who receives the minimum salary
select Dept_Name
from Department d, Instructor i
where d.Dept_Id = i.Dept_Id and Salary <= (select min(Salary) from Instructor)

--10. Select max two salaries in instructor table
select max(salary) as 'Max two salaries'
from Instructor 
union 
select max(salary)  
from Instructor 
where Salary < (select max(Salary) from Instructor) 

/*11. Select instructor name and his salary but if there is no salary display instructor bonus
“use one of coalesce Function”*/
select Ins_Name , 
coalesce(Salary,0) 
from Instructor

--12. Select Average Salary for instructors
select avg(isnull(salary,0)) as "Average Salary"
from Instructor

--13. select student first name and the data of his supervisor
select s1.St_Fname, s2.*
from Student s1 inner join Student s2
on s1.St_super = s2.St_Id

/*14. Write a query to select the highest two salaries in Each Department for instructors who have salaries. 
“using one of Ranking Functions”*/
select Salary
from (select * , DENSE_RANK() OVER(PARTITION BY Dept_Id ORDER BY Salary DESC) AS DR FROM Instructor) as NewTable
where DR<=2

--15. Write a query to select a random  student from each department.  “using one of Ranking Functions”
select *
from (select * , ROW_NUMBER() OVER(ORDER BY Dept_Id DESC) AS RN FROM Student) as NewTable
where RN=1 