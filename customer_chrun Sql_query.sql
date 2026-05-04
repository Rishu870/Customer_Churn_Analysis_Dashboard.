create database customer_churn_db;
use customer_churn_db;
select * from dbo.customer_churn;
select * into churn
from dbo.customer_churn;

select * from churn;
--------------------------------------------------------------------------------------------------------------------------
---check duplicates values -----------------------------------------------------------------------------------------------
with CTE as(select * , ROW_NUMBER() over(PARTITION by customerID order by customerID) as RN from churn ) select * from CTE where RN >1

-- to check null values---------------------------------------------------------------------------------------------------
select * from churn where customerID is null;
select * from churn where gender is null;
select * from churn where SeniorCitizen is null;
select * from churn where MultipleLines is null;

---# This datasets contain lots of null values and client said that dont treat any null values ;

select distinct(gender) from churn;

----- Problem Statement
-----Analyze customer data to identify:
-----Why customers are leaving (churn)
-----Which customers are at high risk
-----Business insights to reduce churn

----Q1. Total Customers?
select COUNT(*) as total_count from churn;

----Q2) Total Churn Customers?
select  count(*) as total_count from churn where churn = 0 -----(still Active)
select count(*) as total_count from churn where churn = 1  ----(left the company)

-----Q3) Churn by Contract Type?
SELECT 
    Contract,
    COUNT(*) AS total_customers,
    SUM(CASE 
            WHEN Churn = 1 THEN 1 
            ELSE 0 
        END) AS churn_count
FROM churn
GROUP BY Contract
ORDER BY churn_count DESC;

----Q4)Average Monthly Charges (Churn vs Non-Churn)?
SELECT 
    Churn,
    ROUND(AVG(MonthlyCharges),2) AS avg_monthly_charges
FROM churn
GROUP BY Churn;

----Q5) Churn by Payment Method
SELECT 
    PaymentMethod,
    COUNT(*) AS total,
    SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS churn_count
FROM churn
GROUP BY PaymentMethod
ORDER BY churn_count DESC;

----Q6) Tenure Analysis (Customer Lifetime)?
select churn , avg(tenure)as avg_tenure from churn group by churn;

-----Q7) High Risk Customers?
SELECT *
FROM churn
WHERE tenure < 12 
AND MonthlyCharges > 70 
AND Contract = 'Month-to-month';

-----Q8)Internet Service vs Churn?
SELECT 
    InternetService,
    COUNT(*) AS total,
    SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS churn_count
FROM churn
GROUP BY InternetService;

------Q9)Senior Citizen Churn?
SELECT 
    SeniorCitizen,
    COUNT(*) AS total,
    SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS churn_count
FROM churn
GROUP BY SeniorCitizen;

-------Q10) Top 5 High Paying Churn Customers
SELECT TOP 5 *
FROM churn
WHERE Churn = 1
ORDER BY MonthlyCharges DESC;