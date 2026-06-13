-- Leetcode Problems Solution
-- Problem 1: 176
-- 1. SHOW: SecondHighestSalary (scalar outer select to turn empty values into null)
-- 2. LIVE: employee         | JOIN TYPE: none
-- 3. WANT: precise rank position 2 when sorted descending
-- 4. COLLAPSE: none
-- 5. POST-FILTER: none
-- 6. WINDOW FN: none    | PARTITION BY:     | ORDER IN OVER:
-- 7. SUBQUERY TYPE: [  ] WHERE  [ ] FROM  [ ] SELECT  [ ] HAVING  [ ] NONE

SELECT (
    SELECT DISTINCT salary
    FROM Employee
    ORDER BY salary DESC
    LIMIT 1 OFFSET 1
) AS SecondHighestSalary;


-- Problem 2: 184
-- 1. SHOW: Department, Employee, Salary
-- 2. LIVE: employee (CTE)   | JOIN TYPE: INNER ON r.departmentId = d.id
-- 3. WANT: salary_rank = 1
-- 4. COLLAPSE: none
-- 5. POST-FILTER: none
-- 6. WINDOW FN: DENSE_RANK    | PARTITION BY: departmentId  | ORDER IN OVER: salary DESC
-- 7. SUBQUERY TYPE: [ ] WHERE  [ ] FROM  [ ] SELECT  [ ] HAVING  [ * ] NONE


WITH RankedSalaries AS (
    SELECT
        departmentId,
        e.name AS Employee,
        e.salary AS Salary,
        DENSE_RANK() OVER(PARTITION BY departmentId ORDER BY salary DESC) salary_rank
    FROM employee e
)


SELECT
    d.name AS Department,
    Employee,
    Salary
FROM RankedSalaries r
JOIN department d ON r.departmentId = d.id
WHERE salary_rank = 1;

-- Problem 3: 570
-- 1. SHOW: Manager name
-- 2. LIVE: employee (for managers)  | JOIN TYPE: JOIN employee (for subordinates, this connects them to their manager profile row)
-- 3. WANT: rows where the manager's ID is tied to 5 or more subordinate records
-- 4. COLLAPSE: GROUP BY manager's unique ID and name
-- 5. POST-FILTER: HAVING COUNT(e2.managerId) > 4
-- 6. WINDOW FN: NONE    | PARTITION BY:     | ORDER IN OVER:
-- 7. SUBQUERY TYPE: [ ] WHERE  [ ] FROM  [ ] SELECT  [ ] HAVING  [ * ] NONE

SELECT
    m.name AS name
FROM employee m
JOIN employee s ON m.id = s.managerId
GROUP BY m.id, m.name
HAVING COUNT(s.managerId) > 4;


-- Problem 4: 1045 
-- 1. SHOW: customer_id
-- 2. LIVE: customer    | JOIN TYPE: none
-- 3. WANT: Customers whose unique product count equals the total product table count
-- 4. COLLAPSE: GROUP BY customer_id
-- 5. POST-FILTER: HAVING COUNT(DISTINCT product_key) = (SELECT COUNT(*) FROM product);
-- 6. WINDOW FN: NONE    | PARTITION BY:     | ORDER IN OVER:
-- 7. SUBQUERY TYPE: [ ] WHERE  [ ] FROM  [ ] SELECT  [ * ] HAVING  [ ] NONE

SELECT customer_id
FROM customer
GROUP BY customer_id
HAVING COUNT(DISTINCT product_key) = (SELECT COUNT(*) FROM product)


-- Problem 5: 1164
-- 1. SHOW: product_id, price
-- 2. LIVE: products    | JOIN TYPE: none
-- 3. WANT: Split logic:
--          A) Latest change updates <= '2019-08-16'
--          B) Products whose first change occurs after '2019-08-16'
-- 4. COLLAPSE: Yes, using a subquery to find the MAX(change_date)
-- 5. POST-FILTER: none
-- 6. WINDOW FN: NONE    | PARTITION BY:     | ORDER IN OVER:
-- 7. SUBQUERY TYPE: [ * ] WHERE  [ ] FROM  [ ] SELECT  [  ] HAVING  [  ] NONE

SELECT product_id, new_price AS price
FROM products
WHERE (product_id, change_date) IN (
    SELECT product_id, MAX(change_date)
    FROM products
    WHERE change_date <= '2019-08-16'
    GROUP BY product_id
)

UNION

SELECT product_id, 10 AS price
FROM products
GROUP BY product_id
HAVING MIN(change_date) > '2019-08-16';


-- Problem 6: 1193 
-- 1. SHOW: DATE_FORMAT(trans_date, '%Y-%m') AS month, country, COUNT(id) AS trans_count, approved_count, trans_total_amount, approved_total_amount
-- 2. LIVE: Transactions | JOIN TYPE: NONE
-- 3. WANT: Aggregated counts and amounts broken down by month and country
-- 4. COLLAPSE: GROUP BY DATE_FORMAT(trans_date, '%Y-%m'), country
-- 5. POST-FILTER: NONE
-- 6. WINDOW FN: NONE
-- 7. SUBQUERY TYPE: [ * ] NONE

SELECT
    DATE_FORMAT(trans_date, '%Y-%m') AS month,
    country,
    COUNT(id) AS trans_count,
    SUM(CASE WHEN state = 'approved' THEN 1 ELSE 0 END) AS approved_count,
    SUM(amount) AS trans_total_amount,
    SUM(CASE WHEN state = 'approved' THEN amount ELSE 0 END) AS approved_total_amount
FROM Transactions
GROUP BY DATE_FORMAT(trans_date, '%Y-%m'), country;



-- Problem 7: 1321
-- 1. SHOW: visited_on, amount, average_amount
-- 2. LIVE: DailyTotals CTE | JOIN TYPE: NONE
-- 3. WANT: A rolling 7-day sum and 7-day average of daily revenue
-- 4. COLLAPSE: GROUP BY is handled in the underlying CTE layer; outer layer uses window processing
-- 5. POST-FILTER: WHERE visited_on >= (SELECT MIN(visited_on) FROM Customer) + 6 days
-- 6. WINDOW FN: SUM() / AVG() | PARTITION BY: NONE | ORDER IN OVER: ORDER BY visited_on ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
-- 7. SUBQUERY TYPE: [ * ] FROM (Using a CTE/Subquery to aggregate daily numbers first)

WITH DailyTotals AS (
    SELECT
        visited_on,
        SUM(amount) AS daily_sum
    FROM Customer
    GROUP BY visited_on
),


RollingCalculations AS (
    SELECT
        visited_on,
        SUM(daily_sum) OVER (ORDER BY visited_on ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS total_amount,
        ROUND(AVG(daily_sum) OVER (ORDER BY visited_on ROWS BETWEEN 6 PRECEDING AND CURRENT ROW),2) AS average_amount,
        ROW_NUMBER() OVER(ORDER BY visited_on) AS row_idx
    FROM DailyTotals
)


SELECT
    visited_on, total_amount AS amount, average_amount
FROM RollingCalculations
WHERE row_idx >= 7;







