select * from worldlifeexpectancy;

SELECT country, year, concat(country, year) as ycountry, COUNT(concat(country, year))
FROM worldlifeexpectancy
group by country, year, concat(country, year)
having COUNT(concat(country, year)) > 1;



SELECT * 
FROM ( Select Row_ID, concat(country, year),
		ROW_NUMBER() over (partition by concat(country, year) ) as num
		FROM worldlifeexpectancy) as rownum
where num > 1;

DELETE FROM worldlifeexpectancy
WHERE Row_ID IN (SELECT Row_id
	FROM ( Select Row_ID, concat(country, year),
		ROW_NUMBER() over (partition by concat(country, year) ) as num
		FROM worldlifeexpectancy) as rownum
where num > 1);



SELECT DISTINCT(country)
FROM worldlifeexpectancy
WHERE status = 'Developing';


/*UPDATE worldlifeexpectancy
SET Status = 'Developing'
where Country IN ( SELECT DISTINCT(country)
					FROM worldlifeexpectancy
					WHERE status = 'Developing'); */
                    

UPDATE worldlifeexpectancy t1 
	JOIN worldlifeexpectancy t2
	ON t1.country = t2.country 
		SET T1.Status = 'Developing'
	WHERE t1.Status = ''
    AND t2.Status <> ''
    AND t2.Status = 'Developing';
    
    
UPDATE worldlifeexpectancy t1
	JOIN worldlifeexpectancy t2
		ON t1.country = t2.country
	SET t1.status = 'Developed'
		WHERE t1.status = ''
		AND t2.status <> ''
		AND t2.status = 'Developed';
        



SELECT * 
FROM worldlifeexpectancy
WHERE `Life expectancy` = '';


SELECT t1.Country, t1.year, t1.`Life expectancy`,
		t2.Country, t2.year, t2.`Life expectancy`,
        t3.Country, t3.year, t3.`Life expectancy`,
        ROUND((t2.`Life expectancy` + t3.`Life expectancy`)/2,1)
FROM worldlifeexpectancy t1
	JOIN worldlifeexpectancy t2 
		ON t1.country = t2.country
			AND t1.year = t2.year - 1
	JOIN worldlifeexpectancy t3
		ON t1.country = t3.country
			AND t1.year = t3.year + 1
WHERE t1.`Life expectancy` = '';

UPDATE worldlifeexpectancy t1
	JOIN worldlifeexpectancy t2 
		ON t1.country = t2.country
			AND t1.year = t2.year - 1
	JOIN worldlifeexpectancy t3
		ON t1.country = t3.country
			AND t1.year = t3.year + 1
            
SET t1.`Life expectancy` = ROUND((t2.`Life expectancy` + t3.`Life expectancy`)/2,1)
where t1.`Life expectancy` = '';



-- EDA:

Select country,MIN(`Life expectancy`) as MIN_expectancy ,  MAX(`Life expectancy`) MAX_expectancy,
	ROUND((MAX(`Life expectancy`) - MIN(`Life expectancy`)),1) as Difference
from worldlifeexpectancy
group by country
HAVING MIN(`Life expectancy`) <> 0
	AND  MAX(`Life expectancy`) <> 0
ORDER BY Difference DESC;


SELECT year,
	ROUND(avg(`Life expectancy`),2) as Average_expectency
FROM worldlifeexpectancy
where `Life expectancy` <> 0
GROUP BY year
ORDER BY Year;



SELECT Country, Round(AVG(`Life expectancy`),1), round(AVG(GDP),1)  
from worldlifeexpectancy
GROUP BY country
HAVING Round(AVG(`Life expectancy`),1) <> 0 AND round(AVG(GDP),1)   <> 0;




SELECT 
SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) AS Hgh_GDP_count,
ROUND(AVG(CASE WHEN GDP >= 1500 THEN `Life expectancy` ELSE NULL END),1) AS Hgh_GDP_Life,
SUM(CASE WHEN GDP <= 1500 THEN 1 ELSE 0 END) AS Low_GDP_count,
ROUND(AVG(CASE WHEN GDP <= 1500 THEN `Life expectancy` ELSE NULL END),1) AS Low_GDP_Life
FROM worldlifeexpectancy;



SELECT Status, Round(AVG(`Life expectancy`),1), COUNT(DISTINCT country)
FROM worldlifeexpectancy
GROUP BY Status;



SELECT Country, Round(AVG(`Life expectancy`),1) AS Life, round(AVG(BMI),1) AS BMI
from worldlifeexpectancy
GROUP BY country
HAVING Round(AVG(`Life expectancy`),1) <> 0 AND round(AVG(BMI),1)   <> 0
ORDER BY BMI DESC;


SELECT Country, ROUND(AVG(`Adult Mortality`),2) as Adult_morality
FROM worldlifeexpectancy
GROUP BY country
ORDER BY Adult_morality DESC;



SELECT COUNTRY, YEAR, `Life expectancy`, `Adult Mortality`,
SUM(`Adult Mortality`) OVER(PARTITION BY Country ORDER BY YEAR)
FROM worldlifeexpectancy

	
