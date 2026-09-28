create database University;
show databases;
use University;
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100),
    gender VARCHAR(10),
    programme VARCHAR(50),
    year_of_study INT,
    age INT,
    marks INT,
    town VARCHAR(50)
);

INSERT INTO students VALUES
(101, 'Sarah Nakato', 'Female', 'BSIT', 1, 19, 78, 'Mukono'),
(102, 'John Kato', 'Male', 'DIT', 2, 22, 65, 'Kampala'),
(103, 'Mary Achieng', 'Female', 'BSIT', 3, 24, 88, 'Jinja'),
(104, 'David Ouma', 'Male', 'BSE', 1, 20, 54, 'Mukono'),
(105, 'Peter Ssenyonga', 'Male', 'BSIT', 2, 23, 72, 'Kampala'),
(106, 'Grace Namusoke', 'Female', 'DIT', 1, 20, 91, 'Entebbe'),
(107, 'Brian Okello', 'Male', 'BSE', 3, 25, 47, 'Jinja'),
(108, 'Ruth Nakanwagi', 'Female', 'BSIT', 2, 21, 83, 'Mukono'),
(109, 'Samuel Mugisha', 'Male', 'DIT', 3, 24, 69, 'Kampala'),
(110, 'Esther Atim', 'Female', 'BSE', 1, 19, 76, 'Gulu');
SELECT * FROM students;
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'students';
SELECT student_name, programme, marks FROM students;
SELECT student_name, town FROM students;
SELECT * FROM students WHERE programme = 'BSIT';
SELECT student_name, marks, town FROM students WHERE marks > 70;
SELECT student_name, age FROM students;
SELECT * FROM students WHERE programme = 'BSIT';
SELECT * FROM students WHERE marks >= 70;
SELECT * FROM students WHERE town = 'Mukono';
SELECT * FROM students WHERE gender = 'Female';
SELECT * FROM students WHERE programme = 'BSIT' AND marks > 75;
SELECT * FROM students WHERE town = 'Mukono' OR town = 'Kampala';
SELECT * FROM students WHERE town IN ('Mukono', 'Kampala');
SELECT * FROM students WHERE gender = 'Female' AND year_of_study = 1;
SELECT * FROM students WHERE marks BETWEEN 60 AND 80;
SELECT * FROM students WHERE programme != 'BSE';
SELECT * FROM students WHERE programme <> 'BSE';
SELECT * FROM students ORDER BY marks DESC;
SELECT * FROM students ORDER BY marks ASC;
SELECT * FROM students WHERE programme = 'BSIT' ORDER BY marks DESC;
SELECT * FROM students WHERE gender = 'Female' AND programme = 'BSIT' AND marks >= 80;
SELECT * FROM students WHERE year_of_study = 2 AND marks > 70;
SELECT * FROM students WHERE (town = 'Mukono' AND marks < 60) OR (town = 'Jinja' AND marks > 80);



-- REFLECTION--

-- QN(1)
-- Challenge 3 gave me the most trouble. It had both AND and OR in the
-- same query, and I wasn't sure how SQL would read it. Adding brackets
-- around each part fixed it and made way more sense after that.

-- QN(2)
-- Yes, I forgot to put quotes around text like 'BSIT' and 'Mukono' at
-- first, so my query kept failing. I also thought BETWEEN 60 AND 80
-- would skip 60 and 80, but it actually includes them. Took me a minute
-- to figure out why an 83 wasn't showing up right.

-- QN(3)
-- A hospital could use this to filter patients, like finding everyone
-- who's due for a check-up or ready for discharge. Instead of scrolling
-- through hundreds of records by hand, they can just pull up exactly
-- who they need in seconds.