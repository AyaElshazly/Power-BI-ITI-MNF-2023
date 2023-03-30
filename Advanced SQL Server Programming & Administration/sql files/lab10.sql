--1
use Company_SD;
declare c1 cursor
for select salary from Employee 
for update
declare @sal int
open c1
fetch c1 into @sal
while @@fetch_status=0
begin
if @sal>=3000
update Employee set salary = @sal*1.20 where current of c1
else
update Employee set salary = @sal*1.10 where current of c1
fetch c1 into @sal
end
close c1
deallocate c1

--2
use ITI;
declare c2 cursor
for select d.Dept_Name, i.Ins_Name
from Department d inner join Instructor i
on d.Dept_Manager = i.Ins_Id
for read only
declare @dname varchar(20), @mname varchar(20)
open c2
fetch c2 into @dname,@mname
while @@fetch_status=0
begin
select @dname, @mname 
fetch c2 into @dname, @mname
end
close c2
deallocate c2
--3
use ITI;
declare c3 cursor
for select St_Fname 
from Student where St_Fname is not null
for read only
declare @name varchar(20), @allnames varchar(200)=' '
open c3
fetch c3 into @name
while @@fetch_status=0
begin
set @allnames=concat(@allnames, ',',@name)
fetch c3 into @name
end
select @allnames
close c3
deallocate c3
--4
backup database SD to disk = 'F:\restoredSD'
--Cannot open backup device 'F:\restoredSD'. Operating system error 5(Access is denied.).
--restored successfully using wizard
--5 export status:success
--6

--7
create table test_t (did int, name varchar(20))

create sequence sq
start with 1 
increment by 1 
minvalue 1
maxvalue 10
no cycle

insert into test_t (did,name)
values(next value for sq, 'Aya')

select * from test_t