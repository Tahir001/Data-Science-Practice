-- ++++++++++++++++++++
--  Q1
-- ++++++++++++++++++++
-- Write a query that shows all of the rows for which song_name is null. 
SELECT * 
  FROM tutorial.billboard_top_100_year_end
  WHERE song_name IS null;

-- ++++++++++++++++++++
--  Q2
-- ++++++++++++++++++++
-- Write a query that surfaces all rows for top-10 hits for which Ludacris is part of the Group. 
SELECT * 
  FROM tutorial.billboard_top_100_year_end
  WHERE "group" ilike '%Ludacris' AND year_rank <= 10

-- ++++++++++++++++++++
--  Q3 
-- ++++++++++++++++++++
-- Write a query that surfaces the top-ranked records in 1990, 2000, and 2010.   
SELECT * 
  FROM tutorial.billboard_top_100_year_end
  WHERE year in (1990, 2000, 2010) AND year_rank = 1;

-- ++++++++++++++++++++
--  Q4 
-- ++++++++++++++++++++
-- Write a query that lists all songs from the 1960s with "love" in the title. 
SELECT * 
  FROM tutorial.billboard_top_100_year_end
  WHERE year BETWEEN 1960 AND 1969 AND song_name ilike '%love%'

-- ++++++++++++++++++++
--  Q5 
-- ++++++++++++++++++++
-- Question 
-- Write a query that returns all rows for top-10 songs that featured either Katy Perry or Bon Jovi. 
SELECT * 
FROM tutorial.billboard_top_100_year_end
WHERE artist = 'Katy Perry' OR artist = 'Bon Jovi'

-- ++++++++++++++++++++
--  Q6
-- ++++++++++++++++++++
-- Question 
-- Write a query that returns all songs with titles that contain the word "California" in either the 1970s or 1990s. 
SELECT * 
FROM tutorial.billboard_top_100_year_end
WHERE song_name ilike '%California%' AND (year BETWEEN 1970 AND 1979 OR year BETWEEN 1990 and 1999)

-- ++++++++++++++++++++
--  Q7
-- ++++++++++++++++++++
-- Question 
-- Write a query that lists all top-100 recordings that feature Dr. Dre before 2001 or after 2009. 
SELECT * 
FROM tutorial.billboard_top_100_year_end
WHERE "group" like '%Dr. Dre%' AND (year <2001 OR year > 2009) 

-- ++++++++++++++++++++
--  Q8
-- ++++++++++++++++++++
-- Write a query that returns all rows for songs that were on the charts in 2013 and do not contain the letter "a".
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE year = 2013
AND "group" NOT ILIKE '%a%'

-- ++++++++++++++++++++
--  Q9
-- ++++++++++++++++++++
-- Write a query that returns all rows for songs that were on the charts in 2013 and do not contain the letter "a".
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE year = 2013
AND "group" NOT ILIKE '%a%'

-- ++++++++++++++++++++
--  Q10
-- ++++++++++++++++++++
-- Write a query that returns all rows for songs that were on the charts in 2013 and do not contain the letter "a".
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE year = 2013
AND "group" NOT ILIKE '%a%'


---------------------------- HEALTH DATABASE ANSWERS ----------------------------
-- ++++++++++++++++++++
--  Q2
-- ++++++++++++++++++++

SELECT DISTINCT P.FirstName, P.LastName, P.Gender, P.DateOfBirth
FROM Person P, Diagnose D
WHERE D.PatientID = P.ID
AND Disease LIKE '%Cancer%'
AND YEAR(CURDATE())-YEAR(P.DateOfBirth) <= 40
AND P.City = 'Toronto';

-- ++++++++++++++++++++
--  Q3.A
-- ++++++++++++++++++++

SELECT Specialty, AVG(Salary)
FROM Physician
GROUP BY Specialty;

-- ++++++++++++++++++++
--  Q3.B
-- ++++++++++++++++++++

SELECT Specialty, AVG(Salary)
FROM Physician P, Hospital H
WHERE P.HName = H.HName AND (H.City = 'Toronto' OR H.City = 'Hamilton')
GROUP BY Specialty
HAVING COUNT(PhysicianID) >= 5;

-- ++++++++++++++++++++
--  Q3.C
-- ++++++++++++++++++++

SELECT YearsOfPractice, AVG(Salary)
FROM Nurse
GROUP BY YearsOfPractice
ORDER BY YearsOfPractice DESC;

-- ++++++++++++++++++++
--  Q4
-- ++++++++++++++++++++

SELECT HName, COUNT(PatientID)
FROM Admission
WHERE Date BETWEEN '2017-08-05' AND '2017-08-10' GROUP BY HName;

-- ++++++++++++++++++++
--  Q5.A
-- ++++++++++++++++++++

SELECT DName
FROM Department
GROUP BY DName
HAVING COUNT(DName) = (SELECT DISTINCT COUNT(HName) FROM Hospital);

-- ++++++++++++++++++++
--  Q5.B
-- ++++++++++++++++++++

