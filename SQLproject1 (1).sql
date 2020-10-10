CREATE DATABASE Grades
use Grades
CREATE TABLE Student
(
StudentID INT IDENTITY(1, 1),
StudentName CHAR(50) NOT NULL,
PRIMARY KEY (StudentID)
);


CREATE TABLE Course
(
CourseID INT IDENTITY(1, 1),
Title CHAR(50) NOT NULL,
Credit INT CHECK (Credit in (15,30)) NOT NULL,
Quota INT NOT NULL,
PRIMARY KEY (CourseID)
);

CREATE TABLE StudentCourse
(
StudentID INT REFERENCES Student(StudentID) NOT NULL, 
CourseID INT REFERENCES Course(CourseID) NOT NULL, 
registrationDate Date NOT NULL,
PRIMARY KEY (StudentID, CourseID),
FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
FOREIGN KEY (CourseID) REFERENCES Course(CourseID));

CREATE FUNCTION check_volume()
RETURNS INT
AS
BEGIN
DECLARE @ret int
IF EXISTS(SELECT sum(credit) 
FROM Course c JOIN StudentCourse sc ON c.CourseID=sc.CourseID
GROUP BY sc.StudentID
HAVING SUM(Credit) > 180) 
SELECT @ret =1 ELSE SELECT @ret = 0;
RETURN @ret;
END;


ALTER TABLE StudentCourse
ADD CONSTRAINT square_volume CHECK(dbo.check_volume() = 0);

CREATE FUNCTION check_volume2()
RETURNS INT
AS
BEGIN
DECLARE @ret int
IF EXISTS(SELECT c.CourseID, avg(c.Quota) - count(c.CourseID)
FROM Course c JOIN StudentCourse sc ON c.CourseID=sc.CourseID
GROUP BY c.CourseID   
HAVING count(c.Quota)-avg(c.CourseID) < 0)
SELECT @ret = 1 ELSE SELECT @ret = 0;
RETURN @ret;
END;

select * from Course
select * from StudentCourse 
SELECT c.CourseID, avg(c.Quota) - count(c.CourseID)
FROM Course c JOIN StudentCourse sc ON c.CourseID=sc.CourseID
GROUP BY c.CourseID 

ALTER TABLE StudentCourse
ADD CONSTRAINT square_volume2 CHECK(dbo.check_volume2() = 0);

------------------------------
SELECT *
FROM Course c INNER JOIN StudentCourse sc ON c.CourseID=sc.CourseID
INNER JOIN Assignment a on 


select * from Assignment

SELECT * FROM StudentCourse

GROUP BY c.CourseID   




------------------------------------



INSERT INTO Course (Title, Credit, Quota)
VALUES('mat', 30, 3),
('python', 30, 2),
('a', 30, 2),
('b', 30, 2),
('c', 30, 2),
('d', 30, 2),
('e', 30, 2),
('q', 15, 2),
('x',15,3)

INSERT INTO Course (Title, Credit, Quota)
VALUES
('f', 30, 2),
('g', 30, 2),
('h', 30, 2),
('j', 15, 2),
('k', 15, 2)




select * from Course

INSERT INTO Student ([StudentName])
VALUES('Ali'),
('Osman'),
('Ömer'),
('Bekir'),
('Ahmet'),
('Mehmet'),
('Ayþe')

INSERT INTO Student ([StudentName])
VALUES('Ali2'),
('Osman2'),
('Ömer2'),
('Bekir2'),
('Ahmet2')

select * from StudentCourse

INSERT INTO StudentCourse (StudentID, CourseID, registrationDate)
VALUES(1, 1, '2020-05-12'),
(1, 2, '2020-05-12'),
(1, 3, '2020-05-12'),
(1, 4, '2020-05-12'),
(1, 5, '2020-05-12'),
(1, 6, '2020-05-12')

INSERT INTO StudentCourse (StudentID, CourseID, registrationDate)
VALUES(2, 1, '2020-05-12'),
(2, 2, '2020-05-12')

INSERT INTO StudentCourse (StudentID, CourseID, registrationDate)
VALUES(3, 1, '2020-05-12'),
(2, 3, '2020-05-12'),
(2, 4, '2020-05-12')

INSERT INTO StudentCourse (StudentID, CourseID, registrationDate)
VALUES(3, 3, '2020-05-12')

INSERT INTO StudentCourse (StudentID, CourseID, registrationDate)
VALUES(2, 8, '2020-05-12')

INSERT INTO StudentCourse (StudentID, CourseID, registrationDate)
VALUES(7, 12, '2020-05-12')



select * from StudentCourse

