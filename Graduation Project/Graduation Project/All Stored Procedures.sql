GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE PROC examGeneration @exam_title nvarchar(300), @exam_fullmark int,@cr_id int=1 ,@exam_startdate datetime,
                         @exam_enddate datetime,@questions_numbers int,@tfNum int=5, @mcqNum int=5 
WITH ENCRYPTION
AS
BEGIN	
	begin try
	-- Generate random number of the mcq questions
	
		declare @Nmcq int = (select count(*) from Question where cr_id = @cr_id and quest_type='mc')
		declare @TFmcq int = (select count(*) from Question where cr_id = @cr_id and quest_type='tf')
		declare @mcqTemp table (id int, qt nvarchar(20),q nchar(500), ans nchar(500), cr_id int, ql nchar(1))
		declare @tfTemp table (id int, qt nvarchar(20),q nchar(500), ans nchar(500), cr_id int, ql nchar(1))


		if(@Nmcq < @mcqNum)
			begin 
				select 'MCQ questions is not enough'
				return
			end

		insert @mcqTemp(id, qt,q, ans, cr_id, ql)
		select top(@mcqNum)*
		from Question
		where quest_type = 'mc' and cr_id = @cr_id
		order by newid()
		
	-- Generate random number of the true/false questions
		if(@TFmcq < @tfNum)
			begin 
				select 'True/False questions is not enough'
				return
			end


		insert @tfTemp(id, qt,q, ans, cr_id, ql)
		select top(@tfNum)*
		from Question
		where quest_type = 'tf'and cr_id = cr_id
		order by newid()
		


	-- Union the 2 tables
		declare @examQuestions table (id int, qt nvarchar(20),q nchar(500), ans nchar(500), cr_id int, ql nchar(1))
		insert into @examQuestions (id, qt, q, ans, cr_id, ql)
		select * from @tfTemp
		union
		select * from @mcqTemp	

		-- Adding new Exam to Exam Table
		declare @newExamID int = (select max(exam_id) from Exam)+1
		insert into Exam(exam_id, exam_title,exam_fullmark,cr_id,exam_startdate,exam_enddate,questions_numbers)
		values    (@newExamID,@exam_title,@exam_fullmark,@cr_id,@exam_startdate,@exam_enddate,@questions_numbers)

		-- Adding  exam to question @exam_id int,@quest_id intþ Exam_Questionþ

	
	   declare question_cursor cursor 
		for select id
			from @examQuestions
		declare @q int
		open question_cursor
		fetch question_cursor into @q
		while @@FETCH_STATUS=0
			begin
				insert into Exam_Question(exam_id,quest_id)
				values(@newExamID,@q)
				fetch question_cursor into @q
			end
		close question_cursor
		deallocate question_cursor

		declare @stu_table table (st_id int)
		insert into @stu_table (st_id)
		select st_id from Student_Course where cr_id=@cr_id


		declare cr cursor 
		for select st_id 
			from @stu_table
		declare @qq int
		open cr
		fetch cr into @qq
		while @@FETCH_STATUS=0
			begin
				insert into Student_Exam(st_id,ex_id,st_ex_starttime,st_ex_endtime,solved_questions)
				values(@qq,@newExamID,'2022-06-07 11:08:00.000','2022-06-07 11:08:00.000',0)
				fetch cr into @qq
			end
		close cr
		deallocate cr

	-- OUTPUT the Exam Questions randomly	   
		select id as [Question_ID],
			   qt as [Question_type],
			   q as [Question_Text],
			   ans as [Model answer],
			    cr_id as [Course_ID],
			   ql as [Question_level] from @examQuestions order by NEWID()
	end try
	begin catch
		select 'Error in generating the exam'
	end catch
END
GO

---------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE PROC examCorrection @examID INT, @studentID INT
WITH ENCRYPTION
AS
BEGIN
	BEGIN TRY
		----Store the model answer for each question compared to the Student answer---
		DECLARE @correctAns TABLE (Qid int, ModelAns varchar(100), userAns varchar(100))
		INSERT @correctAns(Qid, ModelAns, userAns)
		SELECT Q.quest_id, quest_answer, st_answer
		FROM Student_Exam_Question As SE, Question AS Q
		WHERE SE.quest_id= Q.quest_id AND st_id = @studentID AND ex_id = @examID

		
		------Set the grade for the correct answers-------
		UPDATE Student_Exam_Question
		SET quest_grade= 1
		WHERE quest_id IN
		(
			SELECT Qid FROM @correctAns
			WHERE ModelAns = userAns
			AND st_id = @studentID AND ex_id = @examID 
		) and st_id = @studentID AND ex_id = @examID 


		---------Set the null values by zero--------------
		UPDATE Student_Exam_Question
		SET quest_grade = 0 
		WHERE quest_id not IN
			(SELECT Qid FROM @correctAns
			WHERE ModelAns = userAns
			AND st_id = @studentID AND ex_id = @examID
			)and st_id = @studentID AND ex_id = @examID 


		---------Compute student final grade--------------
		DECLARE @StudentDegree FLOAT  = (SELECT SUM(quest_grade) FROM Student_Exam_Question
										  WHERE st_id  = @studentID AND ex_id = @examID )
		DECLARE @FinalDegree FLOAT = (SELECT COUNT(quest_grade) FROM Student_Exam_Question
								   	   WHERE st_id = @studentID AND ex_id = @examID )
		DECLARE @StudentPrec FLOAT = (@StudentDegree/@FinalDegree) * 100


		IF(@StudentPrec IS NULL)
		BEGIN
			SELECT 'Student Did not take this exam'
			RETURN
		END
		UPDATE Student_Course
		SET grade= @StudentPrec
		WHERE st_id = @studentID AND cr_id= (select cr_id from Exam where exam_id= @examID)

		UPDATE Student_Exam
		SET solved_questions= @StudentDegree
		WHERE st_id = @studentID AND ex_id= @examID

		SELECT @StudentPrec AS 'Student Degree'
	END TRY

	BEGIN CATCH
		SELECT 'Error in correcting the user exam'
	END CATCH
END
GO

--------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE PROC examAnswer
			@student_Id INT,
			@exam_Id INT,
			@question_ID INT,
			@Student_Answer VARCHAR(max)
WITH ENCRYPTION
AS 
	INSERT INTO Student_Exam_Question (st_id,ex_id,quest_id,st_answer,quest_grade)
	VALUES(@student_Id,@exam_Id,@question_ID,@Student_Answer,0)
	
GO


--------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create  proc insert_Certificate (@cert_id int, @cert_title nvarchar(100), @cert_website varchar(50),@cert_startdate  date,@cert_enddate date,@cert_hours int)
WITH ENCRYPTION
As
begin
	if not exists(select [cert_id] from [dbo].[Certification] where [cert_id]=@cert_id )
		insert into[dbo].[Certification]([cert_id],[cert_title],[cert_website],[cert_startdate],[cert_enddate],[cert_hours])
		values (@cert_id, @cert_title,@cert_website,@cert_startdate,@cert_enddate,@cert_hours )
	else
	select 'Dublicate id'
	   
end
GO

--------------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insert_Choise]
  @choise_id int ,
 @choise_text varchar(30),
 @quest_id int
 WITH ENCRYPTION
 as
 begin 

 if not exists(select quest_id from Question where quest_id=@quest_id )
      select'Question not exist'
else if exists(select quest_id from Choise where quest_id=@quest_id)
  select'dublicated pk'
else
 insert into dbo.Choise
 (choise_id , choise_text ,quest_id  )
 values( @choise_id  , @choise_text ,@quest_id  )
end
GO

--------------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create proc  insert_Course (@cr_id int ,@cr_name nvarchar(100),@cr_hours_duration int ,@cr_days_duration int )
WITH ENCRYPTION
as
begin 
	if  exists (select [cr_id] from [dbo].[Course] where  [cr_id] =@cr_id)
		select 'Dublicate id'
	else
				insert into [dbo].[Course] (cr_id,cr_name,cr_hours_duration,cr_days_duration)
				values (@cr_id ,@cr_name,@cr_hours_duration,@cr_days_duration)

          
end
GO

-------------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create proc  insert_CourseInstructor(@cr_id int ,@ins_id int)
  WITH ENCRYPTION
  as
  begin 
	if not exists (select * from Instructor where [ins_id]=@ins_id) and not exists (select * from Course where [cr_id]=@cr_id)
		select 'Instructor and Course not Exist'
   else if not exists (select * from Course where [cr_id]=@cr_id)
	      select 'Course not Exist'	 
							  
   else if not exists  (select * from Instructor where [ins_id]=@ins_id)
			    select 'Instructor not Exist'
   else if not exists (select * from Course_Instructor where [cr_id]=@cr_id and  [ins_id]=@ins_id) 
                 select 'invalid id'
  else				
			  insert into [dbo].[Course_Instructor] (cr_id ,ins_id)
			  values (@cr_id ,@ins_id)

          
  end
GO

----------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create proc  insert_coursetopic(@cr_id int ,@topic_id int)
  WITH ENCRYPTION
  as
  begin 
	if not exists (select * from Topic where topic_id=@topic_id) and not exists (select * from Course where [cr_id]=@cr_id)
		select ' Course and topic not Exist'
   else if not exists (select * from Course where [cr_id]=@cr_id)
	      select 'course not Exist'	 
							  
   else if not exists (select * from Topic where topic_id=@topic_id)
			    select 'topic  not Exist'
   else if  exists (select * from Course_Topic where [cr_id]=@cr_id and topic_id=@topic_id) 
                 select 'dublicated id'
  else				
			  insert into [dbo].[Course_Topic] (cr_id,topic_id)
			  values (@cr_id ,@topic_id)

          
  end
