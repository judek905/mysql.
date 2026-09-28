create database Universit;
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

SELECT DISTINCT 'towns' FROM students;
SELECT marks + 4 AS increment_marks FROM students;
SELECT age - 5 AS rightful_age FROM students;
SELECT * FROM students WHERE age BETWEEN 23 AND 60;
SELECT * FROM students WHERE 'towns' NOT IN ('Kampala, Entebbe');
SELECT * FROM students WHERE 'towns' like 'k%';
select * FROM students WHERE 'name' like 'a%';
select * FROM students WHERE 'name' like '%an%';