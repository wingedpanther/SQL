-- Table
CREATE TABLE brands (
  year_v INT,
  Brand VARCHAR(50),
  Amount INT
);

INSERT INTO brands (year_v, Brand, Amount)
VALUES
(2018, 'P&G', 50000),
(2019, 'P&G', 45000),
(2020, 'P&G', 60000),
(2018, 'IBM', 55000),
(2019, 'IBM', 60000),
(2020, 'IBM', 70000),
(2018, 'EY', 80000),
(2019, 'EY', 40000),
(2020, 'EY', 36000);


-- Query
SELECT *
FROM brands
WHERE brand in
    (SELECT brand
     FROM
       (SELECT brand,
               (amount - lag(amount, 1, 0) OVER (PARTITION BY brand
                                                 ORDER BY year_v)) diff
        FROM brands) t
     GROUP BY brand
     HAVING min(diff) > 0) ;