GO

------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create proc  insert_courseTrack(@cr_id int,@track_id int)
WITH ENCRYPTION
as
begin 
	if not exists (select * from Track where [track_id]=@track_id) and not exists (select * from Course where [cr_id]=@cr_id)
		select 'student and track not Exist'
	else if not exists (select * from Track where [track_id]=@track_id)
			select 'Track not Exist'	 
							  
	else if not exists (select * from Course where [cr_id]=@cr_id)
				select 'Course  not Exist'
	else if  exists (select * from Course_Track where [cr_id]=@cr_id and [track_id]=@track_id) 
					select 'dublicated id'
	else				
				insert into [dbo].[Course_Track] (track_id,cr_id)
				values (@track_id,@cr_id)

          
end
GO

------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create PROCEDURE dbo.insert_Exam
          @exam_id INT,@exam_title NVARCHAR(50),
				@exam_startdate date,
				@exam_enddate date,@exam_fullmark int,
				@cr_id int,@questions_numbers int
WITH ENCRYPTION
AS  
   BEGIN 
   IF NOT EXISTS(SELECT exam_id FROM dbo.Exam WHERE exam_id=@exam_id) and exists(select cr_id from Course where cr_id=@cr_id)
     INSERT INTO dbo.Exam
     (
         exam_id,
       exam_title,
         exam_startdate,
         exam_enddate,
        exam_fullmark,cr_id ,questions_numbers
     )
     VALUES
     (    @exam_id ,
	       @exam_title,
			@exam_startdate,
			@exam_enddate,
			@exam_fullmark ,@cr_id,@questions_numbers
         )
     ELSE
     SELECT'Invalid ID'
   END
GO

-------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create proc insert_Exam_Question
@exam_id int,@quest_id int
 WITH ENCRYPTION
 as
 begin
 if  not exists(select exam_id from Exam where exam_id=@exam_id )
 and not exists(select quest_id from Question where quest_id=@quest_id )
            select'Exam and Question not exist'
else if not exists(select exam_id from Exam where exam_id=@exam_id)
       select'Exam not exist'
else if	 not exists(select quest_id from Question where quest_id=@quest_id )
 select'Question not exist'
else if exists(select exam_id,quest_id from Exam_Question where exam_id=@exam_id and quest_id=@quest_id)
  select'dublicated pk'
else
insert into Exam_Question
(exam_id,quest_id)
values(@exam_id,@quest_id)
end
GO

---------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create proc insert_Freelancing (@fl_id int,@job_name nvarchar(50),@fl_website nvarchar(50),@fl_date date,@st_id int)
 WITH ENCRYPTION
	as
	begin
		if  exists (select * from Freelancing where [fl_id]=@fl_id )
			 select 'duplicated id'
		else if not exists (select st_id from Student where st_id=@st_id) 
			 select 'student not exist'	
		else
		 insert into Freelancing(fl_id,job_name,fl_website,fl_date,st_id)
		 values (@fl_id ,@job_name,@fl_website,@fl_date,@st_id)
					
end
GO

---------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create proc insert_FreelancingSkills (@fl_id int,@tool nvarchar(50))
WITH ENCRYPTION
as
begin
 
		if   not exists (select * from Freelancing where [fl_id]=@fl_id )
			select 'freelancing not exist'
		else
			insert into Freelancing_Tools(fl_id,tool)
			values (@fl_id ,@tool)
end
GO

-----------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
 create proc insert_Hiring (@hiring_id int,@position nvarchar(100),@job_type nvarchar(20),@job_location nvarchar(20),@hiring_date date
                                 ,@company nvarchar(50),@st_id int)
 WITH ENCRYPTION
	as
	begin
		if  exists (select * from Hiring where [hiring_id]=@hiring_id )
			 select 'duplicated id'
		else if not exists (select st_id from Student where st_id=@st_id) 
			 select 'student not exist'	
		else
		 insert into Hiring(hiring_id,job_title ,job_type,job_location,hiring_date,company_name,st_id)
		 values (@hiring_id ,@position,@job_type,@job_location,@hiring_date,@company,@st_id)
					
end
GO

-------------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
 create PROCEDURE dbo.insert_Instructor
          @ins_id INT,@ins_ssn nvarchar(50),
		  @ins_fname nvarchar(50),
				@ins_lname nvarchar(50),
				@ins_gender nvarchar(10),@ins_birthdate date,@ins_salary float,
				@ins_city nvarchar(50)
				
WITH ENCRYPTION
AS  
   BEGIN 
   IF NOT EXISTS(SELECT ins_id FROM  dbo.Instructor WHERE ins_id=@ins_id)
     INSERT INTO dbo.Instructor
     (
        ins_id,ins_ssn ,ins_fname,
		ins_lname ,
		ins_birthdate,ins_gender,
		ins_city,ins_salary
     )
     VALUES
     (     @ins_id,@ins_ssn ,
		  @ins_fname,@ins_lname,
				@ins_birthdate ,@ins_gender
         ,@ins_city ,@ins_salary
			)
     ELSE
     SELECT'Duplicate ID'
   END
GO

---------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create proc  insert_instructorTrack(@ins_id int ,@track_id int)
WITH ENCRYPTION
as
begin 
	if not exists (select * from Track where [track_id]=@track_id) and not exists (select * from instructor where [ins_id]=@ins_id)
		select 'instructor and track not Exist'
	else if not exists (select * from Track where [track_id]=@track_id)
			select 'Track not Exist'	 
							  
	else if not exists (select * from instructor where [ins_id]=@ins_id)
				select 'instructor not Exist'
	else if  exists (select * from Instructor_Track where [ins_id]=@ins_id and [track_id]=@track_id) 
					select 'dublicated id'
	else				
				insert into [dbo].Instructor_Track (ins_id,track_id)
				values (@ins_id ,@track_id)

          
end
GO

--------------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create PROCEDURE dbo.insert_intake
          @int_id int,@int_startdate date,@int_enddate date,@expected_startdate date,@expected_enddate date
WITH ENCRYPTION
AS  
   BEGIN 
   IF NOT EXISTS(SELECT int_id from Intake WHERE int_id=@int_id)
     INSERT INTO dbo.Intake
     ( int_id,
       int_startdate,
        int_enddate,
        expected_startdate,
        expected_enddate)
     VALUES
     ( @int_id,
       @int_startdate,
         @int_enddate,
         @expected_startdate,
        @expected_enddate
         )
     ELSE
     SELECT'Duplicate ID'
   END
GO

-------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create procedure insert_question
(
@quest_id int,
@quest_type nvarchar(20),
@quest_text nchar(500),
@quest_answer nchar(500),
@cr_id int,
@quest_level nchar(1)
)
with encryption 
as 
begin 
if exists (select quest_id from Question where quest_id=@quest_id)
  select'Duplicate id'
else
if not exists (select cr_id from Course where cr_id=@cr_id )
  select 'Invalid Id'
else 
insert into Question values (@quest_id ,@quest_type ,@quest_text ,@quest_answer ,@cr_id ,@quest_level)
end 
GO

--------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create proc insert_Register_Instructor
 @ins_id int,@register_id int,@ins_register_insertion_date date
 WITH ENCRYPTION
 as
 begin
 if not exists(select * from Instructor where ins_id= @ins_id)and not exists(select * from Registeration where register_id=@register_id )
            select'instructor and Registeration not exist'
else if not exists(select * from Instructor where ins_id=@ins_id)
       select'Instructor not exist'
else if not exists(select * from Registeration where register_id=@register_id)
       select'Registeration not exist'
else if exists(select * from Register_Instructor where ins_id=@ins_id and register_id=@register_id)
  select'dublicated pk'
else
insert into Register_Instructor
values(@register_id,@ins_id,@ins_register_insertion_date)
end
GO

----------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create proc insert_Register_Student
 @st_id int,@register_id int,@st_register_insertion_date date
 WITH ENCRYPTION
 as
 begin
 if not exists(select * from Student where st_id= @st_id)and not exists(select * from Registeration where register_id=@register_id )
            select'student and Registeration not exist'
else if not exists(select * from Student where st_id=@st_id)
       select'Student not exist'
else if not exists(select * from Registeration where register_id=@register_id)
       select'Registeration not exist'
else if exists(select * from Register_Student where st_id=@st_id and register_id=@register_id)
  select'dublicated pk'
else
insert into Register_Instructor
values(@register_id,@st_id,@st_register_insertion_date)
end
GO

---------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create PROCEDURE dbo.insert_registration 
          @register_id INT,@email NVARCHAR(50),
				@username nvarchar(50),
				@password  nvarchar(50),
				@usertype nvarchar(20)
WITH ENCRYPTION
AS  
   BEGIN 
   IF NOT EXISTS(SELECT register_id FROM dbo.Registeration WHERE register_id=@register_id)
     INSERT INTO dbo.Registeration
     (
         register_id,
        email,
         username,
         password,
         usertype
     )
     VALUES
     (    @register_id ,
	       @email,
			@username,
			@password,
			@usertype
         )
     ELSE
     SELECT'Duplicate ID'
   END
GO

------------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE procedure insert_student
(
@st_id int,
@st_ssn nvarchar(50),
@st_birthdate date,
@st_city nvarchar(50),
@st_fname nvarchar(50),
@st_lname nvarchar(50),
@st_gender nvarchar(10),
@track_id int,
@int_id int
)
with encryption 
as 
begin 
if exists ( select st_id from student where st_id=@st_id )
    select 'Duplicated ID , Insert another one'