CREATE TABLE Assignment
(
StudentID INT REFERENCES Student(StudentID) NOT NULL, 
CourseID INT REFERENCES Course(CourseID) NOT NULL, 
AssignmentID INT NOT NULL,
Note INT Check(Note <=100) NOT NULL,
PRIMARY KEY (StudentID, CourseID, AssignmentID),
FOREIGN KEY (StudentID,CourseID) REFERENCES StudentCourse(StudentID,CourseID)
)




CREATE FUNCTION check_volume3()   --- 15 credit courses
RETURNS INT
AS
BEGIN
DECLARE @ret int
IF EXISTS(SELECT count(a.AssignmentID)
FROM Assignment a JOIN StudentCourse sc ON a.CourseID=sc.CourseID and a.StudentID = sc.StudentID
JOIN Course c ON a.CourseID = c.CourseID 
WHERE c.Credit = 30 
GROUP BY sc.StudentID, c.CourseID 
HAVING count(a.AssignmentID) > 5)
SELECT @ret =1 ELSE SELECT @ret = 0;
RETURN @ret;
END;


ALTER TABLE Assignment
ADD CONSTRAINT square_volume3 CHECK(dbo.check_volume3() = 0);

CREATE FUNCTION check_volume5()  --- 30 credit courses
RETURNS INT
AS
BEGIN
DECLARE @ret int
IF EXISTS(SELECT count(a.AssignmentID)
FROM Assignment a JOIN StudentCourse sc ON a.CourseID=sc.CourseID and a.StudentID = sc.StudentID
JOIN Course c ON a.CourseID = c.CourseID 
WHERE c.Credit = 30 
GROUP BY sc.StudentID, c.CourseID 
HAVING count(a.AssignmentID) > 3)
SELECT @ret =1 ELSE SELECT @ret = 0;
RETURN @ret;
END;

CREATE FUNCTION check_volume6()
RETURNS INT
AS
BEGIN
DECLARE @ret int
IF EXISTS(SELECT count(a.AssignmentID)
FROM Assignment a JOIN StudentCourse sc ON a.CourseID=sc.CourseID and a.StudentID = sc.StudentID
JOIN Course c ON a.CourseID = c.CourseID 
WHERE c.Credit = 15 
GROUP BY sc.StudentID, c.CourseID 
HAVING count(a.AssignmentID) > 3)
SELECT @ret =1 ELSE SELECT @ret = 0;
RETURN @ret;
END;

select * from Assignment

ALTER TABLE Assignment
ADD CONSTRAINT square_volume5 CHECK(dbo.check_volume5() = 0);

ALTER TABLE Assignment
ADD CONSTRAINT square_volume6 CHECK(dbo.check_volume6() = 0);

CREATE FUNCTION check_volume8()
RETURNS INT
AS
BEGIN
DECLARE @ret int
IF EXISTS(SELECT a.StudentID, a.CourseID
FROM StudentCourse sc inner join Assignment a on a.StudentID = sc.StudentID and a.CourseID = sc.CourseID
where a.StudentID in (select sc.studentID from StudentCourse sc) and a.CourseID in (select sc.CourseID from StudentCourse sc))
SELECT @ret =1 ELSE SELECT @ret = 0;
RETURN @ret;
END;


ALTER TABLE Assignment
ADD CONSTRAINT square_volume7 CHECK(dbo.check_volume8() = 1);



ALTER TABLE Assignment ADD CONSTRAINT check_tablo1_kolon1
CHECK (StudentID IN (select StudentID from StudentCourse) );

CREATE FUNCTION myFunction3()
RETURNS INT
AS
BEGIN
--DECLARE @StudentID int
--DECLARE @CourseID int
    IF EXISTS (SELECT StudentID, CourseID FROM StudentCourse)-- WHERE StudentID = @StudentID and  CourseID = @CourseID)
        return 1
    return 0
END

ALTER TABLE Assignment
ADD CONSTRAINT square_volume8 CHECK(dbo.myFunction3() = 1);

select * from StudentCourse

select * from Assignment
select * from Course


INSERT INTO Assignment (StudentID, CourseID, AssignmentID, Note)
VALUES(1, 6, 3, 90)
INSERT INTO Assignment (StudentID, CourseID, AssignmentID, Note)
VALUES(7, 12, 1, 90)
INSERT INTO Assignment (StudentID, CourseID, AssignmentID, Note)
VALUES(1, 6, 2, 90)
INSERT INTO Assignment (StudentID, CourseID, AssignmentID, Note)
VALUES(1, 6, 4, 90)
INSERT INTO Assignment (StudentID, CourseID, AssignmentID, Note)
VALUES(1, 6, 5, 90)
INSERT INTO Assignment (StudentID, CourseID, AssignmentID, Note)
VALUES(25, 6, 6, 90)
INSERT INTO Assignment (StudentID, CourseID, AssignmentID, Note)
VALUES(1, 6, 6, 90)

