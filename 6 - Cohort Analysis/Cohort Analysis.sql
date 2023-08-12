SELECT *
FROM global_superstore_clean AS g
--------------BEGIN COHORT ANALYSIS----------------------------
---Data Required:
--Unique Identifier (CustomerID)
--Initial Start Date (First	Invoice Date)
--Revenue Data (Quantity*UnitPrice)
SELECT customer_id,
		MIN(order_date) AS First_purchase_date,
		DATEFROMPARTS(YEAR(MIN(order_date)), MONTH(MIN(order_date)),1) AS Cohort_Date
into #cohort
FROM global_superstore_clean AS g
GROUP BY customer_id

--Create Cohort index
SELECT 
	mm.*,
	cohort_index = Year_diff*12+Month_diff+1
INTO #cohort_retention 
FROM
	(
	SELECT
		m.*,
		Year_diff = OrderYear - CohortYear,
		Month_diff = OrderMonth - CohortMonth	
	FROM
		(
		SELECT f.*, c.Cohort_Date,
				YEAR(f.order_date) AS OrderYear,
				MONTH(f.order_date) AS OrderMonth,
				YEAR(c.Cohort_Date) AS CohortYear,
				MONTH(c.Cohort_Date) AS CohortMonth
		FROM global_superstore_clean AS f
		LEFT JOIN #cohort AS c
			ON c.customer_id = f.customer_id
	) AS m
) AS mm
--WHERE CustomerID = 18168
---cohort_retention.csv table--
SELECT *
FROM #cohort_retention
--
--Pivot Data to see the cohort table
SELECT
	*
INTO #cohort_pivot_table
FROM
	(
	SELECT DISTINCT 
			customer_id,
			Cohort_Date,
			cohort_index
	FROM #cohort_retention
) AS TBL
	PIVOT(
		COUNT(customer_id)
		FOR Cohort_Index In 
		(
		[1],
		[2],
		[3],
		[4],
		[5],
		[6],
		[7],
		[8],
		[9],
		[10],
		[11],
		[12],
		[13],
		[14],
		[15],
		[16],
		[17],
		[18],
		[19],
		[20],
		[21],
		[22],
		[23],
		[24]
		)
   ) AS Pivot_Table
ORDER BY Cohort_Date

--Cohort_table_count
SELECT *
FROM #cohort_pivot_table
ORDER BY Cohort_Date

--Cohort_table_percentage
select Cohort_Date ,
	(1.0 * [1]/[1] * 100) as [1], 
    1.0 * [2]/[1] * 100 as [2], 
    1.0 * [3]/[1] * 100 as [3],  
    1.0 * [4]/[1] * 100 as [4],  
    1.0 * [5]/[1] * 100 as [5], 
    1.0 * [6]/[1] * 100 as [6], 
    1.0 * [7]/[1] * 100 as [7], 
	1.0 * [8]/[1] * 100 as [8], 
    1.0 * [9]/[1] * 100 as [9], 
    1.0 * [10]/[1] * 100 as [10],   
    1.0 * [11]/[1] * 100 as [11],  
    1.0 * [12]/[1] * 100 as [12],  
	1.0 * [13]/[1] * 100 as [13],
	1.0 * [14]/[1] * 100 as [14],
	1.0 * [15]/[1] * 100 as [15],
	1.0 * [16]/[1] * 100 as [16],
	1.0 * [17]/[1] * 100 as [17],
	1.0 * [18]/[1] * 100 as [18],
	1.0 * [19]/[1] * 100 as [19],
	1.0 * [20]/[1] * 100 as [20],
	1.0 * [21]/[1] * 100 as [21],
	1.0 * [22]/[1] * 100 as [22],
	1.0 * [23]/[1] * 100 as [23],
	1.0 * [24]/[1] * 100 as [24]
from #cohort_pivot_table
order by Cohort_Date