else if not exists (select @int_id  from Intake where int_id= @int_id) and not exists (select track_id from track where track_id = @track_id)
    select 'Invalid Intake Id and Track Id'
else if not exists (select @int_id  from Intake where int_id= @int_id)
     select 'Invalid Intake Id'
else iF not exists (select track_id from track where track_id = @track_id)
      select 'Invalid Track Id'
ELSE 
INSERT INTO Student VALUES (@st_id ,@st_ssn,@st_birthdate,@st_city ,@st_fname,@st_lname, @st_gender, @track_id,@int_id)

declare @cr_table table (cr_id int)
		insert into @cr_table (cr_id)
		select cr_id from Course_Track where track_id=@track_id



declare cr cursor 
	for select cr_id 
		from @cr_table
	declare @q int
	open cr
	fetch cr into @q
	while @@FETCH_STATUS=0
		begin
			insert into Student_Course(cr_id,st_id,grade,cr_rate,ins_rate)
			values(@q,@st_id,0,10,10)
			fetch cr into @q
		end
	close cr
	deallocate cr


insert into Registeration values((select max(register_id) from Registeration)+1,concat(CAST(@st_id AS nvarchar),'@gmail.com'),CAST(@st_id AS nvarchar),123,'Student')
insert into Register_Student values (@st_id,(select max(register_id) from Registeration),'2020-05-07')
end
GO

-----------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create proc insert_Student_Exam
 @st_id int,@exam_id int,@solved_questions int,@st_ex_starttime datetime,@st_ex_endtime datetime
 WITH ENCRYPTION
 as
 begin
 if not exists(select st_id from Student where st_id= @st_id)and not exists(select exam_id from Exam where exam_id=@exam_id )
            select'Student and Exam not exist'
else if not exists(select st_id from Student where st_id= @st_id)
       select'Intake not Student'
else if not exists(select exam_id from Exam where exam_id=@exam_id)
       select'Exam not exist'
else if exists(select st_id,ex_id from Student_Exam where st_id=@st_id and ex_id =@exam_id )
  select'dublicated pk'
else
insert into Student_Exam
(st_id,ex_id,solved_questions,st_ex_starttime,st_ex_endtime)
values(@st_id,@exam_id,@solved_questions,@st_ex_starttime,@st_ex_endtime)
end
GO

-----------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create proc insert_Student_Exam_Question
@ex_id int,@st_id int,@quest_id int,@st_answer nvarchar(MAX),@quest_grade int
 WITH ENCRYPTION
 as
 begin
 if not exists(select st_id from Student where st_id= @st_id)and not exists(select exam_id from Exam where exam_id=@ex_id )
 and not exists(select quest_id from Question where quest_id=@quest_id )
            select'Student, Exam and Question not exist'
else if not exists(select st_id from Student where st_id= @st_id)
       select'Intake not Student'
else if not exists(select exam_id from Exam where exam_id=@ex_id)
       select'Exam not exist'
else if	 not exists(select quest_id from Question where quest_id=@quest_id )
 select'Question not exist'
else if exists(select st_id,ex_id,quest_id from Student_Exam_Question where st_id=@st_id and ex_id=@ex_id and quest_id=@quest_id)
  select'dublicated pk'
else
insert into Student_Exam_Question
(st_id,ex_id,quest_id,st_answer,quest_grade)
values(@st_id,@ex_id,@quest_id,@st_answer,@quest_grade)
end
GO

----------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create procedure  insert_StudentCertification  @st_id int,@cert_id int
WITH ENCRYPTION
As
begin
	   if not exists (select * from Student where [st_id]=@st_id) and not exists (select * from Certification where [cert_id]=@cert_id)
			select 'student and Certification not Exist'
	   else if not exists (select * from Certification where [cert_id]=@cert_id)
			  select 'Certification not Exist'	 
							  
		else if not exists (select * from Student where [st_id]=@st_id)
					select 'student  not Exist'
		else if  exists (select * from Student_Certification where [cert_id]=@cert_id and [st_id]=@st_id) 
			 select 'dublicated id'
		else
					
			insert into [Student_Certification] values( @st_id,@cert_id)
					 

 end
GO

---------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE proc  insert_studentcourse(@cr_id int ,@st_id int,@grade int ,@cr_rate int,@ins_rate int)
  WITH ENCRYPTION
  as
  begin 
	if not exists (select * from Student where [st_id]=@st_id) and not exists (select * from Course where [cr_id]=@cr_id)
		select 'student and Course not Exist'
   else if not exists (select * from Course where [cr_id]=@cr_id)
	      select 'Course not Exist'	 
							  
   else if not exists (select * from Student where [st_id]=@st_id)
			    select 'student  not Exist'
   else if  exists (select * from Student_Course where [cr_id]=@cr_id and [st_id]=@st_id) 
                 select 'dublicated id'
  else				
			  insert into [dbo].[Student_Course] (cr_id,st_id,grade,cr_rate,ins_rate)
			  values (@cr_id ,@st_id,@grade,@cr_rate,@ins_rate)

          
  end
GO


----------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create proc insert_topic  @topic_id  int ,@topic_name nvarchar(50)
With encryption
As 
begin

	if exists (select topic_id from Topic where  topic_id=@topic_id )
	    select 'dublicate id'
	else  
	    insert into  Topic (topic_id,topic_name) values (@topic_id ,@topic_name)
end
GO

------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
 create procedure insert_track
(
@track_id int,
@track_name nvarchar(100),
@supervisor_id int 
)
with encryption
as
begin 
if  exists (select track_id  from Track where track_id=@track_id)
   select 'Duplicated ID, insert another one '
else
if not exists (select ins_id from Instructor where ins_id=@supervisor_id)
   select' invalid instructor id'
else 
 insert into Track values (@track_id,@track_name,@supervisor_id)
 end
GO

------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create proc  NCourse_NumStud  @ins_id int 
with encryption
As
SELECT        Course.cr_name As [course name], count (st_id) As [Number of student]
FROM            Course INNER JOIN
                         Course_Instructor ON Course.cr_id = Course_Instructor.cr_id INNER JOIN
                         Student_Course ON Course.cr_id = Student_Course.cr_id 
						 where  ins_id=@ins_id

						 group by Course.cr_name
						
GO

--------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create proc  questions  @ex_id int 
with encryption
AS

SELECT   Question.quest_text, Choise.choise_text
FROM   Choise INNER JOIN
                         Exam_Question ON Choise.quest_id = Exam_Question.quest_id INNER JOIN
                         Question ON Choise.quest_id = Question.quest_id AND Exam_Question.quest_id = Question.quest_id
						 where  Exam_Question.exam_id=@ex_id 

						


GO


-------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create proc questions_studAnswer @ex_id int ,@st_id int 
with encryption 
As

SELECT         Question.quest_text,Student_Exam_Question.st_answer 
FROM            Question INNER JOIN
                   Student_Exam_Question ON Question.quest_id = Student_Exam_Question.quest_id
				   where Student_Exam_Question.st_id=@st_id and  Student_Exam_Question.ex_id=@ex_id

GO

------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create proc select_all_Certificate 
WITH ENCRYPTION
As
begin
	select * from  [dbo].[Certification]
		

end
GO

------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create procedure select_all_choise
   WITH ENCRYPTION
	as
	  begin
	  select * from choise
	  end
GO

---------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create PROCEDURE dbo.select_all_Exam		
 WITH ENCRYPTION
AS  
   BEGIN  
     
      SELECT * FROM dbo.Exam
	 
   END
GO

------------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create PROCEDURE dbo.select_all_Instructor
WITH ENCRYPTION
AS  
   BEGIN 
  select * from Instructor
   END
GO

----------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create PROCEDURE dbo.select_all_intake		
 WITH ENCRYPTION
AS  
   BEGIN  
     
      SELECT * FROM dbo.Intake
	 
   END
GO

-----------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create procedure select_all_Questions
WITH ENCRYPTION
AS  
BEGIN  
     SELECT * FROM  Question
	 
END
GO

---------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
 create PROCEDURE dbo.select_all_Register_Instructor		
 WITH ENCRYPTION
AS  
   BEGIN  
     
      SELECT * FROM dbo.Register_Instructor
	 
   END
GO

----------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create PROCEDURE dbo.select_all_Register_Student	
 WITH ENCRYPTION
AS  
   BEGIN  
     
      SELECT * FROM dbo.Register_Instructor
	 
   END
GO

--------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create PROCEDURE dbo.select_all_registration 		
 WITH ENCRYPTION
AS  
   BEGIN  
     
      SELECT * FROM dbo.Registeration
	 
   END
GO

--------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
 create procedure select_all_Student
 WITH ENCRYPTION
AS  
   BEGIN  
     
      SELECT * FROM  Student
	 
   END
GO

------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create PROCEDURE dbo.select_all_Student_Exam
 WITH ENCRYPTION
AS  
   BEGIN  
     
      SELECT * FROM dbo.Student_Exam
	 
   END
GO

---------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create PROCEDURE dbo.select_all_Student_Exam_Question
 WITH ENCRYPTION
AS  
   BEGIN  
     
      SELECT * FROM dbo.Student_Exam_Question
	 
   END
GO

---------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create procedure select_all_tracks

with encryption
as 
begin 

   select * from Track
     
end
GO

---------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create proc select_allFreelancingSkills (@fl_id int
)
WITH ENCRYPTION
as
begin
		if   not exists (select fl_id from Freelancing_Skills where [fl_id]=@fl_id)
			 select 'invalid id'
		else
		 select * from Freelancing_Skills where [fl_id]=@fl_id 
	
end
GO

