select * from ushouseholdincome;

ALTER TABLE ushouseholdincome_statistics RENAME COLUMN `ï»¿id` TO `Id`;


SELECT id, COUNT(id) from ushouseholdincome
GROUP BY id
HAVING COUNT(id) > 1;

-- CHEKING DUPLICATES

SELECT * 
FROM (
select id,
ROW_NUMBER() over(PARTITION BY id) as row_num
from ushouseholdincome
) as dup_row
where row_num > 1;



-- DELETING DUPLICATES

DELETE FROM ushouseholdincome

WHERE id IN (
	SELECT id
	FROM (
	select id,
	ROW_NUMBER() over(PARTITION BY id) as row_num
	from ushouseholdincome
	) as dup_row
where row_num > 1
);


-- FIXING SPELLING:

SELECT State_name, COUNT(State_name)
from ushouseholdincome
GROUP BY State_name
ORDER BY State_name;


UPDATE ushouseholdincome
SET State_name = "Gerorgia" 
WHERE State_name = "georia";


UPDATE ushouseholdincome
SET State_name = "Alabama" 
WHERE State_name = "alabama";


SELECT State_ab, count(State_ab)
FROM ushouseholdincome
GROUP BY State_ab
ORDER BY 1;


UPDATE ushouseholdincome
SET Place = 'Autaugaville'
Where County = 'Autauga County'
AND City = 'Vinemont';


SELECT Type, COUNT(Type)
FROM ushouseholdincome
GROUP BY Type;


UPDATE ushouseholdincome
SET Type = "CDP" 
WHERE Type = 'CPD';


UPDATE ushouseholdincome
SET Type = "Borough" 
WHERE Type = 'Boroughs';


SELECT ALand, AWater
FROM ushouseholdincome
Where (AWater IN ( 0,NULL, '')) AND
(ALand IN ( 0,NULL, ''));



-- EDA:


Select State_Name, SUM(ALand) As Land, SUM(AWater) As Water
FROM ushouseholdincome
Group By State_Name
ORder by 2 DESC;


SELECT * 
FROM ushouseholdincome us
JOIN ushouseholdincome_statistics uss ON us.id = uss.id
Where uss.MEan <> 0;



SELECT us.State_Name, County, Type, `Primary`, Mean, Median
FROM ushouseholdincome us
JOIN ushouseholdincome_statistics uss ON us.id = uss.id
Where uss.MEan <> 0;



SELECT us.State_Name, ROUND(Avg(Mean),1), ROUND(Avg(Median),1)
FROM ushouseholdincome us
JOIN ushouseholdincome_statistics uss ON us.id = uss.id
Where uss.MEan <> 0
GROUP BY us.State_Name
ORDER BY 2 DESC;


SELECT Type,COUNT(Type), ROUND(Avg(Mean),1), ROUND(Avg(Median),1)
FROM ushouseholdincome us
JOIN ushouseholdincome_statistics uss ON us.id = uss.id
Where uss.MEan <> 0
GROUP BY Type
HAVING COUNT(Type) > 100
ORDER BY 2 DESC;


SELECT us.State_Name, City, ROUND(Avg(Mean),1), ROUND(Avg(Median),1)
FROM ushouseholdincome us
JOIN ushouseholdincome_statistics uss ON us.id = uss.id
Where uss.MEan <> 0
GROUP BY CITY, us.State_Name 
ORDER BY ROUND(Avg(Mean),1) DESC;