SELECT HName, DName
FROM (SELECT Physician.HName, Physician.DName, count(*) AS Num
    FROM Physician JOIN Nurse_Work
    ON Physician.DName = Nurse_Work.DName AND Physician.HName = Nurse_Work.HName GROUP BY Physician.HName, Physician.DName) AS T
WHERE T.Num = (SELECT MAX(Num) FROM (SELECT Physician.HName, Physician.DName, count(*) AS Num FROM Physician JOIN Nurse_Work ON Physician.DName = Nurse_Work.DName AND Physician.HName = Nurse_Work.HName GROUP BY Physician.HName, Physician.DName) AS T);

-- ++++++++++++++++++++
--  Q5.C
-- ++++++++++++++++++++

SELECT DName
FROM Department
GROUP BY DName
HAVING COUNT(DName) = 1;

-- ++++++++++++++++++++
--  Q6.A
-- ++++++++++++++++++++

SELECT FirstName, LastName
FROM Person P, (SELECT NurseID, COUNT(PatientID) FROM Patient GROUP BY NurseID HAVING COUNT(PatientID) < 3) AS T
WHERE T.NurseID = P.ID ORDER BY LastName;

-- ++++++++++++++++++++
--  Q6.B
-- ++++++++++++++++++++

SELECT FirstName, LastName
FROM Patient P, Diagnose D, Person B
WHERE B.ID = P.PatientID AND P.PatientID = D.PatientID AND D.Prognosis = 'poor' AND P.NurseID IN (SELECT NurseID
                  FROM (SELECT NurseID, COUNT(PatientID)
                        FROM Patient GROUP BY NurseID HAVING COUNT(PatientID) < 3) AS T1);
                        
-- ++++++++++++++++++++
--  Q7
-- ++++++++++++++++++++

SELECT Date
FROM (SELECT Date, COUNT(PatientID) AS Num
      FROM Admission
      WHERE HName = 'Hamilton General Hospital'
      GROUP BY Date) AS T
WHERE T.Num = (SELECT MAX(Num)
               FROM (SELECT Date, COUNT(PatientID) AS Num
                     FROM Admission
                     WHERE HName = 'Hamilton General Hospital' GROUP BY Date) AS T1);
-- ++++++++++++++++++++
--  Q8
-- ++++++++++++++++++++

SELECT DrugCode, Name, T.Sum AS TotalSales
FROM (SELECT D.DrugCode, D.Name, SUM(UnitCost) AS Sum
      FROM Drug D, Prescription P
      WHERE D.DrugCode = P.DrugCode
      GROUP BY D.DrugCode) AS T
WHERE T.Sum = (SELECT MAX(Sum)
               FROM (SELECT D.DrugCode, SUM(UnitCost) AS Sum 
                     FROM Drug D, Prescription P
                     WHERE D.DrugCode = P.DrugCode
                     GROUP BY D.DrugCode) AS T1);
                     
-- ++++++++++++++++++++
--  Q9
-- ++++++++++++++++++++

SELECT DISTINCT P.ID, FirstName, LastName, Gender
FROM Person P, Diagnose D, Take T, MedicalTest M
WHERE P.ID = D.PatientID AND T.PatientID = D.PatientID AND M.TestID = T.TestID AND D.Disease = 'Diabetes' AND M.Name <> 'Lymphocytes' AND M.Name <> 'Red Blood Cell';

-- ++++++++++++++++++++
--  Q10.A
-- ++++++++++++++++++++

SELECT DISTINCT D.Disease, D.Prognosis
FROM Physician P, Diagnose D
WHERE P.HName = 'University of Toronto Medical Centre' AND P.DName = 'Intensive Care Unit' AND P.PhysicianID = D.PhysicianID;

-- ++++++++++++++++++++
--  Q10.B
-- ++++++++++++++++++++

SELECT P.PatientID, SUM(Fee)
FROM Patient P, MedicalTest M, Take T
WHERE P.PatientID = T.PatientID AND T.TestID = M.TestID AND (P.PatientID IN (SELECT DISTINCT D.PatientID FROM Physician P, Diagnose D WHERE P.HName = 'University of Toronto Medical Centre' AND P.DName = 'Intensive Care Unit' AND P.PhysicianID = D.PhysicianID))
GROUP BY PatientID;

-- ++++++++++++++++++++
--  Q10.C
-- ++++++++++++++++++++

SELECT PatientID, SUM(UnitCost) AS TotalCost
FROM Prescription P, Drug D WHERE P.DrugCode = D.DrugCode AND (PatientID IN (SELECT DISTINCT D.PatientID FROM Physician P, Diagnose D WHERE P.HName = 'University of Toronto Medical Centre' AND P.DName = 'Intensive Care Unit' AND P.PhysicianID = D.PhysicianID))
GROUP BY PatientID
ORDER BY TotalCost DESC;

-- ++++++++++++++++++++
--  Q11
-- ++++++++++++++++++++

SELECT P.ID, P.FirstName, P.LastName
FROM Person P, Patient B, Admission A WHERE P.ID = B.PatientID AND A.PatientID = B.PatientID AND (A.Category = "urgent" OR A.Category = "standard")
GROUP BY P.ID
HAVING COUNT(HName) = 2;

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- END
