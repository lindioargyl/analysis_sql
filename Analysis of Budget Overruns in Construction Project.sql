SELECT * FROM construction.construction_project;

-- Budget Overrun for Each Project --
SELECT
	Project_ID,
	Project_Description,
	Budget_Cost,
	Actual_Cost,
	(Actual_Cost - Budget_Cost) AS Cost_Overrun
FROM construction.construction_project
;


-- Projects with Largest Budget Overrun --
SELECT
	Project_ID,
    Project_Description,
    (Actual_Cost - Budget_Cost) AS Cost_Overrun
FROM construction.construction_project
ORDER BY Cost_Overrun DESC
LIMIT 10
;


-- Average Overrun by County --
SELECT
	County,
    AVG(Actual_Cost - Budget_Cost) AS Avg_Cost_Overrun
FROM construction.construction_project
GROUP BY County
ORDER BY Avg_Cost_Overrun DESC
;


-- Total Overrun by County --
SELECT
	County,
    SUM(Actual_Cost - Budget_Cost) AS Total_Overrun
FROM construction.construction_project
GROUP BY County
ORDER BY Total_Overrun DESC
;


-- Project Duration for each project
SELECT
	Project_ID,
    TIMESTAMPDIFF(MONTH, Start_Date, End_Date) AS Project_Duration,
    Actual_Cost,
    Budget_Cost,
    (Actual_Cost - Budget_Cost) AS Cost_Overrun
FROM construction.construction_project
LIMIT 1000
;

    
-- Monthly budget overrun trend --
SELECT
	MONTH(Start_Date) AS Start_Month,
    SUM(Actual_Cost - Budget_Cost) AS Monthly_Overrun
From construction.construction_project
GROUP BY Start_Month
ORDER BY Start_Month
;

SELECT
    YEAR(End_Date) AS Year,
    MONTH(End_Date) AS Month,
    SUM(Actual_Cost - Budget_Cost) AS Total_Budget_Overrun
FROM
    construction.construction_project
WHERE
    End_Date IS NOT NULL
GROUP BY
    YEAR(End_Date), MONTH(End_Date)
ORDER BY
    YEAR(End_Date) DESC, MONTH(End_Date) DESC;
