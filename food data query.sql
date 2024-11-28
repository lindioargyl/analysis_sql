-- STUDY OF FOOD PREFERENCES AND LIFESTYLE ATTRIBUTES OF COLLEGE STUDENTS -- 

-- number of students who are employed and unemployed
-- for freshman
SELECT COUNT(*) AS freshman_part_time_count
FROM food.food_choices_prod
WHERE grade_level = 'Freshman' AND employment = 'Part time';

SELECT COUNT(*) AS freshman_full_time_count
FROM food.food_choices_prod
WHERE grade_level = 'Freshman' AND employment = 'Full time';

SELECT COUNT(*) AS freshman_unemployed_count
FROM food.food_choices_prod
WHERE grade_level = 'Freshman' AND employment = 'Unemployed';

-- for sophomore
SELECT COUNT(*) AS sophomore_part_time_count
FROM food.food_choices_prod
WHERE grade_level = 'Sophomore' AND employment = 'Part time';

SELECT COUNT(*) AS sophomore_full_time_count
FROM food.food_choices_prod
WHERE grade_level = 'Sophomore' AND employment = 'Full time';

SELECT COUNT(*) AS sophomore_unemployed_count
FROM food.food_choices_prod
WHERE grade_level = 'Sophomore' AND employment = 'Unemployed';

-- for junior
SELECT COUNT(*) AS junior_part_time_count
FROM food.food_choices_prod
WHERE grade_level = 'Junior' AND employment = 'Part time';

SELECT COUNT(*) AS junior_full_time_count
FROM food.food_choices_prod
WHERE grade_level = 'Junior' AND employment = 'Full time';

SELECT COUNT(*) AS junior_unemployed_count
FROM food.food_choices_prod
WHERE grade_level = 'Junior' AND employment = 'Unemployed';

-- for senior
SELECT COUNT(*) AS senior_part_time_count
FROM food.food_choices_prod
WHERE grade_level = 'Senior' AND employment = 'Part time';

SELECT COUNT(*) AS senior_full_time_count
FROM food.food_choices_prod
WHERE grade_level = 'Senior' AND employment = 'Full time';

SELECT COUNT(*) AS senior_unemployed_count
FROM food.food_choices_prod
WHERE grade_level = 'Senior' AND employment = 'Unemployed';

SELECT 
    employment AS employment_status, 
    income AS income_level, 
    COUNT(*) AS student_count
FROM 
    food.food_choices_prod
WHERE 
    employment IS NOT NULL 
    AND income IS NOT NULL
GROUP BY 
    employment, income
ORDER BY 
    employment, income;


-- number of total students 
SELECT 
    COUNT(*) AS total_students
FROM food.food_choices_prod;
    
SELECT 
    grade_level, 
    COUNT(*) AS student_count
FROM food.food_choices_prod
GROUP BY 
    grade_level;
    

-- percentage of students whose eating habits change once they enter college
SELECT 
    eating_habit_changes, 
    COUNT(*) AS student_count,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM food.food_choices_prod)), 2) AS percentage
FROM 
    food.food_choices_prod
WHERE 
    eating_habit_changes IS NOT NULL
GROUP BY 
    eating_habit_changes;

SELECT 
    eating_habit_changes, 
    COUNT(*) AS student_count,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM food.food_choices_prod)), 2) AS percentage
FROM 
    food.food_choices_prod
WHERE 
    eating_habit_changes IS NOT NULL
GROUP BY 
    eating_habit_changes;
    
    
-- patterns of change in eating habits percentage
SELECT 
    eating_changes, 
    COUNT(*) AS student_count,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM food.food_choices_prod)), 2) AS percentage
FROM 
    food.food_choices_prod
WHERE 
    eating_changes IS NOT NULL
GROUP BY 
    eating_changes;
    
    
-- living situations of college students
SELECT 
    living_situation, 
    COUNT(*) AS student_count,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM food.food_choices_prod)), 2) AS percentage
FROM 
    food.food_choices_prod
WHERE 
    living_situation IS NOT NULL
GROUP BY 
    living_situation;
    
    
-- weekly exercise frequency among college students
SELECT 
    exercise, 
    COUNT(*) AS student_count,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM food.food_choices_prod)), 2) AS percentage
FROM 
    food.food_choices_prod
WHERE 
    exercise IS NOT NULL
GROUP BY 
    exercise;
    