----------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create proc select_Freelancingforstudent (@st_id int )
WITH ENCRYPTION
	as
	begin
		if   not exists (select * from student where st_id=@st_id)
			 select 'invalid'
		
		else
		select * from Freelancing where st_id=@st_id
		 				
end
GO

--------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create proc select_Hiringforstudent (@st_id int)
WITH ENCRYPTION
as
begin
		if   not exists (select * from Hiring where [st_id]=@st_id )
			 select 'invalid id'
		
		select * from   Hiring where  [st_id]=@st_id 
end
GO

----------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create PROCEDURE dbo.select_intake  @int_id int
  WITH ENCRYPTION
	AS  
	   BEGIN  
		 IF  EXISTS(SELECT int_id FROM dbo.Intake WHERE  int_id=@int_id)
		  SELECT * FROM dbo.Intake WHERE  int_id=@int_id
		 else
			 select 'invalid id'
	   END
GO

---------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create PROCEDURE dbo.select_Register_Instructor @register_id int,@ins_id int 
  WITH ENCRYPTION
	AS  
	   BEGIN  
		 IF  EXISTS(SELECT register_id, ins_id FROM dbo.Register_Instructor WHERE register_id=@register_id and ins_id=@ins_id)
		  SELECT * FROM dbo.Register_Instructor WHERE register_id=@register_id and ins_id=@ins_id
		 else
			 select 'invalid id'
	   END
GO

------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create PROCEDURE dbo.select_Register_Student @register_id int, @st_id  int 
  WITH ENCRYPTION
	AS  
	   BEGIN  
		 IF  EXISTS(SELECT register_id,st_id FROM dbo.Register_Student WHERE register_id=@register_id and  st_id=@st_id )
		  SELECT * FROM dbo.Register_Student WHERE register_id=@register_id and st_id=@st_id
		 else
			 select 'invalid id'
	   END
GO

---------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create  proc select_specific_Certificate ( @cert_id int)
WITH ENCRYPTION
As
begin
	if   exists(select [cert_id] from [dbo].[Certification] where [cert_id]=@cert_id )
		select * from [dbo].[Certification] where[cert_id]=@cert_id
		
	else
		select 'invalid id'
end
GO

-----------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create procedure select_specific_choices 
       @choise_id int
   WITH ENCRYPTION
	as
	  begin
	  if exists(select choise_id from choise where choise_id=@choise_id)
	   select * from choise where choise_id=@choise_id
	  else
        select ('Not Found')
	  end
GO

-----------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
 create PROCEDURE dbo.select_specific_Exam @exam_id int
  WITH ENCRYPTION
	AS  
	   BEGIN  
		 IF  EXISTS(SELECT exam_id FROM dbo.Exam WHERE exam_id=@exam_id)
		  SELECT * FROM dbo.Exam WHERE exam_id=@exam_id
		 else
			 select 'invalid id'
	   END
GO

--------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create PROCEDURE dbo.select_specific_Instructor @ins_id  int
   WITH ENCRYPTION
	AS  
	  BEGIN 
	  IF  EXISTS(SELECT ins_id FROM  dbo.Instructor WHERE ins_id =@ins_id )
		  select * from Instructor WHERE ins_id =@ins_id 
	  else
	   select 'invalid id'
	  END
GO

------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create procedure select_specific_Question
(
@quest_id int
)
with encryption 
as 
begin 
if not exists (select quest_id from Question where quest_id=@quest_id)
   select ' Invalid Id '
else 
select * from Question where quest_id=@quest_id
end
GO

--------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create PROCEDURE dbo.select_specific_registration @register_id int
  WITH ENCRYPTION
	AS  
	   BEGIN  
		 IF  EXISTS(SELECT register_id FROM dbo.Registeration WHERE register_id=@register_id)
		  SELECT * FROM dbo.Registeration WHERE register_id=@register_id
		 else
			 select 'invalid id'
	   END
GO

----------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create procedure select_specific_student
(
@st_id int
)
with encryption 
as 
begin 
if not exists (select st_id from student where st_id=@st_id)
   select ' Invalid Id '
else 
select * from student where st_id=@st_id
end
GO

-----------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create procedure select_specific_Track
 (
 @track_id int
)
with encryption
as 
begin 
 if  exists (select track_id from student where track_id=@track_id)
     select * from Student where track_id=@track_id
else
 select 'invalid Track id'
     
end 
GO

--------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create proc  select_specificCourse (@cr_id int )
WITH ENCRYPTION
as
begin 
	if not exists (select [cr_id] from [dbo].[Course] where  [cr_id] =@cr_id)
		select 'invalid id'
	else
				select * from [Course] where  [cr_id] =@cr_id

          
end
GO

------------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create proc select_SpecificTopic  @topic_id  int 
With encryption
As 
begin

	if  not exists (select topic_id from Topic where  topic_id=@topic_id )
	    select 'invalid id'
	else 
	     select * from  Topic where topic_id =@topic_id
end
GO

------------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create PROCEDURE dbo.select_Student_Exam  @st_id int,@exam_id  int
  WITH ENCRYPTION
	AS  
	   BEGIN  
		 IF  EXISTS(SELECT st_id ,ex_id FROM dbo.Student_Exam WHERE st_id =@st_id and ex_id=@exam_id )
		  SELECT * FROM dbo.Student_Exam WHERE st_id =@st_id and ex_id=@exam_id
		 else
			 select 'invalid id'
	   END
GO

-----------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create PROCEDURE dbo.select_Student_Exam_Question  @st_id int,@exam_id int,@quest_id int
  WITH ENCRYPTION
	AS  
	   BEGIN  
		 IF  EXISTS(SELECT st_id ,ex_id,quest_id FROM dbo.Student_Exam_Question WHERE st_id =@st_id  and ex_id=@exam_id  and quest_id=@quest_id )
		  SELECT * FROM dbo.Student_Exam_Question WHERE st_id =@st_id and ex_id=@exam_id and quest_id=@quest_id
		 else
			 select 'invalid id'
	   END
GO

-----------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create procedure  select_StudentCertification  @st_id int,@cert_id int
WITH ENCRYPTION
As
begin
  if exists( select * from Student_Certification where [cert_id]=@cert_id and [st_id]=@st_id)

	        select * from Student_Certification where [cert_id]=@cert_id and [st_id]=@st_id
 else 
 select 'invalid id'
	
					
end
GO

------------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create proc  selectall_Course 
WITH ENCRYPTION
as
begin 
    select * from [Course]

          
end
GO

--------------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create procedure  selectspecific_Course_Instructor (@cr_id int ,@ins_id int)
 WITH ENCRYPTION
as
begin
    if  exists (select * from Course_Instructor where [cr_id]=@cr_id and  [ins_id]=@ins_id)
	      select * from Course_Instructor where [cr_id]=@cr_id and  [ins_id]=@ins_id
	else  
         select 'invalid id'	
					
 end
GO

----------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create procedure  selectspecific_CourseTopic @cr_id int, @topic_id int
as
begin
    if  exists (select * from Course_Topic where [cr_id]=@cr_id and topic_id=@topic_id) 
	  	        select * from  Course_Topic where [cr_id]=@cr_id and [topic_id]=@topic_id

	else  
	              select 'invalid id'
	
					
 end
GO

-----------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create procedure  selectspecific_courseTrack  @track_id int,@cr_id int
as
begin
  
	if exists (select * from Course_Track where [cr_id]=@cr_id and [track_id]=@track_id)
	        select * from Course_Track where [cr_id]=@cr_id and [track_id]=@track_id
	else
	 select 'invalid id'
					
 end
GO

-----------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create procedure  selectspecific_instructorTrack @ins_id int,@track_id int
as
begin
  
	 if  exists (select * from Instructor_Track where [ins_id]=@ins_id and [track_id]=@track_id) 
	        select * from Instructor_Track where [ins_id]=@ins_id and [track_id]=@track_id
	else
	 select 'invalid id'
					
 end
GO

-------------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create procedure  selectspecific_Studentcourse @st_id int,@cr_id int
as
begin
    if  exists (select * from Student_Course where [cr_id]=@cr_id and [st_id]=@st_id)
	      select * from Student_Course where [cr_id]=@cr_id and [st_id]=@st_id
	else  
         select 'invalid id'	
					
 end
GO

------------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

	CREATE PROCEDURE dbo.sp_alterdiagram
	(
		@diagramname 	sysname,
		@owner_id	int	= null,
		@version 	int,
		@definition 	varbinary(max)
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
	
		declare @theId 			int
		declare @retval 		int
		declare @IsDbo 			int
		
		declare @UIDFound 		int
		declare @DiagId			int
		declare @ShouldChangeUID	int
	
		if(@diagramname is null)
		begin
			RAISERROR ('Invalid ARG', 16, 1)
			return -1
		end
	
		execute as caller;
		select @theId = DATABASE_PRINCIPAL_ID();	 
		select @IsDbo = IS_MEMBER(N'db_owner'); 
		if(@owner_id is null)
			select @owner_id = @theId;
		revert;
	
		select @ShouldChangeUID = 0
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
		
		if(@DiagId IS NULL or (@IsDbo = 0 and @theId <> @UIDFound))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1);
			return -3
		end
	
		if(@IsDbo <> 0)
		begin
			if(@UIDFound is null or USER_NAME(@UIDFound) is null) -- invalid principal_id
			begin
				select @ShouldChangeUID = 1 ;
			end
		end

		-- update dds data			
		update dbo.sysdiagrams set definition = @definition where diagram_id = @DiagId ;

		-- change owner
		if(@ShouldChangeUID = 1)
			update dbo.sysdiagrams set principal_id = @theId where diagram_id = @DiagId ;

		-- update dds version
		if(@version is not null)
			update dbo.sysdiagrams set version = @version where diagram_id = @DiagId ;

		return 0
	END
	
