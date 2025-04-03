drop table prereq cascade constraints;
drop table time_slot cascade constraints;
drop table advisor cascade constraints;
drop table takes cascade constraints;
drop table student cascade constraints;
drop table teaches cascade constraints;
drop table section cascade constraints;
drop table instructor cascade constraints;
drop table course cascade constraints;
drop table department cascade constraints;
drop table classroom cascade constraints;


-- Create tables
CREATE TABLE classroom (
    building VARCHAR(15),
    room_number VARCHAR(7),
    capacity INT CHECK (capacity > 0),
    PRIMARY KEY (building, room_number)
);

CREATE TABLE department (
    dept_name VARCHAR(20),
    building VARCHAR(15),
    budget DECIMAL(12,2) CHECK (budget > 0),
    PRIMARY KEY (dept_name)
);

CREATE TABLE course (
    course_id VARCHAR(8),
    title VARCHAR(50),
    dept_name VARCHAR(20),
    credits INT CHECK (credits > 0),
    PRIMARY KEY (course_id),
    FOREIGN KEY (dept_name) REFERENCES department(dept_name) ON DELETE CASCADE
);

CREATE TABLE instructor (
    id VARCHAR(5),
    name VARCHAR(30),
    dept_name VARCHAR(20),
    salary DECIMAL(8,2) CHECK (salary > 0),
    PRIMARY KEY (id),
    FOREIGN KEY (dept_name) REFERENCES department(dept_name) ON DELETE SET NULL
);

CREATE TABLE section (
    course_id VARCHAR(8),
    sec_id VARCHAR(8),
    semester VARCHAR(6) CHECK (semester IN ('Fall', 'Spring', 'Summer', 'Winter')),
    year INT CHECK (year >= 1900 AND year <= 2100),
    building VARCHAR(15),
    room_number VARCHAR(7),
    time_slot_id VARCHAR(4),
    PRIMARY KEY (course_id, sec_id, semester, year),
    FOREIGN KEY (course_id) REFERENCES course(course_id) ON DELETE CASCADE,
    FOREIGN KEY (building, room_number) REFERENCES classroom(building, room_number)
);

CREATE TABLE teaches (
    id VARCHAR(5),
    course_id VARCHAR(8),
    sec_id VARCHAR(8),
    semester VARCHAR(6),
    year INT,
    PRIMARY KEY (id, course_id, sec_id, semester, year),
    FOREIGN KEY (id) REFERENCES instructor(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id, sec_id, semester, year) REFERENCES section(course_id, sec_id, semester, year) ON DELETE CASCADE
);

CREATE TABLE student (
    id VARCHAR(5),
    name VARCHAR(30),
    dept_name VARCHAR(20),
    tot_cred INT CHECK (tot_cred >= 0),
    PRIMARY KEY (id),
    FOREIGN KEY (dept_name) REFERENCES department(dept_name) ON DELETE SET NULL
);

CREATE TABLE takes (
    id VARCHAR(5),
    course_id VARCHAR(8),
    sec_id VARCHAR(8),
    semester VARCHAR(6),
    year INT,
    grade CHAR(2) CHECK (grade IN ('A', 'B', 'C', 'D', 'F', 'W', 'I')),
    PRIMARY KEY (id, course_id, sec_id, semester, year),
    FOREIGN KEY (id) REFERENCES student(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id, sec_id, semester, year) REFERENCES section(course_id, sec_id, semester, year) ON DELETE CASCADE
);

CREATE TABLE advisor (
    s_id VARCHAR(5),
    i_id VARCHAR(5),
    PRIMARY KEY (s_id),
    FOREIGN KEY (s_id) REFERENCES student(id) ON DELETE CASCADE,
    FOREIGN KEY (i_id) REFERENCES instructor(id) ON DELETE SET NULL
);