select *
from Course c inner join
StudentCourse s on c.CourseID = s.CourseID


select * from Course c


INSERT INTO Assignment (StudentID, CourseID, AssignmentID, Note)
VALUES(1, 9, 2, 90)

INSERT INTO Assignment (StudentID, CourseID, AssignmentID, Note)
VALUES(1, 7, 2, 90)

INSERT INTO Assignment (StudentID, CourseID, AssignmentID, Note)
VALUES(7, 12, 4, 90)

INSERT INTO Assignment (StudentID, CourseID, AssignmentID, Note)
VALUES(7, 12, 1, 90),
(7, 12, 2, 90)


select * from StudentCourse

INSERT INTO Assignment (StudentID, CourseID, AssignmentID, Note)
VALUES(1, 1, 1, 90),
(1, 1, 2, 95),
(1, 1, 3, 100),
(2, 2, 1, 100),
(2, 2, 2, 100),
(2, 2, 3, 95),
(2, 2, 4, 100),
(2, 2, 5, 95)

INSERT INTO Assignment (StudentID, CourseID, AssignmentID, Note)
VALUES(2,2,6, 90)

INSERT INTO Assignment (StudentID, CourseID, AssignmentID, Note)
VALUES(1, 9, 4, 101)

select * from Course

select * from Assignment

INSERT INTO Assignment (StudentID, CourseID, AssignmentID, Note)
VALUES(7,11 , 1, 90),
(7, 11, 2, 90),
(7, 11, 3, 90),
(7, 11, 4, 90)

INSERT INTO Assignment (StudentID, CourseID, AssignmentID, Note)
VALUES
(7, 11, 5, 90),
(7, 11, 6, 90)

select * from Assignment
select * from student
select * from course

select * from StudentCourse

-------STAFF TABLEE-------

create table Staff ( 
staff_id smallint identity(20,1),
staff_name varchar(55),
primary key (staff_id)
)
---- STUDENT STAFF ---
create table student_staff (
primary key (staff_id,StudentID),
staff_id smallint foreign key  references Staff(staff_id),
StudentID int foreign key references student(StudentID),
RegionName varchar(55)

)

alter table Staff drop column staff_type

--- STAFF COURSE--

create table staff_course (
primary KEY (staff_id, CourseID),
staff_id SMALLINT foreign key REFERENCES Staff(staff_id) NOT NULL, 
CourseID INT foreign key REFERENCES Course(CourseID) NOT NULL, 
) 
----- constraint for staffcourse just select enrolled courses
CREATE FUNCTION staff_cons()
RETURNS INT
AS
BEGIN
DECLARE @ret int
IF EXISTS(SELECT CourseID
FROM Staff s JOIN staff_course sc ON s.staff_id=sc.staff_id

where CourseID in (select CourseID from Course))
SELECT @ret =1 ELSE SELECT @ret = 0;
RETURN @ret;
END;
--- region constraint
--ALTER TABLE student_staff add constraint region CHECK (RegionName in ('England','Wales','Northern Ireland','Scotland'))
ALTER TABLE student_staff drop column RegionName

ALTER TABLE staff_course add constraint staff1 CHECK (dbo.staff_cons() = 1);


ALTER TABLE Assignment ADD CONSTRAINT check_tablo1_kolon1
CHECK (StudentID IN (select StudentID from StudentCourse) );

INSERT INTO Staff( staff_name)
VALUES ('MAHMUT'),
('MEHMET'),
('AHMET'),
('MÝTHAT'),
('CAN'),
('JOHN'),
('NECATÝ'),
('MARTÝN')


INSERT INTO staff_course(staff_id,CourseID)
VALUES 
(21,4),
(21,3),
(21,3),
(21,3),
(21,3),
(21,3),


select * from staff_course
-- one staff can select just one course  
CREATE FUNCTION staff_cons()
RETURNS INT
AS
BEGIN
DECLARE @ret int
IF EXISTS(SELECT CourseID,staff_id
FROM staff_course
WHERE CourseID and staff_id  in 



SELECT @ret =1 ELSE SELECT @ret = 0;
RETURN @ret;
END;

SELECT * FROM staff_course          

INSERT INTO staff_course(staff_id, CourseID)
VALUES ()

select * from Course  

INSERT INTO StudentCourse(StudentID, CourseID,registrationDate)
VALUES (2,11,'2020-05-12')


