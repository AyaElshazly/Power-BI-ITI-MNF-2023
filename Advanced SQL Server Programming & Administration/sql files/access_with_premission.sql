-- check permission
--Course table
select * from course --display course details
insert into Course values (1300,'DB Programming',35,2) --1 row affected
delete from Course where Crs_id=100
--(errorfor below queries)The DELETE/UPDATEpermission was denied on the object 'Course', database 'ITI', schema 'dbo'
update course set Crs_Name='SQL' where Crs_Id=100

--Student Table
select * from Student --display course details
insert into Student values (15,'Aya','Mahmoud','Mounifa',22,10,NULL) --1 row affected
--(errorfor below queries)The DELETE/UPDATE permission was denied on the object 'Student', database 'ITI', schema 'dbo'
delete from Student where St_Id=1
update Student set St_Fname='Aser' where St_Id=1