CREATE TABLE time_slot (
    time_slot_id VARCHAR2(4),
    day CHAR(1) CHECK (day IN ('M', 'T', 'W', 'R', 'F', 'S', 'U')),
    start_time DATE, 
    end_time DATE,   
    PRIMARY KEY (time_slot_id, day, start_time),
    UNIQUE (time_slot_id, start_time, end_time),
    CHECK (end_time > start_time) 
);


CREATE TABLE prereq (
    course_id VARCHAR(8),
    prereq_id VARCHAR(8),
    PRIMARY KEY (course_id, prereq_id),
    FOREIGN KEY (course_id) REFERENCES course(course_id) ON DELETE CASCADE,
    FOREIGN KEY (prereq_id) REFERENCES course(course_id) ON DELETE CASCADE
);


-- Insert data
insert into classroom values ('Packard', '101', 500);
insert into classroom values ('Painter', '514', 10);
insert into classroom values ('Taylor', '3128', 70);
insert into classroom values ('Watson', '100', 30);
insert into classroom values ('Watson', '120', 50);

insert into department values ('Biology', 'Watson', 90000);
insert into department values ('Comp. Sci.', 'Taylor', 100000);
insert into department values ('Elec. Eng.', 'Taylor', 85000);
insert into department values ('Finance', 'Painter', 120000);
insert into department values ('History', 'Painter', 50000);
insert into department values ('Music', 'Packard', 80000);
insert into department values ('Physics', 'Watson', 70000);

insert into course values ('BIO-101', 'Intro. to Biology', 'Biology', 4);
insert into course values ('BIO-301', 'Genetics', 'Biology', 4);
insert into course values ('BIO-399', 'Computational Biology', 'Biology', 3);
insert into course values ('CS-101', 'Intro. to Computer Science', 'Comp. Sci.', 4);
insert into course values ('CS-190', 'Game Design', 'Comp. Sci.', 4);
insert into course values ('CS-315', 'Robotics', 'Comp. Sci.', 3);
insert into course values ('CS-319', 'Image Processing', 'Comp. Sci.', 3);
insert into course values ('CS-347', 'Database System Concepts', 'Comp. Sci.', 3);
insert into course values ('EE-181', 'Intro. to Digital Systems', 'Elec. Eng.', 3);
insert into course values ('FIN-201', 'Investment Banking', 'Finance', 3);
insert into course values ('HIS-351', 'World History', 'History', 3);
insert into course values ('MU-199', 'Music Video Production', 'Music', 3);
insert into course values ('PHY-101', 'Physical Principles', 'Physics', 4);

insert into instructor values ('10101', 'Srinivasan', 'Comp. Sci.', 65000);
insert into instructor values ('12121', 'Wu', 'Finance', 90000);
insert into instructor values ('15151', 'Mozart', 'Music', 40000);
insert into instructor values ('22222', 'Einstein', 'Physics', 95000);
insert into instructor values ('32343', 'El Said', 'History', 60000);
insert into instructor values ('33456', 'Gold', 'Physics', 87000);
insert into instructor values ('45565', 'Katz', 'Comp. Sci.', 75000);
insert into instructor values ('58583', 'Califieri', 'History', 62000);
insert into instructor values ('76543', 'Singh', 'Finance', 80000);
insert into instructor values ('76766', 'Crick', 'Biology', 72000);
insert into instructor values ('83821', 'Brandt', 'Comp. Sci.', 92000);
insert into instructor values ('98345', 'Kim', 'Elec. Eng.', 80000);

