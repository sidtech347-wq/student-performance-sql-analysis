-- STUDENT PERFORMANCE ANALYSIS PROJECT

-- 1. Create Database
CREATE DATABASE Student_performance_analysis;
USE student_performance_analysis;

-- 3. Basic Data Exploration
-- View first rows
SELECT *
FROM studentsperformance
LIMIT 10;

-- Total students
SELECT COUNT(*) AS total_students
FROM studentsperformance;

-- 4. Check Missing Values
SELECT 
SUM(`gender` IS NULL) AS gender_missing,
SUM(`race/ethnicity` IS NULL) AS race_missing,
SUM(`parental level of education` IS NULL) AS education_missing,
SUM(`lunch` IS NULL) AS lunch_missing,
SUM(`test preparation course` IS NULL) AS prep_missing,
SUM(`math score` IS NULL) AS math_missing,
SUM(`reading score` IS NULL) AS reading_missing,
SUM(`writing score` IS NULL) AS writing_missing
FROM studentsperformance;

-- 5. Create Average Score Column
SELECT *,
(`math score` + `reading score` + `writing score`)/3 AS avg_score
FROM studentsperformance;

-- 6. Subject Performance Statistics
SELECT
AVG(`math score`) AS avg_math,
MAX(`math score`) AS max_math,
MIN(`math score`) AS min_math,
AVG(`reading score`) AS avg_reading,
AVG(`writing score`) AS avg_writing
FROM studentsperformance;

-- 7. Gender Performance Comparison
SELECT
gender,
AVG(`math score`) AS avg_math,
AVG(`reading score`) AS avg_reading,
AVG(`writing score`) AS avg_writing
FROM studentsperformance
GROUP BY gender;

-- 8. Test Preparation Impact
SELECT
`test preparation course`,
AVG(`math score`) AS avg_math,
AVG(`reading score`) AS avg_reading,
AVG(`writing score`) AS avg_writing
FROM studentsperformance
GROUP BY `test preparation course`;

-- 9. Lunch Type Impact
SELECT
lunch,
AVG(`math score`) AS avg_math,
AVG(`reading score`) AS avg_reading,
AVG(`writing score`) AS avg_writing
FROM studentsperformance
GROUP BY lunch;

-- 10. Parental Education Impact
SELECT
`parental level of education`,
AVG(`math score`) AS avg_math
FROM studentsperformance
GROUP BY `parental level of education`
ORDER BY avg_math DESC;

-- 11. Top Performing Students
SELECT *,
(`math score` + `reading score` + `writing score`) / 3 AS avg_score
FROM studentsperformance
ORDER BY avg_score DESC
LIMIT 10;

-- 12. Students Above Average
SELECT *
FROM studentsperformance
WHERE `math score` > (SELECT AVG(`math score`) FROM studentsperformance);

-- 13. High Achievers
SELECT *
FROM studentsperformance
WHERE `math score` > 90
AND `reading score` > 90
AND `writing score` > 90;

-- 14. Performance Classification
SELECT
CASE
WHEN `math score` >= 90 THEN 'Excellent'
WHEN `math score` >= 70 THEN 'Good'
WHEN `math score` >= 50 THEN 'Average'
ELSE 'Low'
END AS performance_level,
COUNT(*) AS student_count
FROM studentsperformance
GROUP BY performance_level;

-- 15. Window Function (Ranking Students)
SELECT *,
(`math score` + `reading score` + `writing score`) / 3 AS avg_score,
RANK() OVER (ORDER BY (`math score` + `reading score` + `writing score`) / 3 DESC) AS student_rank
FROM studentsperformance;

-- 16. Top Student in Each Gender
SELECT *
FROM (
    SELECT *,
    (`math score` + `reading score` + `writing score`) / 3 AS avg_score,
    RANK() OVER (PARTITION BY gender ORDER BY (`math score` + `reading score` + `writing score`) / 3 DESC) AS rank_gender
    FROM studentsperformance
) ranked
WHERE rank_gender = 1;

-- 17. Ethnicity Group Performance
SELECT
`race/ethnicity`,
AVG(`math score`) AS avg_math,
AVG(`reading score`) AS avg_reading,
AVG(`writing score`) AS avg_writing
FROM studentsperformance
GROUP BY `race/ethnicity`;

-- 18. Students At Academic Risk
SELECT *
FROM studentsperformance
WHERE `math score` < 40
OR `reading score` < 40
OR `writing score` < 40;

-- 19. Subject Comparison
SELECT 'Math' AS subject, AVG(`math score`) AS avg_score
FROM studentsperformance
UNION
SELECT 'Reading', AVG(`reading score`)
FROM studentsperformance
UNION
SELECT 'Writing', AVG(`writing score`)
FROM studentsperformance;

-- 20. Create View for High Performers
CREATE VIEW high_performers AS
SELECT *,
(`math score` + `reading score` + `writing score`) / 3 AS avg_score
FROM studentsperformance
WHERE (`math score` + `reading score` + `writing score`) / 3 > 85;

SELECT * FROM high_performers;