GO

----------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

	CREATE PROCEDURE dbo.sp_creatediagram
	(
		@diagramname 	sysname,
		@owner_id		int	= null, 	
		@version 		int,
		@definition 	varbinary(max)
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
	
		declare @theId int
		declare @retval int
		declare @IsDbo	int
		declare @userName sysname
		if(@version is null or @diagramname is null)
		begin
			RAISERROR (N'E_INVALIDARG', 16, 1);
			return -1
		end
	
		execute as caller;
		select @theId = DATABASE_PRINCIPAL_ID(); 
		select @IsDbo = IS_MEMBER(N'db_owner');
		revert; 
		
		if @owner_id is null
		begin
			select @owner_id = @theId;
		end
		else
		begin
			if @theId <> @owner_id
			begin
				if @IsDbo = 0
				begin
					RAISERROR (N'E_INVALIDARG', 16, 1);
					return -1
				end
				select @theId = @owner_id
			end
		end
		-- next 2 line only for test, will be removed after define name unique
		if EXISTS(select diagram_id from dbo.sysdiagrams where principal_id = @theId and name = @diagramname)
		begin
			RAISERROR ('The name is already used.', 16, 1);
			return -2
		end
	
		insert into dbo.sysdiagrams(name, principal_id , version, definition)
				VALUES(@diagramname, @theId, @version, @definition) ;
		
		select @retval = @@IDENTITY 
		return @retval
	END
	
GO

---------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

	CREATE PROCEDURE dbo.sp_dropdiagram
	(
		@diagramname 	sysname,
		@owner_id	int	= null
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
		declare @theId 			int
		declare @IsDbo 			int
		
		declare @UIDFound 		int
		declare @DiagId			int
	
		if(@diagramname is null)
		begin
			RAISERROR ('Invalid value', 16, 1);
			return -1
		end
	
		EXECUTE AS CALLER;
		select @theId = DATABASE_PRINCIPAL_ID();
		select @IsDbo = IS_MEMBER(N'db_owner'); 
		if(@owner_id is null)
			select @owner_id = @theId;
		REVERT; 
		
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1)
			return -3
		end
	
		delete from dbo.sysdiagrams where diagram_id = @DiagId;
	
		return 0;
	END
	
GO

--------------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

	CREATE PROCEDURE dbo.sp_helpdiagramdefinition
	(
		@diagramname 	sysname,
		@owner_id	int	= null 		
	)
	WITH EXECUTE AS N'dbo'
	AS
	BEGIN
		set nocount on

		declare @theId 		int
		declare @IsDbo 		int
		declare @DiagId		int
		declare @UIDFound	int
	
		if(@diagramname is null)
		begin
			RAISERROR (N'E_INVALIDARG', 16, 1);
			return -1
		end
	
		execute as caller;
		select @theId = DATABASE_PRINCIPAL_ID();
		select @IsDbo = IS_MEMBER(N'db_owner');
		if(@owner_id is null)
			select @owner_id = @theId;
		revert; 
	
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname;
		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId ))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1);
			return -3
		end

		select version, definition FROM dbo.sysdiagrams where diagram_id = @DiagId ; 
		return 0
	END
	
GO

---------------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

	CREATE PROCEDURE dbo.sp_helpdiagrams
	(
		@diagramname sysname = NULL,
		@owner_id int = NULL
	)
	WITH EXECUTE AS N'dbo'
	AS
	BEGIN
		DECLARE @user sysname
		DECLARE @dboLogin bit
		EXECUTE AS CALLER;
			SET @user = USER_NAME();
			SET @dboLogin = CONVERT(bit,IS_MEMBER('db_owner'));
		REVERT;
		SELECT
			[Database] = DB_NAME(),
			[Name] = name,
			[ID] = diagram_id,
			[Owner] = USER_NAME(principal_id),
			[OwnerID] = principal_id
		FROM
			sysdiagrams
		WHERE
			(@dboLogin = 1 OR USER_NAME(principal_id) = @user) AND
			(@diagramname IS NULL OR name = @diagramname) AND
			(@owner_id IS NULL OR principal_id = @owner_id)
		ORDER BY
			4, 5, 1
	END
	
GO

-------------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

	CREATE PROCEDURE dbo.sp_renamediagram
	(
		@diagramname 		sysname,
		@owner_id		int	= null,
		@new_diagramname	sysname
	
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
		declare @theId 			int
		declare @IsDbo 			int
		
		declare @UIDFound 		int
		declare @DiagId			int
		declare @DiagIdTarg		int
		declare @u_name			sysname
		if((@diagramname is null) or (@new_diagramname is null))
		begin
			RAISERROR ('Invalid value', 16, 1);
			return -1
		end
	
		EXECUTE AS CALLER;
		select @theId = DATABASE_PRINCIPAL_ID();
		select @IsDbo = IS_MEMBER(N'db_owner'); 
		if(@owner_id is null)
			select @owner_id = @theId;
		REVERT;
	
		select @u_name = USER_NAME(@owner_id)
	
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1)
			return -3
		end
	
		-- if((@u_name is not null) and (@new_diagramname = @diagramname))	-- nothing will change
		--	return 0;
	
		if(@u_name is null)
			select @DiagIdTarg = diagram_id from dbo.sysdiagrams where principal_id = @theId and name = @new_diagramname
		else
			select @DiagIdTarg = diagram_id from dbo.sysdiagrams where principal_id = @owner_id and name = @new_diagramname
	
		if((@DiagIdTarg is not null) and  @DiagId <> @DiagIdTarg)
		begin
			RAISERROR ('The name is already used.', 16, 1);
			return -2
		end		
	
		if(@u_name is null)
			update dbo.sysdiagrams set [name] = @new_diagramname, principal_id = @theId where diagram_id = @DiagId
		else
			update dbo.sysdiagrams set [name] = @new_diagramname where diagram_id = @DiagId
		return 0
	END
	
GO

-----------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

	CREATE PROCEDURE dbo.sp_upgraddiagrams
	AS
	BEGIN
		IF OBJECT_ID(N'dbo.sysdiagrams') IS NOT NULL
			return 0;
	
		CREATE TABLE dbo.sysdiagrams
		(
			name sysname NOT NULL,
			principal_id int NOT NULL,	-- we may change it to varbinary(85)
			diagram_id int PRIMARY KEY IDENTITY,
			version int,
	
			definition varbinary(max)
			CONSTRAINT UK_principal_name UNIQUE
			(
				principal_id,
				name
			)
		);


		/* Add this if we need to have some form of extended properties for diagrams */
		/*
		IF OBJECT_ID(N'dbo.sysdiagram_properties') IS NULL
		BEGIN
			CREATE TABLE dbo.sysdiagram_properties
			(
				diagram_id int,
				name sysname,
				value varbinary(max) NOT NULL
			)
		END
		*/

		IF OBJECT_ID(N'dbo.dtproperties') IS NOT NULL
		begin
			insert into dbo.sysdiagrams
			(
				[name],
				[principal_id],
				[version],
				[definition]
			)
			select	 
				convert(sysname, dgnm.[uvalue]),
				DATABASE_PRINCIPAL_ID(N'dbo'),			-- will change to the sid of sa
				0,							-- zero for old format, dgdef.[version],
				dgdef.[lvalue]
			from dbo.[dtproperties] dgnm
				inner join dbo.[dtproperties] dggd on dggd.[property] = 'DtgSchemaGUID' and dggd.[objectid] = dgnm.[objectid]	
				inner join dbo.[dtproperties] dgdef on dgdef.[property] = 'DtgSchemaDATA' and dgdef.[objectid] = dgnm.[objectid]
				
			where dgnm.[property] = 'DtgSchemaNAME' and dggd.[uvalue] like N'_EA3E6268-D998-11CE-9454-00AA00A3F36E_' 
			return 2;
		end
		return 1;
	END
	
GO

----------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create proc stud_grades  @stud_id int 
with encryption
As
select  cr_name As [course name], grade  
from Student_Course AS S inner join Course As C
on S.cr_id=C.cr_id and st_id=@stud_id

GO

----------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create Proc stud_info  @track_id int 
with encryption
as

	select st_id As [Student id] ,st_ssn As [Snn] ,st_fname AS [first name], st_lname As [last name],
	st_gender AS [Gender],st_birthdate AS [Birthdate],st_city As [city] , track_name
	from Student AS S inner join Track AS T
	ON T.track_id=S.track_id  and  T.track_id=@track_id
	
	

GO

---------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create proc  topics  @cr_id int 
with encryption
AS
SELECT Topic.topic_name
FROM  Course_Topic INNER JOIN
Topic ON Course_Topic.topic_id = Topic.topic_id and  Course_Topic.cr_id= @cr_id

GO

---------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create proc updata_Certificate(@cert_id int, @cert_title nvarchar(100), @cert_website nvarchar(50),@cert_startdate  date,@cert_enddate date,@cert_hours int)
WITH ENCRYPTION
As
begin
	if  exists(select [cert_id] from [dbo].[Certification] where [cert_id]=@cert_id )
		update  [dbo].[Certification]
		set  [cert_title]=@cert_title,[cert_website]=@cert_website,[cert_startdate]=@cert_startdate,[cert_enddate]=@cert_enddate,cert_hours=@cert_hours 
		where [cert_id]=@cert_id
	else
		select 'invalid id'
		
end
GO

