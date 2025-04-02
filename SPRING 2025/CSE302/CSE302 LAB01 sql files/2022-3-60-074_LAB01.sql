CREATE TABLE instructor_2022360074(
    id number,
    name varchar2 (50),
    dept_name  varchar2 (20),
    salary number
    );

CREATE TABLE course_2022360074 (
    course_id VARCHAR (10) ,
    title VARCHAR (100),
    dept_name VARCHAR (50),
    credits Number
);

INSERT INTO instructor_2022360074 VALUES (10101, 'Srinivasan', 'Comp. Sci.', 65000);
INSERT INTO instructor_2022360074 VALUES (12121, 'Wu', 'Finance', 90000);
INSERT INTO instructor_2022360074 VALUES (15151, 'Mozart', 'Music', 40000);
INSERT INTO instructor_2022360074 VALUES (22222, 'Einstein', 'Physics', 95000);
INSERT INTO instructor_2022360074 VALUES (32343, 'El Said', 'History', 60000);
INSERT INTO instructor_2022360074 VALUES (33456, 'Gold', 'Physics', 87000);
INSERT INTO instructor_2022360074 VALUES (45565, 'Katz', 'Comp. Sci.', 75000);
INSERT INTO instructor_2022360074 VALUES (58583, 'Califieri', 'History', 62000);
INSERT INTO instructor_2022360074 VALUES (76543, 'Singh', 'Finance', 80000);
INSERT INTO instructor_2022360074 VALUES (76766, 'Crick', 'Biology', 72000);
INSERT INTO instructor_2022360074 VALUES (83821, 'Brandt', 'Comp. Sci.', 92000);
INSERT INTO instructor_2022360074 VALUES (98345, 'Kim', 'Elec. Eng.', 80000);


INSERT INTO course_2022360074 VALUES ('BIO-101', 'Intro. to Biology', 'Biology', 4);
INSERT INTO course_2022360074 VALUES ('BIO-301', 'Genetics', 'Biology', 4);
INSERT INTO course_2022360074 VALUES ('BIO-399', 'Computational Biology', 'Biology', 3);
INSERT INTO course_2022360074 VALUES ('CS-101', 'Intro. to Computer Science', 'Comp. Sci.', 4);
INSERT INTO course_2022360074 VALUES ('CS-190', 'Game Design', 'Comp. Sci.', 4);
INSERT INTO course_2022360074 VALUES ('CS-315', 'Robotics', 'Comp. Sci.', 3);
INSERT INTO course_2022360074 VALUES ('CS-319', 'Image Processing', 'Comp. Sci.', 3);
INSERT INTO course_2022360074 VALUES ('CS-347', 'Database System Concepts', 'Comp. Sci.', 3);
INSERT INTO course_2022360074 VALUES ('EE-181', 'Intro. to Digital Systems', 'Elec. Eng.', 3);
INSERT INTO course_2022360074 VALUES ('FIN-201', 'Investment Banking', 'Finance', 3);
INSERT INTO course_2022360074 VALUES ('HIS-351', 'World History', 'History', 3);
INSERT INTO course_2022360074 VALUES ('MU-199', 'Music Video Production', 'Music', 3);
INSERT INTO course_2022360074 VALUES ('PHY-101', 'Physical Principles', 'Physics', 4);

SELECT name 
FROM instructor_2022360074;

SELECT course_id, title 
FROM course_2022360074;

SELECT name, dept_name 
FROM instructor_2022360074 
WHERE id = 22222;

SELECT title, credits 
FROM course_2022360074 
WHERE dept_name = 'Comp. Sci.';

SELECT name, dept_name 
FROM instructor_2022360074 
WHERE salary > 70000;

SELECT title 
FROM course_2022360074 
WHERE credits >= 4;

SELECT name, dept_name 
FROM instructor_2022360074 
WHERE salary BETWEEN 80000 AND 100000;

SELECT title, credits 
FROM course_2022360074 
WHERE dept_name <> 'Comp. Sci.';

SELECT * 
FROM instructor_2022360074;

SELECT *
FROM course_2022360074 
WHERE dept_name = 'Biology' AND credits <> 4;