insert into section values ('BIO-101', '1', 'Summer', 2009, 'Painter', '514', 'B');
insert into section values ('BIO-301', '1', 'Summer', 2010, 'Painter', '514', 'A');
insert into section values ('CS-101', '1', 'Fall', 2009, 'Packard', '101', 'H');
insert into section values ('CS-101', '1', 'Spring', 2010, 'Packard', '101', 'F');
insert into section values ('CS-190', '1', 'Spring', 2009, 'Taylor', '3128', 'E');
insert into section values ('CS-190', '2', 'Spring', 2009, 'Taylor', '3128', 'A');
insert into section values ('CS-315', '1', 'Spring', 2010, 'Watson', '120', 'D');
insert into section values ('CS-319', '1', 'Spring', 2010, 'Watson', '100', 'B');
insert into section values ('CS-319', '2', 'Spring', 2010, 'Taylor', '3128', 'C');
insert into section values ('CS-347', '1', 'Fall', 2009, 'Taylor', '3128', 'A');
insert into section values ('EE-181', '1', 'Spring', 2009, 'Taylor', '3128', 'C');
insert into section values ('FIN-201', '1', 'Spring', 2010, 'Packard', '101', 'B');
insert into section values ('HIS-351', '1', 'Spring', 2010, 'Painter', '514', 'C');
insert into section values ('MU-199', '1', 'Spring', 2010, 'Packard', '101', 'D');
insert into section values ('PHY-101', '1', 'Fall', 2009, 'Watson', '100', 'A');

insert into teaches values ('10101', 'CS-101', '1', 'Fall', 2009);
insert into teaches values ('10101', 'CS-315', '1', 'Spring', 2010);
insert into teaches values ('10101', 'CS-347', '1', 'Fall', 2009);
insert into teaches values ('12121', 'FIN-201', '1', 'Spring', 2010);
insert into teaches values ('15151', 'MU-199', '1', 'Spring', 2010);
insert into teaches values ('22222', 'PHY-101', '1', 'Fall', 2009);
insert into teaches values ('32343', 'HIS-351', '1', 'Spring', 2010);
insert into teaches values ('45565', 'CS-101', '1', 'Spring', 2010);
insert into teaches values ('45565', 'CS-319', '1', 'Spring', 2010);
insert into teaches values ('76766', 'BIO-101', '1', 'Summer', 2009);
insert into teaches values ('76766', 'BIO-301', '1', 'Summer', 2010);
insert into teaches values ('83821', 'CS-190', '1', 'Spring', 2009);
insert into teaches values ('83821', 'CS-190', '2', 'Spring', 2009);
insert into teaches values ('83821', 'CS-319', '2', 'Spring', 2010);
insert into teaches values ('98345', 'EE-181', '1', 'Spring', 2009);

insert into student values ('00128', 'Zhang', 'Comp. Sci.', 102);
insert into student values ('12345', 'Shankar', 'Comp. Sci.', 32);
insert into student values ('19991', 'Brandt', 'History', 80);
insert into student values ('23121', 'Chavez', 'Finance', 110);
insert into student values ('44553', 'Peltier', 'Physics', 56);
insert into student values ('45678', 'Levy', 'Physics', 46);
insert into student values ('54321', 'Williams', 'Comp. Sci.', 54);
insert into student values ('55739', 'Sanchez', 'Music', 38);
insert into student values ('70557', 'Snow', 'Physics', 0);
insert into student values ('76543', 'Brown', 'Comp. Sci.', 58);
insert into student values ('76653', 'Aoi', 'Elec. Eng.', 60);
insert into student values ('98765', 'Bourikas', 'Elec. Eng.', 98);
insert into student values ('98988', 'Tanaka', 'Biology', 120);