------------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create procedure update_Choise
 @choise_id int ,
 @choise_text varchar(30),
 @quest_id int
 WITH ENCRYPTION
 as
 begin
 if not exists(select quest_id from	Question where quest_id=@quest_id )
      select'Question not exist'
else if exists(select quest_id from Choise where quest_id=@quest_id)
  select'dublicated pk'
 update Choise
 set choise_id=@choise_id,
  choise_text= @choise_text,quest_id=@quest_id
  where choise_id=@choise_id
 end
GO

-------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create proc  update_Course (@cr_id int ,@cr_name nvarchar(100),@cr_hours_duration int ,@cr_days_duration int)
WITH ENCRYPTION
as
begin 
	if not exists (select [cr_id] from [dbo].[Course] where  [cr_id] =@cr_id)
		select 'course not exist'
	else
				update [dbo].[Course] 
				set [cr_name]=@cr_name,[cr_hours_duration]=@cr_hours_duration,[cr_days_duration]=@cr_days_duration
				where [cr_id] =@cr_id

          
end
GO

---------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create procedure  update_Course_Topic  @cr_id int,@topic_id int
as
begin
   if not exists (select * from Topic where topic_id=@topic_id) and not exists (select * from Course where [cr_id]=@cr_id)
		select 'Course and topic not Exist'
   else if not exists (select * from Course where [cr_id]=@cr_id)
	      select 'course not Exist'	 
							  
   else if not exists (select * from Topic where topic_id=@topic_id)
			    select 'topic  not Exist'
   else if not exists (select * from Course_Topic where [cr_id]=@cr_id and topic_id=@topic_id) 
                 select 'invalid id'
	else
					update Course_Topic 
					set [cr_id]= @cr_id,[topic_id]=@topic_id
					 

 end
GO

-----------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create procedure  update_CourseInstructor (@cr_id int ,@ins_id int)
WITH ENCRYPTION
As
begin
  if not exists (select * from Instructor where [ins_id]=@ins_id) and not exists (select * from Course where [cr_id]=@cr_id)
		select 'Instructor and Course not Exist'
   else if not exists (select * from Course where [cr_id]=@cr_id)
	      select 'Course not Exist'	 
							  
   else if not exists  (select * from Instructor where [ins_id]=@ins_id)
			    select 'Instructor not Exist'
   else if not exists (select * from Course_Instructor where [cr_id]=@cr_id and  [ins_id]=@ins_id) 
                 select 'invalid id'
 
					 

 end
GO

--------------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create procedure update_courseTrack(@cr_id int ,@track_id int)
WITH ENCRYPTION
As
begin
   if not exists (select * from Track where [track_id]=@track_id) and not exists (select * from Course where [cr_id]=@cr_id)
		select 'student and track not Exist'
	else if not exists (select * from Track where [track_id]=@track_id)
			select 'Track not Exist'	 
							  
	else if not exists (select * from Course where [cr_id]=@cr_id)
				select 'Course  not Exist'
	else if not exists (select * from Course_Track where [cr_id]=@cr_id and [track_id]=@track_id) 
					select 'invalid id'
	

 end
GO

-----------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create PROCEDURE dbo.update_Exam
      @exam_id INT,@exam_title NVARCHAR(50),
				@exam_startdate date,
				@exam_enddate date,@exam_fullmark int,
				@cr_id int,@questions_numbers int
WITH ENCRYPTION
AS  
   BEGIN  
      IF  EXISTS(SELECT exam_id FROM dbo.Exam WHERE exam_id=@exam_id)
		  UPDATE dbo.Exam
		  SET
		  exam_id=@exam_id,
		  exam_title=@exam_title ,
		  exam_startdate=@exam_startdate,
		   exam_enddate=@exam_enddate,
		   exam_fullmark=@exam_fullmark,
		   cr_id=@cr_id,
		   questions_numbers=@questions_numbers
		   WHERE exam_id=@exam_id
	else
	select 'invalid id'
   END
GO

---------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create proc update_Freelancing (@fl_id int,@job_name nvarchar(50),@fl_website nvarchar(50),@fl_date date,@st_id int)
 WITH ENCRYPTION
	as
	begin
		if   not exists (select * from Freelancing where [fl_id]=@fl_id )
			 select 'invalid'
		else if not exists (select st_id from Student where st_id=@st_id) 
			 select 'student not exist'	
		else
		 update Freelancing 
		 set  job_name=@job_name,fl_website=@fl_website,fl_date=@fl_date,st_id=@st_id
		 where fl_id=@fl_id
					
end
GO

---------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create proc update_FreelancingSkills (@fl_id int,@tool nvarchar(50))
 WITH ENCRYPTION
as
begin
	   if   not exists (select fl_id from Freelancing where [fl_id]=@fl_id   )
			 select 'invlaid id'
		else if  not exists (select fl_id from Freelancing_Skills where [fl_id]=@fl_id and  [skills]=@tool )
		     select 'invalid tool'
		else 
		 update Freelancing_Skills set skills=@tool
		 where [fl_id]=@fl_id and  skills=@tool
end
GO

----------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
 create proc update_Hiring (@hiring_id int,@position nvarchar(100),@job_type nvarchar(20),@job_location nvarchar(20),@hiring_date date
                                 ,@company nvarchar(50),@st_id int)
 WITH ENCRYPTION
	as
	begin
		if   not exists (select * from Hiring where [hiring_id]=@hiring_id )
			 select 'invalid id'
		else if not exists (select st_id from Student where st_id=@st_id) 
			 select 'student not exist'	
		else
		update Hiring  set job_title=@position ,job_type=@job_type,job_location=@job_location,hiring_date=@hiring_date ,company_name=@company,st_id=@st_id
		  where   hiring_id=@hiring_id
					
end
GO

-----------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create procedure update_Instructor
    @ins_id INT,@ins_ssn nvarchar(50),
		  @ins_fname nvarchar(50),
				@ins_lname nvarchar(50),
				@ins_gender nvarchar(10),@ins_birthdate date,@ins_salary float,
				@ins_city nvarchar(50)
				
WITH ENCRYPTION
AS  
   BEGIN 
      IF  EXISTS(SELECT ins_id FROM  dbo.Instructor WHERE ins_id=@ins_id)

		  UPDATE dbo.Instructor
		  SET
		   ins_id= @ins_id,
		   ins_ssn=@ins_ssn,
					ins_fname=@ins_fname ,
					ins_lname=@ins_lname,
					ins_birthdate=@ins_birthdate ,ins_gender =@ins_gender ,ins_city=@ins_city
				     ,ins_salary=@ins_salary 
		   WHERE  ins_id = @ins_id 
	else
	select 'invalid id'
   END
GO

-----------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create procedure update_instructorTrack(@ins_id int ,@track_id int)
WITH ENCRYPTION
As
begin
   if not exists (select * from Track where [track_id]=@track_id) and not exists (select * from instructor where [ins_id]=@ins_id)
		select 'instructor and track not Exist'
	else if not exists (select * from Track where [track_id]=@track_id)
			select 'Track not Exist'	 
							  
	else if not exists (select * from instructor where [ins_id]=@ins_id)
				select 'instructor not Exist'
	else if  exists (select * from Instructor_Track where [ins_id]=@ins_id and [track_id]=@track_id) 
					select 'existed id'
	else	
					update Instructor_Track
					set ins_id= @ins_id,[track_id]=@track_id
					where [ins_id]=@ins_id and  [track_id]=@track_id
					 

 end
GO

-----------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create PROCEDURE dbo.update_intake 
      @int_id int,@int_startdate date,@int_enddate date,
	  @expected_startdate date,@expected_enddate date
WITH ENCRYPTION
AS  
   BEGIN  
      IF  EXISTS(SELECT int_id FROM dbo.Intake WHERE int_id=@int_id)
		  UPDATE dbo.Intake
		  SET
		 int_id=@int_id,
       int_startdate=@int_startdate,
        int_enddate=@int_enddate,
        expected_startdate=@expected_startdate,
        expected_enddate=@expected_enddate
		   WHERE int_id=@int_id
	else
	select 'invalid id'
   END
GO

--------------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create procedure update_question
(
@quest_id int,
@quest_type nvarchar(20),
@quest_text nchar(500),
@quest_answer nchar(500),
@cr_id int,
@quest_level nchar(1)
)
with encryption 
as 
begin 
if  exists (select quest_id from Question where quest_id=@quest_id)
  select'Duplicate id'
else
if not exists (select cr_id from Course where cr_id=@cr_id )
  select 'Invalid Id'
else 
update Question set  quest_id=@quest_id ,quest_type=@quest_type ,quest_text=@quest_text ,quest_answer=@quest_answer ,cr_id=@cr_id ,quest_level=@quest_level
end 
GO

---------------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create PROCEDURE dbo.update_Register_Instructor
     @ins_id int,@register_id int,@ins_register_insertion_date date
 WITH ENCRYPTION
 as
 begin
 if not exists(select * from Instructor where ins_id= @ins_id)and not exists(select * from Registeration where register_id=@register_id )
            select'instructor and Registeration not exist'
else if not exists(select * from Instructor where ins_id=@ins_id)
       select'Instructor not exist'
else if not exists(select * from Registeration where register_id=@register_id)
       select'Registeration not exist'
else if exists(select * from Register_Instructor where ins_id=@ins_id and register_id=@register_id)
  select'dublicated pk'
else
		  UPDATE dbo.Register_Instructor
		  SET
		  ins_id=@ins_id,register_id=@register_id,
		  ins_register_insertion_date=@ins_register_insertion_date
		   WHERE register_id=@register_id and ins_id=@ins_id
   END
GO

