DROP TABLE IF EXISTS sales_data;
CREATE TABLE sales_data AS  -- creates new table on the go from the select statement 
SELECT floor(RANDOM()*(1000-100)+100) AS id
   ,generate_series(
 			 '2018-01-01'::date,
  			 '2020-12-31'::date,
  			'1 day'::interval)::date sales_date
  ,(ARRAY['Riyadh','Jeddah','Dammam','Taif','Madina'])[floor(RANDOM()*5)+1] region 
  ,floor(RANDOM()*(5000-1000)+100) sales_amt
  ,floor(RANDOM()*(12-1)+1) qty
  ,(ARRAY['Katherine Underwood','Jason McDonald','Bella Kelly','Kimberly Ferguson','Paul Springer'])[floor(RANDOM()*5)+1] sales_manager;
  
SELECT * FROM sales_data;
 