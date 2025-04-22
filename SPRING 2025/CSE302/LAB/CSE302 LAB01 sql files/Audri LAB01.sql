Instructor table:
CREATE TABLE instructor_2022360074(
    id NUMBER,
    name VARCHAR2(100),
    dept_name VARCHAR2(101),
    salary NUMBER
    );

insert into instructor_2022360074 VALUES(10101,'Srinivasan','Comp.Sci',65000);
insert into instructor_2022360074 VALUES(12121,'Wu','Finance',90000);
insert into instructor_2022360074 VALUES(15151,'Mozart','Music',40000);
insert into instructor_2022360074 VALUES(22222,'Einstein','Physics',95000);
insert into instructor_2022360074 VALUES(32343,'El Said','History',60000);
insert into instructor_2022360074 VALUES(33456,'Gold','Physics',87000);
insert into instructor_2022360074 VALUES(45565,'Katz','Comp.Sci',75000);
insert into instructor_2022360074 VALUES(58583,'Caliieri','History',62000);
insert into instructor_2022360074 VALUES(76543,'Singh','Finance',80000);
insert into instructor_2022360074 VALUES(76766,'Crick','Biology',72000);
insert into instructor_2022360074 VALUES(83821,'Brandt','Comp.Sci',92000);
insert into instructor_2022360074 VALUES(10101,'Kim','Elec.Eng',80000);

 select * from instructor_2022360074;


Course table:

CREATE TABLE course_2022360074(
course_id VARCHAR(100),
title VARCHAR(101),
dept_name VARCHAR(102),
credits NUMBER
);


insert into course_2022360074 VALUES('BIO-101','Intro. to Biology','Biology',4);
insert into course_2022360074 VALUES('BIO-301','Genetics','Biology',4);
insert into course_2022360074 VALUES('BIO-399','Computational Biology','Biology',3);
insert into course_2022360074 VALUES('CS-101','Inro.to Computer Scicence','Comp. Sci',4);
insert into course_2022360074 VALUES('CS-190','Game Design','Comp. Sci',4);
insert into course_2022360074 VALUES('CS-315','Robotics','Comp. Sci',3);
insert into course_2022360074 VALUES('CS-319','Image Processing','Comp. Sci',3);
insert into course_2022360074 VALUES('CS-347','Database System Concept','Comp. Sci',3);
insert into course_2022360074 VALUES('EE-181','Inro. to Digital Systems','Elec.Eng',3);
insert into course_2022360074 VALUES('FIN-201','Invesment Banking','Finance',3);
insert into course_2022360074 VALUES('HIS-351','World History','History',3);
insert into course_2022360074 VALUES('MU-199','Music Video Production','Music',3);
insert into course_2022360074 VALUES('PHY-101','Physical Principles','Physics',4);

 select * from course_2022360074;



10 question part:

1) select name from instructor_2022360074;

2) select course_id,title from course_2022360074;

3) select name,dept_name 
  from instructor_2022360074 
  where id = 22222;

4)SELECT title, credits 
  FROM course_2022360074 
  WHERE dept_name = 'Comp. Sci';

5)select name,dept_name 
  from instructor_2022360074 
  where salary > 70000;

6) SELECT title 
   FROM course_2022360074
   WHERE credits > = 4;

7) SELECT name,dept_name
   FROM instructor_2022360074
   WHERE salary BETWEEN 80000 AND 100000;

8) SELECT title,credits
   FROM course_2022360074
   WHERE dept_name ! = 'Comp. Sci'; 

9) SELECT *
   FROM instructor_2022360074;

10)    SELECT * 
    FROM course_2022360074
    WHERE dept_name = 'Biology' AND credits <> 4;