--------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create PROCEDURE dbo.update_Register_Student
    @st_id int,@register_id int,@st_register_insertion_date date
 WITH ENCRYPTION
 as
 begin
 if not exists(select * from Student where st_id= @st_id)and not exists(select * from Registeration where register_id=@register_id )
            select'student and Registeration not exist'
else if not exists(select * from Student where st_id=@st_id)
       select'Student not exist'
else if not exists(select * from Registeration where register_id=@register_id)
       select'Registeration not exist'
else if exists(select * from Register_Student where st_id=@st_id and register_id=@register_id)
  select'dublicated pk'
  else 
		  UPDATE dbo.Register_Student
		  SET
		  st_id=@st_id,register_id=@register_id,
		  st_register_insertion_date=@st_register_insertion_date
		   WHERE register_id=@register_id and st_id=@st_id
   END
GO

--------------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create PROCEDURE dbo.update_registration 
     @register_id INT,@email NVARCHAR(50),
				@username nvarchar(50),
				@password  nvarchar(50),
				@usertype nvarchar(20)
WITH ENCRYPTION
AS  
   BEGIN  
      IF  EXISTS(SELECT register_id FROM dbo.Registeration WHERE register_id=@register_id)
		  UPDATE dbo.Registeration
		  SET
		  register_id=@register_id,
		  email=@email ,
		   username=@username,
		   password=@password,
		   usertype=@usertype 
		   WHERE register_id=@register_id 
	else
	select 'invalid id'
   END
GO

-------------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create procedure update_student
(
@st_id int,
@st_ssn nvarchar(50),
@st_birthdate date,
@st_city nvarchar(50),
@st_fname nvarchar(50),
@st_lname nvarchar(50),
@st_gender nvarchar(10),
@track_id int,
@int_id int
)
with encryption 
as 
begin 
if exists ( select st_id from student where st_id=@st_id )
    select 'Duplicated ID , Insert another one'
else 
if not exists (select track_id  from Track where track_id = @track_id and not exists (select int_id from Intake where int_id = @int_id))
    select 'Invalid Instructor Id and Track Id'
if not exists (select int_id  from Intake where int_id= @int_id)
     select 'Invalid Instructor Id'
iF not exists (select track_id from track where track_id = @track_id)
      select 'Invalid Track Id'

else 
update Student set  st_id =@st_id ,st_ssn=@st_ssn, st_birthdate=@st_birthdate,st_city=@st_city, st_fname=@st_fname, st_lname=@st_lname, st_gender= @st_gender,
int_id =@int_id , track_id = @track_id
end
GO

---------------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create PROCEDURE dbo.update_Student_Exam
   @st_id int,@exam_id int,@solved_questions int,@st_ex_starttime datetime,@st_ex_endtime datetime
 WITH ENCRYPTION
 as
 begin
 if not exists(select st_id from Student where st_id= @st_id)and not exists(select exam_id from Exam where exam_id=@exam_id )
            select'Student and Exam not exist'
else if not exists(select st_id from Student where st_id= @st_id)
       select'Intake not Student'
else if not exists(select exam_id from Exam where exam_id=@exam_id)
       select'Exam not exist'
else if exists(select st_id,ex_id from Student_Exam where st_id=@st_id and ex_id =@exam_id )
  select'dublicated pk'
else 
		  UPDATE dbo.Student_Exam
		  SET
		  st_id=@st_id,ex_id =@exam_id ,solved_questions=@solved_questions,st_ex_starttime=@st_ex_starttime,st_ex_endtime=@st_ex_endtime
		   WHERE  st_id =@st_id and ex_id =@exam_id 
   END
GO

----------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create PROCEDURE dbo.update_Student_Exam_Question
  @ex_id int,@st_id int,@quest_id int,@st_answer nvarchar(MAX),@quest_grade int
 WITH ENCRYPTION
 as
 begin
 if not exists(select st_id from Student where st_id= @st_id)and not exists(select exam_id from Exam where exam_id=@ex_id )
 and not exists(select quest_id from Question where quest_id=@quest_id )
      select'Student, Exam and Question not exist'
else if not exists(select st_id from Student where st_id= @st_id)
       select'Intake not Student'
else if not exists(select exam_id from Exam where exam_id=@ex_id)
       select'Exam not exist'
else if	 not exists(select quest_id from Question where quest_id=@quest_id )
 select'Question not exist'
else if exists(select st_id,ex_id,quest_id from Student_Exam_Question where st_id=@st_id and ex_id =@ex_id and quest_id=@quest_id)
  select'dublicated pk'
else 
		  UPDATE dbo.Student_Exam_Question
		  SET
		  st_id=@st_id,ex_id=@ex_id,quest_id=@quest_id,st_answer=@st_answer,quest_grade=@quest_grade
		   WHERE  st_id =@st_id and ex_id =@ex_id 
   END
GO

-------------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create procedure  update_StudentCertification  @st_id int,@cert_id int
WITH ENCRYPTION
As
begin
    if not exists (select * from Student where [st_id]=@st_id) and not exists (select * from Certification where [cert_id]=@cert_id)
		select 'student and Certification  not Exist'
   
    else  if not exists (select * from Certification where [cert_id]=@cert_id)
	      select 'Certification not Exist'	 
							  
	else if not exists (select * from Student where [st_id]=@st_id)
			    select 'student  not Exist'
	else if  exists (select * from Student_Certification where [cert_id]=@cert_id and [st_id]=@st_id) 
                 select 'existed  id'
	else
					update Student_Certification set st_id =@st_id,[cert_id]=@cert_id
					where st_id =@st_id and [cert_id]=@cert_id
					 

end
GO

-------------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create procedure  update_Studentcourse (@cr_id int ,@st_id int,@grade int ,@cr_rate int,@ins_rate int) 
WITH ENCRYPTION
As
begin
   if  not exists (select * from Course where [cr_id]=@cr_id) AND NOT EXISTS (select * from Student where [st_id]=@st_id)
	      select 'student and Course not Exist'	 
   else if not exists (select * from Course where [cr_id]=@cr_id)
	      select 'course not Exist'	 
							  
	else if not exists (select * from Student where [st_id]=@st_id)
			    select 'student  not Exist'
	else if not  exists (select * from Student_Course where [cr_id]=@cr_id and [st_id]=@st_id) 
                 select 'invalid  id'
	else
					update Student_Course 
					set grade=@grade ,cr_rate=@cr_rate,ins_rate=@ins_rate
					where [cr_id]=@cr_id and  [st_id]=@st_id
					 

 end
GO

-----------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create proc update_topic  @topic_id  int ,@topic_name nvarchar(50)
With encryption
As 
begin

if  not exists (select topic_id from Topic where  topic_id=@topic_id )
    select 'invalid id'
else 
    update  Topic  set topic_id=@topic_id ,topic_name=@topic_name
	where topic_id=@topic_id 
end
GO

---------------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create procedure update_track
 (
@track_id int,
@track_name nvarchar(100),
@supervisor_id int 
)
with encryption 
as 
begin 
if not exists (select track_id from Track where track_id=@track_id)
       select 'invalid id ,input another one'
else
 update Track set track_id=@track_id, track_name=@track_name,supervisor_id=@supervisor_id
 end
GO

-----------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create proc delete_Certificate ( @cert_id int )
WITH ENCRYPTION
As
begin
	if  exists(select [cert_id] from [dbo].[Certification] where [cert_id]=@cert_id )
		delete from [dbo].[Certification]
		where [cert_id]=@cert_id
	else
		select 'invalid id'
end
GO

---------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create procedure delete_Choise
@choise_id  int
WITH ENCRYPTION
as
begin
if exists(select choise_id from Choise where choise_id=@choise_id)
  delete from choise where choise_id=@choise_id
else
  select ('Not Found')
end
GO

---------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create proc  delete_Course (@cr_id int )
WITH ENCRYPTION
as
begin 
	if   not exists (select [cr_id] from [dbo].[Course] where  [cr_id] =@cr_id)
		select 'course not exist'
	else if   exists( select [cr_id]  from Student_Course  where [cr_id]=@cr_id)
	   select 'cannot delete this course,relate to another Student'
	else if   exists (select [cr_id]  from Course_Instructor  where [cr_id]=@cr_id)
	   select 'cannot delete this course,relate to another Instructor'
	else if  exists(select [cr_id]  from Question where [cr_id]=@cr_id)
	   select 'cannot delete this course,REMOVE related questions first'
	else if  exists(select [cr_id]  from Course_Topic  where [cr_id]=@cr_id)
	   select 'cannot delete this course,relate to another Topic'
	else if exists(select [cr_id]  from Course_Track  where [cr_id]=@cr_id)
	    select 'cannot delete this course,relate to another Track'
	else
		delete from [dbo].[Course] where [cr_id] =@cr_id
			         
end
GO

-------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create procedure  delete_Course_Topic  @cr_id int,@topic_id int
as
begin
  
   if  exists (select * from Course_Topic where [cr_id]=@cr_id and topic_id=@topic_id) 
                delete from Course_Topic where [cr_id]=@cr_id and [topic_id]=@topic_id
  else 
           select 'invalid id'
	
					
 end
GO

------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create procedure  delete_CourseInstructor (@cr_id int ,@ins_id int)
WITH ENCRYPTION
As
begin
   if  exists (select * from Course_Instructor where [cr_id]=@cr_id and  [ins_id]=@ins_id)
                   delete from Course_Instructor where [cr_id]=@cr_id and  [ins_id]=@ins_id	 
   else  
         select 'invalid id'    
	
					
 end
GO