-- comfort food choices and their motivations
SELECT comfort_food1 AS comfort_food, comfort_food_reasons
FROM food.food_choices_prod
WHERE comfort_food1 IS NOT NULL
UNION ALL
SELECT comfort_food2 AS comfort_food, comfort_food_reasons
FROM food.food_choices_prod
WHERE comfort_food2 IS NOT NULL
UNION ALL
SELECT comfort_food3 AS comfort_food, comfort_food_reasons
FROM food.food_choices_prod
WHERE comfort_food3 IS NOT NULL;

SELECT
    comfort_food AS comfort_food,
    COUNT(*) AS mention_count,
    GROUP_CONCAT(DISTINCT comfort_food_reasons) AS motivations
FROM (
    SELECT comfort_food1 AS comfort_food, comfort_food_reasons
    FROM food.food_choices_prod
    WHERE comfort_food1 IS NOT NULL
    UNION ALL
    SELECT comfort_food2 AS comfort_food, comfort_food_reasons
    FROM food.food_choices_prod
    WHERE comfort_food2 IS NOT NULL
    UNION ALL
    SELECT comfort_food3 AS comfort_food, comfort_food_reasons
    FROM food.food_choices_prod
    WHERE comfort_food3 IS NOT NULL
) combined_foods
GROUP BY comfort_food
ORDER BY mention_count DESC
LIMIT 3;

SELECT
    comfort_food_reasons AS reason,
    COUNT(*) AS reason_count,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM food.food_choices_prod WHERE comfort_food_reasons IS NOT NULL)), 2) AS percentage
FROM food.food_choices_prod
WHERE comfort_food_reasons IS NOT NULL
GROUP BY comfort_food_reasons
ORDER BY reason_count DESC
LIMIT 3;


-- students earning or income
SELECT 
    income, 
    COUNT(*) AS student_count, 
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM food.food_choices_prod WHERE income IS NOT NULL)), 2) AS percentage
FROM 
    food.food_choices_prod
WHERE 
    income IS NOT NULL
GROUP BY 
    income
ORDER BY 
    student_count DESC;
    

-- number of students who have sports and who do not
SELECT 
    sports, 
    COUNT(*) AS student_count
FROM 
    food.food_choices_prod
WHERE 
    sports IN ('Yes', 'No')
GROUP BY 
    sports;
    
 -- types of sports students are engaged in 
USE food;
CREATE TEMPORARY TABLE split_sports AS
SELECT
    entry,
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(type_sports, ',', n.n), ',', -1)) AS sport
FROM food.food_choices_prod
JOIN (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 
      UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8) n
ON CHAR_LENGTH(type_sports) - CHAR_LENGTH(REPLACE(type_sports, ',', '')) >= n - 1
WHERE type_sports IS NOT NULL;

SELECT 
    sport, 
    COUNT(*) AS mention_count
FROM split_sports
GROUP BY sport
ORDER BY mention_count DESC
LIMIT 40;


-- students who take vitamins
SELECT 
    vitamins, 
    COUNT(*) AS student_count,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM food.food_choices_prod)), 2) AS percentage
FROM 
    food.food_choices_prod
WHERE 
    vitamins IN ('Yes', 'No')
GROUP BY 
    vitamins;


-- identifying the number of students with a healthy, unhealthy, or the same diet
SELECT 
    current_diet, 
    COUNT(*) AS student_count,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM food.food_choices_prod)), 2) AS percentage
FROM 
    food.food_choices_prod
WHERE 
    current_diet IS NOT NULL
GROUP BY 
    current_diet;
    
    
-- ideal diet for college students
SELECT 
    ideal_diet, 
    COUNT(*) AS student_count,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM food.food_choices_prod)), 2) AS percentage
FROM 
    food.food_choices_prod
WHERE 
    ideal_diet IS NOT NULL
GROUP BY 
    ideal_diet;    


-- weekly cooking frequency of college students
SELECT 
    cook, 
    COUNT(*) AS student_count,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM food.food_choices_prod)), 2) AS percentage
FROM 
    food.food_choices_prod
WHERE 
    cook IS NOT NULL
GROUP BY 
    cook; 
    

-- weekly frequency of eating out among college students
SELECT 
    eating_out, 
    COUNT(*) AS student_count,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM food.food_choices_prod)), 2) AS percentage
FROM 
    food.food_choices_prod
WHERE 
    eating_out IS NOT NULL
GROUP BY 
    eating_out; 


-- weekly frequency of college students eating out
SELECT 
    eating_out, 
    COUNT(*) AS student_count,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM food.food_choices_prod)), 2) AS percentage
