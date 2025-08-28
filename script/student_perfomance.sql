-- use the database
USE student_database;

-- drop table if already exists
DROP TABLE IF EXISTS student_performance;

-- create the table with all necessary columns
CREATE TABLE student_performance (
    StudentID INT PRIMARY KEY,
    Age INT,
    Gender TINYINT,        
    Ethnicity TINYINT,         
    ParentalEducation TINYINT,
    StudyTimeWeekly INT,     
    Absences INT,            
    Tutoring TINYINT,          
    ParentalSupport TINYINT,   
    Extracurricular TINYINT, 
    Sports TINYINT,          
    Music TINYINT,             
    Volunteering TINYINT,       
    GPA FLOAT,                   
    GradeClass TINYINT           
);

-- load CSV data into the table
LOAD DATA LOCAL INFILE '/home/makhoe_7/projects/DataAnalysis/StudentPerformanceAnalysis/dataset/synthetic_student_performance.csv'
INTO TABLE student_performance
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(StudentID, Age, Gender, Ethnicity, ParentalEducation, StudyTimeWeekly, Absences, Tutoring, 
 ParentalSupport, Extracurricular, Sports, Music, Volunteering, GPA, GradeClass);

 -- data testing
SELECT COUNT(*) FROM student_performance;


-- student grade level distribution
SELECT GradeClass, COUNT(*) AS NumberOfStudents
FROM student_performance
GROUP BY GradeClass
ORDER BY GradeClass;

-- Gender distribution
SELECT Gender, COUNT(*) AS GenderDistribution
FROM student_performance
GROUP BY Gender
ORDER BY GENDER;


-- Percentage of students participating in each activity
SELECT
    ROUND(AVG(Sports) * 100, 2) AS Sports_Percentage,
    ROUND(AVG(Music) * 100, 2) AS Music_Percentage,
    ROUND(AVG(Volunteering) * 100, 2) AS Volunteering_Percentage
FROM student_performance;

-- What percentage participate in Extracurricular activities?
SELECT 
    'Music' AS Activity,
    ROUND(AVG(Music) * 100, 2) AS ParticipationPercentage
FROM student_performance
UNION ALL
SELECT 
    'Sports' AS Activity,
    ROUND(AVG(Sports) * 100, 2) AS ParticipationPercentage
FROM student_performance
UNION ALL
SELECT 
    'Volunteering' AS Activity,
    ROUND(AVG(Volunteering) * 100, 2) AS ParticipationPercentage
FROM student_performance;


-- How does GPA differ between students in sports vs non-sports?
SELECT 
    Sports AS ParticipatesInSports,
    COUNT(*) AS StudentCount,
    ROUND(AVG(GPA), 2) AS AverageGPA
FROM student_performance
GROUP BY Sports
ORDER BY Sports;


-- How does GPA differ between students in music vs non-music?
SELECT 
    Music AS ParticipatesInMusic,
    COUNT(*) AS StudentCount,
    ROUND(AVG(GPA), 2) AS AverageGPA
FROM student_performance
GROUP BY Music
ORDER BY Music;

-- How does GPA differ for students who volunteer vs those who don’t?
SELECT
    Volunteering AS VolunteeringParticipants,
    COUNT(*) AS StudentCount,
    ROUND(AVG(GPA), 2) AS AverageGPA
FROM student_performance
GROUP BY Volunteering
ORDER BY Volunteering;

-- Do students involved in multiple activities have higher GPAs?
SELECT 
    (Music + Sports + Volunteering) AS TotalActivities,
    COUNT(*) AS StudentCount,
    ROUND(AVG(GPA), 2) AS AverageGPA
FROM student_performance
GROUP BY TotalActivities
ORDER BY TotalActivities;

--  Are boys or girls more active in extracurriculars?
SELECT
    Gender,
    Sports AS ParticipatesInSports,
    COUNT(*) AS StudentCount