-----------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create procedure  delete_courseTrack  @track_id int,@cr_id int
WITH ENCRYPTION
As
begin
  
  if not exists (select * from Course_Track where [cr_id]=@cr_id and [track_id]=@track_id) 
                delete from Course_Track where [cr_id]=@cr_id and [track_id]=@track_id
 else
     select 'invalid id'
	
					
 end
GO

-----------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create PROCEDURE dbo.delete_Exam
         @exam_id INT
 WITH ENCRYPTION  
AS  
   BEGIN 
  if  exists(select ex_id from Student_Exam where ex_id= @exam_id)
	 select 'cannot delete this registeration, related to Student'
  else if exists(select ex_id from Student_Exam_Question where ex_id=@exam_id )
	 select 'cannot delete this registeration,related to Question'
  else IF not EXISTS(SELECT exam_id FROM dbo.Exam WHERE exam_id=@exam_id)
        select 'invalid id'
   else
   delete from Exam where exam_id=@exam_id
   END
GO

---------------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create proc delete_Freelancing (@fl_id int)
WITH ENCRYPTION
as
begin
		if  not exists (select * from Freelancing where [fl_id]=@fl_id )
			 select 'invalid'
		
		else
		delete from Freelancing  where fl_id=@fl_id
		 				
end
GO

-----------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create proc delete_FreelancingSkills (@fl_id int,@tool nvarchar(50))
WITH ENCRYPTION
as
begin
		if   not exists (select fl_id from Freelancing_Skills where [fl_id]=@fl_id and skills=@tool  )
			 select 'invalid id'
		else
		 delete from Freelancing_Skills
		 where  fl_id=@fl_id  and skills=@tool
	
end
GO

------------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create proc delete_Hiring (@hiring_id int)
WITH ENCRYPTION
as
begin
		if   not exists (select * from Hiring where [hiring_id]=@hiring_id )
			 select 'duplicated id'
		
		delete  Hiring where  [hiring_id]=@hiring_id
end
GO

-------------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create PROCEDURE dbo.delete_Instructor
    @ins_id  INT
WITH ENCRYPTION
AS  
   BEGIN  
    if exists(select ins_id from Register_Instructor where ins_id= @ins_id)
	 select 'cannot delete this instructor related to register'
	 else if exists(select supervisor_id from Track where supervisor_id=@ins_id )
	 select 'cannot delete this instructor related to track'
	 else if exists(select ins_id from Course_Instructor where ins_id=@ins_id )
	 select 'cannot delete this instructor related to course'
	 else if not EXISTS(SELECT ins_id  FROM  dbo.Instructor WHERE ins_id =@ins_id )
        select 'invalid id'
	 else
	   delete from Instructor where ins_id =@ins_id 
   END
GO

--------------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create procedure  delete_instructorTrack (@ins_id int ,@track_id int)
WITH ENCRYPTION
As
begin
  
	if  exists (select * from Instructor_Track where [ins_id]=@ins_id and [track_id]=@track_id) 
                delete from Instructor_Track where [ins_id]=@ins_id and [track_id]=@track_id
 else
     select 'invalid id'
	
					
 end
GO

---------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create PROCEDURE dbo.delete_Intake 
         @int_id INT
 WITH ENCRYPTION  
AS  
   BEGIN 
  if exists(select int_id from Student where int_id=@int_id )
	 select 'cannot delete this intake,relate to another student'
  else if
     not EXISTS(SELECT int_id FROM  dbo.Intake WHERE int_id =@int_id )
     select'Invalid ID'
	 else
	   delete from Intake  where int_id=@int_id
	   END
GO

-----------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create procedure delete_question 
(
@quest_id int
)
with encryption 
as 
begin
if not exists (select quest_id from Question WHERE quest_id=@quest_id)
   SELECT 'Invalid Id , Insert another one'
else 
if exists (select quest_id from Choise where quest_id=@quest_id)
  select ' cannot Remove this question ,it  was related to another object'
else 
if exists (select quest_id from Student_Exam_Question where quest_id=@quest_id)
   select ' cannot Remove this question ,it  was related to Exams'
else 
delete quest_id from Question where quest_id=@quest_id
end 
GO

-------------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create PROCEDURE dbo.delete_Register_Instructor
         @ins_id int,@register_id int
 WITH ENCRYPTION  
AS  
   BEGIN  
       IF  EXISTS(SELECT register_id,ins_id  FROM dbo.Register_Instructor WHERE register_id=@register_id and ins_id =@ins_id )
         delete from Register_Instructor where register_id=@register_id and ins_id =@ins_id 
	  else
		 select 'invalid id'
   END
GO

--------------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
  create PROCEDURE dbo.delete_Register_Student
           @st_id int,@register_id int
 WITH ENCRYPTION  
AS  
   BEGIN  
       IF  EXISTS(SELECT register_id,st_id  FROM dbo.Register_Student WHERE register_id=@register_id and st_id=@st_id )
         delete from Register_Student where register_id=@register_id and st_id  =@st_id  
	  else
		 select 'invalid id'
   END
GO

--------------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create PROCEDURE dbo.delete_registration 
         @register_id INT
 WITH ENCRYPTION  
AS  
   BEGIN 
  if  exists(select register_id from Register_Instructor where register_id= @register_id)
	 select 'cannot delete this registeration, related to instructor'
  else if exists(select register_id from Register_Student where register_id=@register_id )
	 select 'cannot delete this registeration,related to student'
  else IF not EXISTS(SELECT register_id FROM dbo.Registeration WHERE register_id=@register_id)
        select 'invalid id'
   else
   delete from Registeration where register_id=@register_id
   END
GO

------------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create procedure delete_student
(
@st_id int
)
with encryption 
as 
begin 
if not exists (select st_id from Student where st_id=@st_id)
    select 'Invalid Id insert another one'
else
if exists (select  st_id from Student_Course where st_id=@st_id)
   select 'cannot remove this student , he enrolled courses'
else
if exists (select st_id from Student_Exam where st_id=@st_id)
 select 'cannot remove this student , he is already doing exams'
else
if exists (select st_id from Student_Exam_Question where st_id=@st_id)
  select 'cannot remove this student ,he related to another objects'
else
if exists (select st_id from Student_Certification where st_id=@st_id)
  select 'cannot  remove this student,he done certifications'
else 
if exists(select st_id from Register_Student where st_id=@st_id)
  select 'cannot  remove this student,he already registerd'
if exists (select st_id from Freelancing where st_id=@st_id)
    select 'cannot remove this student ,he has done freelance job'
else
if exists (select st_id from Hiring where st_id=@st_id)
    select 'cannot remove this student ,he has been hired a position' 
else
if exists (select st_id from Social_Media where st_id=@st_id)
    select 'cannot remove this student , he related to another object' 

else 
	delete st_id from student where st_id=@st_id
end
GO

-------------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create PROCEDURE dbo.delete_Student_Exam
           @st_id int,@exam_id int
 WITH ENCRYPTION  
AS  
   BEGIN  
       IF  EXISTS(SELECT st_id,ex_id  FROM dbo.Student_Exam WHERE st_id=@st_id and ex_id=@exam_id)
         delete from Student_Exam where st_id =@st_id  and ex_id=@exam_id
	  else
		 select 'invalid id'
   END
GO

-----------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create PROCEDURE dbo.delete_Student_Exam_Question
           @st_id int,@exam_id int,@quest_id int
 WITH ENCRYPTION  
AS  
   BEGIN  
       IF  EXISTS(SELECT st_id,ex_id,quest_id  FROM dbo.Student_Exam_Question WHERE st_id=@st_id and ex_id=@exam_id and quest_id=@quest_id)
         delete from Student_Exam_Question where st_id =@st_id  and ex_id=@exam_id and quest_id=@quest_id
	  else
		 select 'invalid id'
   END
GO

-----------------------------------------

USE [Examination System]
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create procedure  delete_StudentCertification  @st_id int,@cert_id int
WITH ENCRYPTION
As
begin

   if not exists (select * from Student where [st_id]=@st_id) and not exists (select * from Certification where [cert_id]=@cert_id)
		select 'student and Certification not Exist'
   else if not exists (select * from Certification where [cert_id]=@cert_id)
	      select 'Certification not Exist'	 
							  
	else if not exists (select * from Student where [st_id]=@st_id)
			    select 'student  not Exist'
	else if  exists (select * from Student_Certification where [cert_id]=@cert_id and [st_id]=@st_id) 
                delete from [Student_Certification] where [cert_id]=@cert_id and [st_id]=@st_id
	
					
end
GO

------------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create procedure  delete_Studentcourse  @st_id int,@cr_id int
WITH ENCRYPTION
As
begin
   if  exists (select * from Student_Course where [cr_id]=@cr_id and [st_id]=@st_id)
                   delete from Student_Course where [cr_id]=@cr_id and [st_id]=@st_id	 
   else  
         select 'invalid id'    
	
					
 end
GO

-----------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create proc delete_topic  @topic_id  int
With encryption
As 
begin

	if  not exists (select topic_id from Topic where  topic_id=@topic_id )
	       select 'invalid id'
	else 
	       delete Topic where topic_id =@topic_id
end
GO

----------------------------------------

GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
create procedure delete_track
(
 @track_id  int
)
with encryption 
as 
begin 
if not exists (select track_id from track where track_id=@track_id)
select 'Invalid ID'
else 
if exists(select track_id from Course_Track where track_id=@track_id)
  select 'cannot remove this track it is related to another courses'
else
 if exists (select track_id from Student where track_id=@track_id)
    select 'Cannot remove this track it has Students'

else 
    delete track_id from track where track_id=@track_id

end 
GO

------------------------------------------


