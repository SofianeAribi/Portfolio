#Removing_dublicates


SELECT *
FROM customer_sweepstakes;

ALTER TABLE customer_sweepstakes RENAME COLUMN `ï»¿sweepstake_id` TO `sweepstake_id`;

SELECT customer_id, COUNT(customer_id) AS customer_nbr
FROM customer_sweepstakes
GROUP BY customer_id
HAVING customer_nbr > 1; 


#window function

SELECT *
FROM (SELECT customer_id,
row_number() over (PARTITION BY customer_id) as row_num
FROM customer_sweepstakes) as table_row
where row_num > 1;


DELETE FROM customer_sweepstakes

where sweepstake_id IN (
	SELECT sweepstake_id
	FROM (SELECT sweepstake_id,
	row_number() over (PARTITION BY customer_id) as row_num
	FROM customer_sweepstakes) as table_row
	where row_num > 1
	);


#Cleaning phone numbers

SELECT phone, REGEXP_REPLACE(phone, '[-()/+]', '')
FROM customer_sweepstakes;

Update customer_sweepstakes
SET phone = REGEXP_REPLACE(phone, '[-()/+]', '');


SELECT phone, CONCAT(substring(phone,1,3),"-", substring(phone,4,3),"-", substring(phone,6,4))
FROM customer_sweepstakes;

Update customer_sweepstakes
SET phone = CONCAT(substring(phone,1,3),"-", substring(phone,4,3),"-", substring(phone,6,4))
Where phone <> "";

# date

SELECT birth_date,
str_to_date(birth_date, '%m/%d/%Y'),
str_to_date(birth_date, '%Y/%d/%m')
FROM customer_sweepstakes;

SELECT birth_date, IF (str_to_date(birth_date, '%m/%d/%Y') IS NOT NULL, str_to_date(birth_date, '%m/%d/%Y'), str_to_date(birth_date, '%Y/%d/%m'))
FROM customer_sweepstakes;


SELECT birth_date, Concat(substring(birth_date,9,2),'/', substring(birth_date,6,2),'/', substring(birth_date,1,4))
FROM customer_sweepstakes;

UPDATE customer_sweepstakes
SET birth_date = Concat(substring(birth_date,9,2),'/', substring(birth_date,6,2),'/', substring(birth_date,1,4))
WHERE sweepstake_id IN (9,11);

UPDATE customer_sweepstakes 
SET birth_date = Case When str_to_date(birth_date, '%m/%d/%Y') IS NOT NULL THEN str_to_date(birth_date, '%m/%d/%Y')
					  when  str_to_date(birth_date, '%m/%d/%Y') IS NULL THEN  str_to_date(birth_date, '%Y/%d/%m') END;
                      

SELECT `Are you over 18?`, CASE when `Are you over 18?` = 'Y' THEN 'Yes'
										when `Are you over 18?` = 'N' THEN 'No'
                                        Else `Are you over 18?`
                                        END
FROM customer_sweepstakes;

UPDATE customer_sweepstakes 
SET `Are you over 18?` = CASE when `Are you over 18?` = 'Y' THEN 'Yes'
										when `Are you over 18?` = 'N' THEN 'No'
                                        Else `Are you over 18?`
                                        END;
                                        

SELECT address, substring_index(address, ',', 1) As Street,
substring_index(substring_index(address, ',', 2), ',', -1) AS City,
substring_index(address, ',', -1) As State
FROM customer_sweepstakes;


ALTER TABLE customer_sweepstakes
ADD COLUMN Street varchar(50) AFTER Address;

ALTER TABLE customer_sweepstakes
ADD COLUMN City varchar(50) AFTER Street;

ALTER TABLE customer_sweepstakes
ADD COLUMN State varchar(50) AFTER City;


UPDATE customer_sweepstakes
SET Street = SUBSTRING_INDEX(address, ',', 1);

UPDATE customer_sweepstakes
SET City = substring_index(substring_index(address, ',', 2), ',', -1);

UPDATE customer_sweepstakes
SET State = substring_index(address, ',', -1);

UPDATE customer_sweepstakes
SET State = upper(State);

select *
from customer_sweepstakes;

UPDATE customer_sweepstakes
SET City = Trim(City);

UPDATE customer_sweepstakes
SET State = Trim(State);



#Null Values:

SELECT count(sweepstake_id), count(phone) 
FROM customer_sweepstakes;

UPDATE customer_sweepstakes
SET Phone = NULL
where phone = '';


UPDATE customer_sweepstakes
SET income = NULL
where income = '';

select *
from customer_sweepstakes;

SELECT birth_date, `Are you over 18?`
FROM customer_sweepstakes
where 2022 - 18 < year(birth_date);


UPDATE customer_sweepstakes
SET `Are you over 18?` = 'No'
where 2022 - 18 < year(birth_date);


# Deleting Unused columns

ALTER TABLE customer_sweepstakes
DROP COLUMN address,
DROP column  favorite_color