FROM student_performance
GROUP BY Gender, Sports
ORDER BY Gender, Sports;

-- Which grade levels participate most in extracurriculars?
SELECT
    GradeClass,
    SUM(Music) AS MusicParticipants,
    SUM(Sports) AS SportsParticipants,
    SUM(Volunteering) AS VolunteeringParticipants
FROM student_performance
GROUP BY GradeClass
ORDER BY GradeClass;

-- Do students in extracurriculars have fewer absences on average?
SELECT 
    'Music' AS Activity,
    Music AS Participates,
    COUNT(*) AS StudentCount,
    ROUND(AVG(Absences), 2) AS AvgAbsences
FROM student_performance
GROUP BY Music
UNION ALL
SELECT 
    'Sports' AS Activity,
    Sports AS Participates,
    COUNT(*) AS StudentCount,
    ROUND(AVG(Absences), 2) AS AvgAbsences
FROM student_performance
GROUP BY Sports
UNION ALL
SELECT 
    'Volunteering' AS Activity,
    Volunteering AS Participates,
    COUNT(*) AS StudentCount,
    ROUND(AVG(Absences), 2) AS AvgAbsences
FROM student_performance
GROUP BY Volunteering;

-- Do students receiving tutoring have higher GPAs?
SELECT 
    Tutoring AS ReceivingTutoring,
    COUNT(*) AS StudentCount,
    ROUND(AVG(GPA), 2) AS AvgGPA
FROM student_performance
GROUP BY Tutoring
ORDER BY Tutoring;

-- Do students with parental support have higher GPAs?
SELECT 
    ParentalSupport AS SupportLevel,
    COUNT(*) AS StudentCount,
    ROUND(AVG(GPA), 2) AS AvgGPA
FROM student_performance
GROUP BY ParentalSupport
ORDER BY ParentalSupport;

-- # How does tutoring affect students with low study time?
SELECT 
    Tutoring AS ReceivingTutoring,
    COUNT(*) AS StudentCount,
    ROUND(AVG(GPA), 2) AS AvgGPA
FROM student_performance
WHERE StudyTimeWeekly = 0
GROUP BY Tutoring
ORDER BY Tutoring;

-- Does tutoring reduce absence
SELECT 
    Tutoring AS ReceivingTutoring,
    COUNT(*) AS StudentCount,
    ROUND(AVG(Absences), 2) AS AvgAbsences
FROM student_performance
GROUP BY Tutoring
ORDER BY Tutoring;

-- How does parental education influence parental support?
SELECT 
    ParentalSupport AS SupportLevel,
    ParentalEducation AS EducationLevel,
    COUNT(*) AS StudentCount
FROM student_performance
GROUP BY ParentalSupport, ParentalEducation
ORDER BY ParentalSupport, ParentalEducation;

-- Are there gender differences in receiving tutoring?
SELECT 
    GradeClass,
    Gender,
    Tutoring,
    COUNT(*) AS StudentCount
FROM student_performance
GROUP BY GradeClass, Gender, Tutoring
ORDER BY GradeClass, Gender, Tutoring;


-- Are there ethnicity differences in parental support?
SELECT 
    GradeClass,
    Ethnicity,
    ParentalSupport AS SupportLevel,
    COUNT(*) AS StudentCount
FROM student_performance
GROUP BY GradeClass, Ethnicity, ParentalSupport
ORDER BY GradeClass, Ethnicity, ParentalSupport;

-- Does tutoring impact GPA differently across grade levels?
SELECT 
    GradeClass,
    Tutoring AS ReceivingTutoring,
    COUNT(*) AS StudentCount,
    ROUND(AVG(GPA), 2) AS AvgGPA
FROM student_performance
GROUP BY GradeClass, Tutoring
ORDER BY GradeClass, Tutoring;

-- How does high parental support correlate with GPA improvement? 
SELECT 
    ParentalSupport AS SupportLevel,
    COUNT(*) AS StudentCount,
    ROUND(AVG(GPA), 2) AS AvgGPA
