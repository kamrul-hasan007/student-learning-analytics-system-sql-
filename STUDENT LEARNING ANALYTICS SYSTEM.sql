
-- STUDENT LEARNING ANALYTICS SYSTEM
-- Developed by: MD.KAMRUL HASAN
-- University: ABC University


--  TABLE 1: students

CREATE TABLE students (
    student_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department VARCHAR(50) NOT NULL
);


--  TABLE 2: attendance

CREATE TABLE attendance (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    total_classes INT NOT NULL,
    attended_classes INT NOT NULL,
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);



--  TABLE 3: performance

CREATE TABLE performance (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course VARCHAR(100) NOT NULL,
    score DECIMAL(5,2) NOT NULL,
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);


--  SAMPLE DATA INSERTION

INSERT INTO students (student_id, name, department)
VALUES
(1, 'Alice', 'CSE'),
(2, 'Bob', 'EEE'),
(3, 'Charlie', 'CSE'),
(4, 'Diana', 'BBA'),
(5, 'Evan', 'CSE');

INSERT INTO attendance (id, student_id, total_classes, attended_classes)
VALUES
(1, 1, 40, 38),
(2, 2, 40, 25),
(3, 3, 40, 28),
(4, 4, 40, 40),
(5, 5, 40, 20);


INSERT INTO performance (id, student_id, course, score)
VALUES
(1, 1, 'Database Systems', 85.5),
(2, 1, 'AI', 91.0),
(3, 2, 'Circuits', 60.0),
(4, 2, 'Physics', 48.0),
(5, 3, 'Database Systems', 55.0),
(6, 3, 'AI', 45.0),
(7, 4, 'Marketing', 88.0),
(8, 4, 'Finance', 92.0),
(9, 5, 'AI', 42.5),
(10, 5, 'Data Science', 49.0);


--  TASK 2: ASSIGNMENT QUERIES


-- Q1. Display all students' names, IDs, and departments.

SELECT student_id, name, department
FROM students;

-- Q2️.Calculate the attendance percentage for each student.

SELECT 
    s.student_id,
    s.name,
    (a.attended_classes * 100.0 / a.total_classes) AS attendance_percentage
FROM students s
JOIN attendance a ON s.student_id = a.student_id;

-- Q3️.Show students whose attendance percentage is below 75%.

SELECT 
    s.student_id,
    s.name,
    (a.attended_classes * 100.0 / a.total_classes) AS attendance_percentage
FROM students s
JOIN attendance a ON s.student_id = a.student_id
WHERE (a.attended_classes * 100.0 / a.total_classes) < 75;

-- Q4️.Find the average score of each student.

SELECT 
    s.student_id,
    s.name,
    AVG(p.score) AS average_score
FROM students s
JOIN performance p ON s.student_id = p.student_id
GROUP BY s.student_id, s.name;

-- Q5️.Display the names and courses of students who scored less than 50.

SELECT 
    s.name,
    p.course,
    p.score
FROM students s
JOIN performance p ON s.student_id = p.student_id
WHERE p.score < 50;

-- Q6️. List students who have attended all classes (100% attendance).

SELECT 
    s.student_id,
    s.name
FROM students s
JOIN attendance a ON s.student_id = a.student_id
WHERE a.attended_classes = a.total_classes;

-- Q7️.Find the top 3 students with the highest average scores.

SELECT 
    s.student_id,
    s.name,
    AVG(p.score) AS average_score
FROM students s
JOIN performance p ON s.student_id = p.student_id
GROUP BY s.student_id, s.name
ORDER BY average_score DESC
LIMIT 3;

-- Q8️.Display students in "CSE" department with average score above 80%.

SELECT 
    s.name,
    s.department,
    AVG(p.score) AS average_score
FROM students s
JOIN performance p ON s.student_id = p.student_id
WHERE s.department = 'CSE'
GROUP BY s.name, s.department
HAVING AVG(p.score) > 80;

-- Q9️.Show courses in which no student scored more than 90%.

SELECT DISTINCT course
FROM performance
GROUP BY course
HAVING MAX(score) <= 90;

-- Q10. Identify students who are 'at-risk' (attendance below 75% AND average score below 50%).

SELECT 
    s.student_id,
    s.name,
    (a.attended_classes * 100.0 / a.total_classes) AS attendance_percentage,
    AVG(p.score) AS average_score
FROM students s
JOIN attendance a ON s.student_id = a.student_id
JOIN performance p ON s.student_id = p.student_id
GROUP BY s.student_id, s.name, a.attended_classes, a.total_classes
HAVING (a.attended_classes * 100.0 / a.total_classes) < 75
   AND AVG(p.score) < 50;