FROM 
    food.food_choices_prod
WHERE 
    eating_out IS NOT NULL
GROUP BY 
    eating_out; 


-- the amount college students are willing to spend on a meal out
SELECT 
    pay_meal_out, 
    COUNT(*) AS student_count,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM food.food_choices_prod)), 2) AS percentage
FROM 
    food.food_choices_prod
WHERE 
    pay_meal_out IS NOT NULL
GROUP BY 
    pay_meal_out; 


-- favorite cuisine among college students
SELECT 
    fav_cuisine, 
    COUNT(*) AS student_count,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM food.food_choices_prod)), 2) AS percentage
FROM 
    food.food_choices_prod
WHERE 
    fav_cuisine IS NOT NULL
GROUP BY 
    fav_cuisine; 


-- college students who prefer home-cooked meals or store-bought food
SELECT 
    fav_food, 
    COUNT(*) AS student_count,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM food.food_choices_prod)), 2) AS percentage
FROM 
    food.food_choices_prod
WHERE 
    fav_food IS NOT NULL
GROUP BY 
    fav_food;
    
    
-- frequency of college students checking nutritional values
SELECT 
    nutritional_check, 
    COUNT(*) AS student_count,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM food.food_choices_prod)), 2) AS percentage
FROM 
    food.food_choices_prod
WHERE 
    nutritional_check IS NOT NULL
GROUP BY 
    nutritional_check;
    

-- food preferences of college students
-- for soup 
SELECT 
    soup, 
    COUNT(*) AS student_count,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM food.food_choices_prod)), 2) AS percentage
FROM 
    food.food_choices_prod
WHERE 
    soup IS NOT NULL
GROUP BY 
    soup;
    
-- for fries
SELECT 
    fries, 
    COUNT(*) AS student_count,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM food.food_choices_prod)), 2) AS percentage
FROM 
    food.food_choices_prod
WHERE 
    fries IS NOT NULL
GROUP BY 
    fries;

-- for drink
SELECT 
    drink, 
    COUNT(*) AS student_count,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM food.food_choices_prod)), 2) AS percentage
FROM 
    food.food_choices_prod
WHERE 
    drink IS NOT NULL
GROUP BY 
    drink;
    
-- for breakfast 
SELECT 
    breakfast, 
    COUNT(*) AS student_count,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM food.food_choices_prod)), 2) AS percentage
FROM 
    food.food_choices_prod
WHERE 
    breakfast IS NOT NULL
GROUP BY 
    breakfast;

-- for ethnic food
SELECT 
    ethnic_food, 
    COUNT(*) AS student_count,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM food.food_choices_prod)), 2) AS percentage
FROM 
    food.food_choices_prod
WHERE 
    ethnic_food IS NOT NULL
GROUP BY 
    ethnic_food;
    
-- college students' preferences for ethnic cuisines
-- for greek food
SELECT 
    greek_food, 
    COUNT(*) AS student_count,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM food.food_choices_prod)), 2) AS percentage
FROM 
    food.food_choices_prod
WHERE 
    greek_food IS NOT NULL
GROUP BY 
    greek_food;
    
-- for indian food
SELECT 
    indian_food, 
    COUNT(*) AS student_count,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM food.food_choices_prod)), 2) AS percentage
FROM 
    food.food_choices_prod
WHERE 
    indian_food IS NOT NULL
GROUP BY 
    indian_food;

-- for italian food
SELECT 
    italian_food, 
    COUNT(*) AS student_count,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM food.food_choices_prod)), 2) AS percentage
FROM 
    food.food_choices_prod
WHERE 
    italian_food IS NOT NULL
GROUP BY 
    italian_food;
    
-- for persian food
SELECT 
    persian_food, 
    COUNT(*) AS student_count,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM food.food_choices_prod)), 2) AS percentage
FROM 
    food.food_choices_prod
WHERE 
    persian_food IS NOT NULL
GROUP BY 
    persian_food;
    
-- for thai food
SELECT 
    thai_food, 
    COUNT(*) AS student_count,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM food.food_choices_prod)), 2) AS percentage
FROM 
    food.food_choices_prod
WHERE 
    thai_food IS NOT NULL
GROUP BY 
    thai_food;
    
-- comparison of the ethnic foods most preferred by college students
SELECT 
    food_type,
    SUM(CASE WHEN preference = 'Very Likely' THEN 1 ELSE 0 END) AS very_likely_count,
    SUM(CASE WHEN preference = 'Very Unlikely' THEN 1 ELSE 0 END) AS very_unlikely_count
