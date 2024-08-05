create database ZomatoAnalysis;
use ZomatoAnalysis;
show tables from ZomatoAnalysis;
---------------------- (1) Count of Resttaurent in Country -------------------------------------
select countryname, count(restaurantid) 
from main M
left join country C 
on M.countrycode=C.CountryID
group by countryname
ORDER BY count(restaurantid) DESC
LIMIT 10;
--------------------- (2) year by year restarunt opning --------------------------------------
select distinct YearOpening as year, count(restaurantid)
from main
group by YearOpening
order by YearOpening;
---------------------- (3) has table booking ----------------------------------------
select
	has_table_booking,
    count(*) as TotalRestaurent,
    round((count(*)/(select count(*) from main)) * 100, 2) as P
from main
group by has_table_booking;
--------------------- (4) has online delivery--------------------------------------------
select
	Has_Online_delivery,
    count(*) as TotalRestaurent,
    round((count(*)/(select count(*) from main)) * 100, 2) as P
from main
group by Has_Online_delivery;
--------------------- (5) bucket list --------------------------------------------
select
	cost_range,
    count(*) as TotalRestaurants
from (
	select
		case
			when average_cost_for_two between 0 and 300 then '0-300'
            when average_cost_for_two between 301 and 600 then '301-600'
            when average_cost_for_two between 601 and 1000 then '601-1000'
            when average_cost_for_two between 1001 and 430000 then '1001-430000'
            else 'other'
		end as cost_range
        from
			main
) as bucket
group by cost_range;
----------------- (6) Votes based on different Cuisines ------------------------------------------
SELECT distinct Cuisines, COUNT(Votes) AS VoteCount
FROM main
GROUP BY Cuisines
ORDER BY VoteCount DESC
LIMIT 10;
----------------- (7) Calender ------------------------------------------
SELECT 
    YEAR(OpenDate) AS Year,
    MONTH(OpenDate) AS Monthno,
    CASE MONTH(OpenDate)
        WHEN 1 THEN 'January'
        WHEN 2 THEN 'February'
        WHEN 3 THEN 'March'
        WHEN 4 THEN 'April'
        WHEN 5 THEN 'May'
        WHEN 6 THEN 'June'
        WHEN 7 THEN 'July'
        WHEN 8 THEN 'August'
        WHEN 9 THEN 'September'
        WHEN 10 THEN 'October'
        WHEN 11 THEN 'November'
        WHEN 12 THEN 'December'
    END AS Monthfullname,
    QUARTER(OpenDate) AS Quarter,
    CONCAT(YEAR(OpenDate), '-', LEFT(DATENAME(MONTH, OpenDate), 3)) AS YearMonth,
    DAYOFWEEK(OpenDate) AS Weekdayno,
    CASE DAYOFWEEK(OpenDate)
        WHEN 1 THEN 'Sunday'
        WHEN 2 THEN 'Monday'
        WHEN 3 THEN 'Tuesday'
        WHEN 4 THEN 'Wednesday'
        WHEN 5 THEN 'Thursday'
        WHEN 6 THEN 'Friday'
        WHEN 7 THEN 'Saturday'
    END AS Weekdayname,
    CONCAT(
        'FM',
        IF(MONTH(OpenDate) >= 4, MONTH(OpenDate) - 3, MONTH(OpenDate) + 9)
    ) AS FinancialMonth,
    CASE 
        WHEN MONTH(OpenDate) IN (4, 5, 6) THEN 'Q1'
        WHEN MONTH(OpenDate) IN (7, 8, 9) THEN 'Q2'
        WHEN MONTH(OpenDate) IN (10, 11, 12) THEN 'Q3'
        ELSE 'Q4'
    END AS FinancialQuarter
FROM 
    Main;



