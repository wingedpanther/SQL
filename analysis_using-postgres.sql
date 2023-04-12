-- DATA: https://www.kaggle.com/heesoo37/120-years-of-olympic-history-athletes-and-results/download
-- CREATE TABLE IF NOT EXISTS OLYMPICS_HISTORY
-- (
--     id          INT,
--     name        VARCHAR,
--     sex         VARCHAR,
--     age         VARCHAR,
--     height      VARCHAR,
--     weight      VARCHAR,
--     team        VARCHAR,
--     noc         VARCHAR,
--     games       VARCHAR,
--     year        INT,
--     season      VARCHAR,
--     city        VARCHAR,
--     sport       VARCHAR,
--     event       VARCHAR,
--     medal       VARCHAR
-- );

-- copy downloaded data : 
-- COPY olympics_history FROM 'path/to/csv/file.csv' DELIMITER ',' CSV HEADER;


-- Done!! 


-- Data Cleaning

-- Check for missing values
SELECT COUNT(*) 
FROM OLYMPICS_HISTORY 
WHERE id IS NULL OR name IS NULL OR sex IS NULL OR age IS NULL 
    OR height IS NULL OR weight IS NULL OR team IS NULL 
    OR noc IS NULL OR games IS NULL OR year IS NULL 
    OR season IS NULL OR city IS NULL OR sport IS NULL 
    OR event IS NULL OR medal IS NULL;

-- Check for duplicates
SELECT COUNT(*) duplicate_rows
FROM (
    SELECT id, name, sex, age, height, weight, team, noc, games, year, season, city, sport, event, medal, 
        ROW_NUMBER() OVER (PARTITION BY id, name, sex, age, height, weight, team, noc, games, year, season, city, sport, event, medal ORDER BY id) AS rn
    FROM OLYMPICS_HISTORY
) sub
WHERE rn > 1;


-- Remove duplicates

DELETE FROM OLYMPICS_HISTORY 
WHERE id IN (
    SELECT id
    FROM (
        SELECT id, name, sex, age, height, weight, team, noc, games, year, season, city, sport, event, medal, 
            ROW_NUMBER() OVER (PARTITION BY id, name, sex, age, height, weight, team, noc, games, year, season, city, sport, event, medal ORDER BY id) AS rn
        FROM OLYMPICS_HISTORY
    ) sub
    WHERE rn > 1
);

-- Exploring the data
-- total number of athletes who participated in each Olympics game
SELECT games, COUNT(DISTINCT id) AS num_athletes
FROM OLYMPICS_HISTORY
GROUP BY games
ORDER BY games;

-- total number of medals won by each country

SELECT noc, COUNT(medal) AS num_medals
FROM OLYMPICS_HISTORY
WHERE medal IS NOT NULL
GROUP BY noc
ORDER BY num_medals DESC limit 10;

-- Stats
-- Find the average age of male and female athletes
SELECT sex, round(AVG(age::int)) AS avg_age
FROM OLYMPICS_HISTORY
where age <> 'NA'
GROUP BY sex;

-- Find the standard deviation of height and weight
SELECT STDDEV(height::numeric) AS sd_height, STDDEV(weight::numeric) AS sd_weight
FROM OLYMPICS_HISTORY
where height <> 'NA' and weight <> 'NA';

-- Data Viz(Use Metabase or similar tool to Visualize the data)
-- 	Athelets Age
SELECT age, COUNT(*) AS num_athletes
FROM OLYMPICS_HISTORY
WHERE age IS NOT NULL
GROUP BY age
ORDER BY age;

SELECT height, weight
FROM OLYMPICS_HISTORY
WHERE height IS NOT NULL AND weight IS NOT NULL;


-- Hypothesis Analysis
-- Test if there is a significant difference in the average age of medalists and non-medalists

SELECT medal, round(AVG(age::int)) AS avg_age, COUNT(*) AS num_athletes
FROM OLYMPICS_HISTORY
WHERE age IS NOT NULL and age <> 'NA'
GROUP BY medal;

-- Test if there is a significant difference in the average height of male and female athletes
SELECT sex, AVG(height::numeric) AS avg_height, COUNT(*) AS num_athletes
FROM OLYMPICS_HISTORY
WHERE height IS NOT NULL and height <> 'NA'
GROUP BY sex;


SELECT sport, AVG(height::numeric) AS mean_height, STDDEV(height::numeric) AS std_dev_height, COUNT(*) AS count
FROM olympics_history
WHERE height IS NOT NULL and height <> 'NA'
GROUP BY sport;

SELECT age, height, weight, sport, 
       CASE WHEN medal IS NOT NULL THEN 1 ELSE 0 END AS medal_won
FROM olympics_history
where height <> 'NA' and weight <> 'NA'


SELECT noc, year, COUNT(*) AS count_medals
FROM olympics_history
WHERE medal IS NOT NULL and medal <> 'NA'
GROUP BY noc, year;








	