FROM (
    SELECT 'Italian Food' AS food_type, italian_food AS preference
    FROM food.food_choices_prod
    UNION ALL
    SELECT 'Greek Food' AS food_type, greek_food AS preference
    FROM food.food_choices_prod
    UNION ALL
    SELECT 'Thai Food' AS food_type, thai_food AS preference
    FROM food.food_choices_prod
    UNION ALL
    SELECT 'Indian Food' AS food_type, indian_food AS preference
    FROM food.food_choices_prod
    UNION ALL
    SELECT 'Persian Food' AS food_type, persian_food AS preference
    FROM food.food_choices_prod
) combined_data
GROUP BY food_type
ORDER BY very_likely_count DESC, very_unlikely_count ASC
LIMIT 1000;

-- college students who are most likely to eat vegetables for a day
SELECT 
    veggies_day, 
    COUNT(*) AS student_count,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM food.food_choices_prod)), 2) AS percentage
FROM 
    food.food_choices_prod
WHERE 
    veggies_day IS NOT NULL
GROUP BY 
    veggies_day;

-- college students who are most likely to eat fruits for a day
SELECT
    fruit_day, 
    COUNT(*) AS student_count,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM food.food_choices_prod)), 2) AS percentage
FROM 
    food.food_choices_prod
WHERE 
    fruit_day IS NOT NULL
GROUP BY 
    fruit_day;
    
    
-- determining if employment status affects college students' current diet
SELECT 
    employment,
    SUM(CASE WHEN current_diet = 'Healthy' THEN 1 ELSE 0 END) AS healthy,
    SUM(CASE WHEN current_diet = 'Unhealthy' THEN 1 ELSE 0 END) AS unhealthy,
    SUM(CASE WHEN current_diet = 'Same thing' THEN 1 ELSE 0 END) AS the_same,
    SUM(CASE WHEN current_diet = 'Unclear' THEN 1 ELSE 0 END) AS unclear
FROM food.food_choices_prod
GROUP BY employment
ORDER BY employment;

-- determining whether college students' current diet has an effect on their GPA
SELECT 
    GPA,
    SUM(CASE WHEN current_diet = 'Healthy' THEN 1 ELSE 0 END) AS healthy,
    SUM(CASE WHEN current_diet = 'Unhealthy' THEN 1 ELSE 0 END) AS unhealthy,
    SUM(CASE WHEN current_diet = 'Same thing' THEN 1 ELSE 0 END) AS the_same,
    SUM(CASE WHEN current_diet = 'Unclear' THEN 1 ELSE 0 END) AS unclear
FROM food.food_choices_prod
GROUP BY GPA
ORDER BY GPA;

SELECT 
    ROUND(
        (SUM(CASE WHEN GPA BETWEEN 2.0 AND 4.0 AND current_diet = 'Healthy' THEN 1 ELSE 0 END) 
        / 
        COUNT(CASE WHEN GPA BETWEEN 2.0 AND 4.0 THEN 1 END)) * 100, 2
    ) AS healthy_percentage,
    ROUND(
        (SUM(CASE WHEN GPA BETWEEN 2.0 AND 4.0 AND current_diet = 'Unhealthy' THEN 1 ELSE 0 END) 
        / 
        COUNT(CASE WHEN GPA BETWEEN 2.0 AND 4.0 THEN 1 END)) * 100, 2
    ) AS unhealthy_percentage
FROM food.food_choices_prod
WHERE GPA BETWEEN 2.0 AND 4.0;


-- determining which gender, male or female, is healthier among college students
SELECT 
    gender,
    SUM(CASE WHEN current_diet = 'Healthy' THEN 1 ELSE 0 END) AS healthy,
    SUM(CASE WHEN current_diet = 'Unhealthy' THEN 1 ELSE 0 END) AS unhealthy,
    SUM(CASE WHEN current_diet = 'Same thing' THEN 1 ELSE 0 END) AS the_same,
    SUM(CASE WHEN current_diet = 'Unclear' THEN 1 ELSE 0 END) AS unclear
FROM food.food_choices_prod
GROUP BY gender
ORDER BY gender;


-- marital status of college students
SELECT 
    marital_status, 
    COUNT(*) AS student_count,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM food.food_choices_prod)), 2) AS percentage
FROM 
    food.food_choices_prod
WHERE 
    marital_status IS NOT NULL
GROUP BY 
    marital_status;