insert into takes values ('00128', 'CS-101', '1', 'Fall', 2009, 'A');
insert into takes values ('00128', 'CS-347', '1', 'Fall', 2009, 'A-');
insert into takes values ('12345', 'CS-101', '1', 'Fall', 2009, 'C');
insert into takes values ('12345', 'CS-190', '2', 'Spring', 2009, 'A');
insert into takes values ('12345', 'CS-315', '1', 'Spring', 2010, 'A');
insert into takes values ('12345', 'CS-347', '1', 'Fall', 2009, 'A');
insert into takes values ('19991', 'HIS-351', '1', 'Spring', 2010, 'B');
insert into takes values ('23121', 'FIN-201', '1', 'Spring', 2010, 'C+');
insert into takes values ('44553', 'PHY-101', '1', 'Fall', 2009, 'B-');
insert into takes values ('45678', 'CS-101', '1', 'Fall', 2009, 'F');
insert into takes values ('45678', 'CS-101', '1', 'Spring', 2010, 'B+');
insert into takes values ('45678', 'CS-319', '1', 'Spring', 2010, 'B');
insert into takes values ('54321', 'CS-101', '1', 'Fall', 2009, 'A-');
insert into takes values ('54321', 'CS-190', '2', 'Spring', 2009, 'B+');
insert into takes values ('55739', 'MU-199', '1', 'Spring', 2010, 'A-');
insert into takes values ('76543', 'CS-101', '1', 'Fall', 2009, 'A');
insert into takes values ('76543', 'CS-319', '2', 'Spring', 2010, 'A');
insert into takes values ('76653', 'EE-181', '1', 'Spring', 2009, 'C');
insert into takes values ('98765', 'CS-101', '1', 'Fall', 2009, 'C-');
insert into takes values ('98765', 'CS-315', '1', 'Spring', 2010, 'B');
insert into takes values ('98988', 'BIO-101', '1', 'Summer', 2009, 'A');
insert into takes values ('98988', 'BIO-301', '1', 'Summer', 2010, null);

insert into advisor values ('00128', '45565');
insert into advisor values ('12345', '10101');
insert into advisor values ('23121', '76543');
insert into advisor values ('44553', '22222');
insert into advisor values ('45678', '22222');
insert into advisor values ('76543', '45565');
insert into advisor values ('76653', '98345');
insert into advisor values ('98765', '98345');
insert into advisor values ('98988', '76766');

insert into time_slot VALUES ('A', 'M', TO_TIMESTAMP('08:00', 'HH24:MI'), TO_TIMESTAMP('08:50', 'HH24:MI'));
insert into time_slot VALUES ('A', 'W', TO_TIMESTAMP('08:00', 'HH24:MI'), TO_TIMESTAMP('08:50', 'HH24:MI'));
insert into time_slot VALUES ('A', 'F', TO_TIMESTAMP('08:00', 'HH24:MI'), TO_TIMESTAMP('08:50', 'HH24:MI'));
insert into time_slot VALUES ('B', 'M', TO_TIMESTAMP('09:00', 'HH24:MI'), TO_TIMESTAMP('09:50', 'HH24:MI'));
insert into time_slot VALUES ('B', 'W', TO_TIMESTAMP('09:00', 'HH24:MI'), TO_TIMESTAMP('09:50', 'HH24:MI'));
insert into time_slot VALUES ('B', 'F', TO_TIMESTAMP('09:00', 'HH24:MI'), TO_TIMESTAMP('09:50', 'HH24:MI'));
insert into time_slot VALUES ('C', 'M', TO_TIMESTAMP('11:00', 'HH24:MI'), TO_TIMESTAMP('11:50', 'HH24:MI'));
insert into time_slot VALUES ('C', 'W', TO_TIMESTAMP('11:00', 'HH24:MI'), TO_TIMESTAMP('11:50', 'HH24:MI'));
insert into time_slot VALUES ('C', 'F', TO_TIMESTAMP('11:00', 'HH24:MI'), TO_TIMESTAMP('11:50', 'HH24:MI'));
insert into time_slot VALUES ('D', 'M', TO_TIMESTAMP('13:00', 'HH24:MI'), TO_TIMESTAMP('13:50', 'HH24:MI'));
insert into time_slot VALUES ('D', 'W', TO_TIMESTAMP('13:00', 'HH24:MI'), TO_TIMESTAMP('13:50', 'HH24:MI'));
insert into time_slot VALUES ('D', 'F', TO_TIMESTAMP('13:00', 'HH24:MI'), TO_TIMESTAMP('13:50', 'HH24:MI'));
insert into time_slot VALUES ('E', 'T', TO_TIMESTAMP('10:30', 'HH24:MI'), TO_TIMESTAMP('11:45', 'HH24:MI'));
insert into time_slot VALUES ('E', 'R', TO_TIMESTAMP('10:30', 'HH24:MI'), TO_TIMESTAMP('11:45', 'HH24:MI'));
insert into time_slot VALUES ('F', 'T', TO_TIMESTAMP('14:30', 'HH24:MI'), TO_TIMESTAMP('15:45', 'HH24:MI'));
insert into time_slot VALUES ('F', 'R', TO_TIMESTAMP('14:30', 'HH24:MI'), TO_TIMESTAMP('15:45', 'HH24:MI'));
insert into time_slot VALUES ('G', 'M', TO_TIMESTAMP('16:00', 'HH24:MI'), TO_TIMESTAMP('16:50', 'HH24:MI'));
INSERT into time_slot VALUES ('G', 'W', TO_TIMESTAMP('16:00', 'HH24:MI'), TO_TIMESTAMP('16:50', 'HH24:MI'));
insert into time_slot VALUES ('G', 'F', TO_TIMESTAMP('16:00', 'HH24:MI'), TO_TIMESTAMP('16:50', 'HH24:MI'));
insert into time_slot VALUES ('H', 'W', TO_TIMESTAMP('10:00', 'HH24:MI'), TO_TIMESTAMP('12:30', 'HH24:MI')); -- 10:00 AM to 12:30 PM