FROM student_performance
GROUP BY ParentalSupport
ORDER BY ParentalSupport;

-- Do students with tutoring show better study time habits
SELECT 
    Tutoring AS ReceivingTutoring,
    COUNT(*) AS StudentCount,
    ROUND(AVG(StudyTimeWeekly), 2) AS AvgStudyTime
FROM student_performance
GROUP BY Tutoring
ORDER BY Tutoring;

--  Do students with both tutoring and parental support perform best?
SELECT 
    ParentalSupport AS SupportLevel,
    Tutoring AS ReceivingTutoring,
    COUNT(*) AS StudentCount,
    ROUND(AVG(GPA), 2) AS AvgGPA
FROM student_performance
GROUP BY ParentalSupport, Tutoring
ORDER BY ParentalSupport, Tutoring;


-- Parental Support × Sports,Parental Support × Tutoring, Sports × Tutoring
SELECT 
    'Support+Sports' AS ComparisonType,
    ParentalSupport AS SupportLevel,
    Sports AS SportsParticipation,
    NULL AS TutoringStatus,
    COUNT(*) AS StudentCount,
    ROUND(AVG(GPA), 2) AS AvgGPA
FROM student_performance
GROUP BY ParentalSupport, Sports
UNION ALL
SELECT 
    'Sports+Tutoring' AS ComparisonType,
    NULL AS SupportLevel,
    Sports AS SportsParticipation,
    Tutoring AS TutoringStatus,
    COUNT(*) AS StudentCount,
    ROUND(AVG(GPA), 2) AS AvgGPA
FROM student_performance
GROUP BY Sports, Tutoring

UNION ALL
SELECT 
    'Support+Tutoring' AS ComparisonType,
    ParentalSupport AS SupportLevel,
    NULL AS SportsParticipation,
    Tutoring AS TutoringStatus,
    COUNT(*) AS StudentCount,
    ROUND(AVG(GPA), 2) AS AvgGPA
FROM student_performance
GROUP BY ParentalSupport, Tutoring;

-- Does combining tutoring, parental support, and extracurriculars maximize GPA?
SELECT 
    (Music + Sports + Volunteering) AS NumExtracurriculars,
    Tutoring AS ReceivingTutoring,
    COUNT(*) AS StudentCount,
    ROUND(AVG(GPA), 2) AS AvgGPA
FROM student_performance
GROUP BY (Music + Sports + Volunteering), Tutoring
ORDER BY NumExtracurriculars, ReceivingTutoring;

-- Does parental support boost the benefits of extracurricular participation?
SELECT 
    ParentalSupport AS SupportLevel,
    (Music + Sports + Volunteering) AS NumExtracurriculars,
    COUNT(*) AS StudentCount,
    ROUND(AVG(GPA), 2) AS AvgGPA
FROM student_performance
GROUP BY ParentalSupport, (Music + Sports + Volunteering)
ORDER BY ParentalSupport, NumExtracurriculars;

-- How does study time contribute when tutoring and activities are combined?
SELECT 
    StudyTimeWeekly,
    Tutoring AS ReceivingTutoring,
    (Music + Sports + Volunteering) AS TotalActivities,
    COUNT(*) AS StudentCount,
    ROUND(AVG(GPA), 2) AS AvgGPA
FROM student_performance
GROUP BY StudyTimeWeekly, Tutoring, (Music + Sports + Volunteering)
ORDER BY StudyTimeWeekly, TotalActivities, ReceivingTutoring;

-- Are students with no support or no extracurricular involvement at a GPA disadvantage?
SELECT 
    (Music + Sports + Volunteering) AS TotalActivities,
    ParentalSupport,
    COUNT(*) AS StudentCount,
    ROUND(AVG(GPA), 2) AS AvgGPA
FROM student_performance
GROUP BY TotalActivities, ParentalSupport
ORDER BY TotalActivities, ParentalSupport;