insert into prereq values ('BIO-301', 'BIO-101');
insert into prereq values ('BIO-399', 'BIO-101');
insert into prereq values ('CS-190', 'CS-101');
insert into prereq values ('CS-315', 'CS-101');
insert into prereq values ('CS-319', 'CS-101');
insert into prereq values ('CS-347', 'CS-101');
insert into prereq values ('EE-181', 'PHY-101');

commit;

SELECT course_id, title 
FROM course
WHERE course_id IN (SELECT course_id 
                    FROM section 
                    WHERE semester = 'Fall' AND year = 2009)
  AND course_id IN (SELECT course_id 
                    FROM section 
                    WHERE semester = 'Spring' AND year = 2010); 

-- Find courses offered in Fall 2009 but not in Spring 2010

SELECT course_id, title
FROM course
WHERE course_id IN (SELECT course_id 
                    FROM section 
                    WHERE semester = 'Fall' AND year = 2009)
  AND course_id NOT IN (SELECT course_id 
                        FROM section 
                        WHERE semester = 'Spring' AND year = 2010);

-- Find the total number of (distinct) students who have taken course sections taught by the instructor with ID 10101

SELECT COUNT(DISTINCT T.ID) AS num_students
FROM takes T
WHERE (T.course_id, T.sec_id, T.semester, T.year) IN (
    SELECT Te.course_id, Te.sec_id, Te.semester, Te.year
    FROM teaches Te
    WHERE Te.ID = '10101'
);

-- B. SOME/ALL
-- Find names of instructors with salary greater than that of some (at least one) instructor in the Biology department.

SELECT name
FROM instructor
WHERE salary > SOME (SELECT salary 
                     FROM instructor 
                     WHERE dept_name = 'Biology');

-- Find the names of all instructors whose salary is greater than the salary of all instructors in the Biology department.

SELECT name
FROM instructor
WHERE salary > ALL (SELECT salary 
                    FROM instructor 
                    WHERE dept_name = 'Biology');

-- C. EXISTS/NOT EXISTS
-- Find all courses taught in both the Fall 2009 semester and in the Spring 2010 semester

SELECT C.course_id, C.title
FROM course C
WHERE EXISTS (SELECT S1.course_id 
              FROM section S1
              WHERE S1.course_id = C.course_id 
                AND S1.semester = 'Fall' AND S1.year = 2009)
  AND EXISTS (SELECT S2.course_id 
              FROM section S2
              WHERE S2.course_id = C.course_id 
                AND S2.semester = 'Spring' AND S2.year = 2010);

-- Find all courses taught in Fall 2009 semester but not in the Spring 2010 semester

SELECT C.course_id, C.title
FROM course C
WHERE EXISTS (SELECT S1.course_id 
              FROM section S1
              WHERE S1.course_id = C.course_id 
                AND S1.semester = 'Fall' AND S1.year = 2009)
  AND NOT EXISTS (SELECT S2.course_id 
                  FROM section S2
                  WHERE S2.course_id = C.course_id 
                    AND S2.semester = 'Spring' AND S2.year = 2010);

-- Find all students who have taken all courses offered in the Biology department.

SELECT S.ID, S.name
FROM student S
WHERE EXISTS (
    SELECT C.course_id
    FROM course C
    WHERE C.dept_name = 'Biology'
      AND  EXISTS (
          SELECT T.course_id
          FROM takes T
          WHERE T.ID = S.ID
          AND T.course_id = C.course_id
      )
);


-- Subqueries in the FROM clause
-- Find the average instructors’ salaries of those departments where the average salary is greater than $42,000

SELECT dept_name, avg_salary
FROM (SELECT dept_name, AVG(salary) AS avg_salary -- Keep 'AS' for the column alias
      FROM instructor
      WHERE dept_name IS NOT NULL -- Added check: ensures instructors belong to a department before averaging
      GROUP BY dept_name) dept_avg -- Removed 'AS' before the table alias 'dept_avg'
WHERE avg_salary > 42000;

-- Complex Queries using WITH clause
-- Find all departments with the maximum budget

WITH MaxBudget AS ( -- Removed the column alias list (value) from here
    SELECT MAX(budget) AS value -- Added the column alias 'AS value' here inside the SELECT
    FROM department
)
SELECT dept_name, budget
FROM department, MaxBudget -- This implicit join works fine since MaxBudget has one row
WHERE department.budget = MaxBudget.value; 

-- Find all departments where the total salary is greater than the average of the total salary at all departments

WITH DepTotalSalary AS ( -- Removed (dept_name, total_salary)
    SELECT dept_name, SUM(salary) AS total_salary -- Added alias AS total_salary here
    FROM instructor
    WHERE dept_name IS NOT NULL
    GROUP BY dept_name
), 
AvgTotalSalary AS ( -- Removed (avg_value)
    SELECT AVG(total_salary) AS avg_value -- Added alias AS avg_value here
    FROM DepTotalSalary -- This references the first CTE correctly
)
SELECT DTS.dept_name, DTS.total_salary
FROM DepTotalSalary DTS, AvgTotalSalary ATS
WHERE DTS.total_salary > ATS.avg_value;

-- Subqueries in the SELECT clause (Scalar Subquery)
-- Find number of instructors for each department

SELECT D.dept_name, 
       (SELECT COUNT(I.ID) 
        FROM instructor I 
        WHERE I.dept_name = D.dept_name) AS num_instructors
FROM department D;

-- Performing Outer Joins
-- LEFT OUTER JOIN

SELECT D.dept_name, D.building, I.ID AS instructor_id, I.name AS instructor_name
FROM department D
LEFT OUTER JOIN instructor I ON D.dept_name = I.dept_name
ORDER BY D.dept_name, I.name; 

-- RIGHT OUTER JOIN

SELECT D.dept_name, D.building, I.ID AS instructor_id, I.name AS instructor_name
FROM department D
RIGHT OUTER JOIN instructor I ON D.dept_name = I.dept_name
ORDER BY D.dept_name, I.name;

-- FULL OUTER JOIN

SELECT D.dept_name, D.building, I.ID AS instructor_id, I.name AS instructor_name
FROM department D
FULL OUTER JOIN instructor I ON D.dept_name = I.dept_name
ORDER BY D.dept_name, I.name;

-- Find number of instructors for each department. You must include departments with no instructor.

SELECT D.dept_name, COUNT(I.ID) AS num_instructors
FROM department D
LEFT OUTER JOIN instructor I ON D.dept_name = I.dept_name
GROUP BY D.dept_name
ORDER BY D.dept_name;

