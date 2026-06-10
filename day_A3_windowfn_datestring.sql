/*Part 1 — Window Function Rewrites From Memory
The three that failed on Day 5. Write them cold. No looking at your old file.
Q1. (Day 5 Q8 rewrite) For each order sorted by order_date, show the previous order's date alongside the current one. 
Show order_id, order_date, and prev_order_date. Use LAG(). */

SELECT order_id, order_date, LAG(order_date) OVER(ORDER BY order_date) AS prev_order_date
FROM orders;

-- Q2. (Day 5 Q9 rewrite) For each order sorted by order_date, show the next order's date. Show order_id, order_date, and next_order_date. Use LEAD().

SELECT order_id, order_date, LEAD(order_date) OVER(ORDER BY order_date) AS next_order_date
FROM orders;

/*Q3. (Day 5 Q10 rewrite) For each customer's orders sorted by order_date, show the previous order date within the same customer. 
Show customer_id, order_id, order_date, and prev_order_date. Use LAG() with PARTITION BY.*/

SELECT customer_id, order_id, order_date, LAG(order_date) OVER(PARTITION BY customer_id ORDER BY order_date) AS prev_order_date
FROM customers 
JOIN orders USING (customer_id);

/*Part 2 — Date Functions
Q4. Show each order's order_id, order_date, and a column called order_month showing the month name and year. Format it as 'January 2024'. Use DATE_FORMAT().*/

SELECT order_id, order_date, DATE_FORMAT(order_date, '%M %Y') AS order_month
FROM orders;

/*Q5. For each order, calculate how many days have passed since the order was placed as of '2024-06-01'. 
Show order_id, order_date, and days_since_order. Use DATEDIFF(). Sort oldest to newest. */

SELECT order_id, order_date, DATEDIFF('2024-06-01',order_date) AS days_since_order
FROM orders
ORDER BY days_since_order DESC;

/*Q6. Show total revenue per month from completed orders only. Show order_month (formatted as 'January 2024') and monthly_revenue. 
Sort chronologically — earliest month first. */

SELECT DATE_FORMAT(order_date, '%M %Y') AS order_month, SUM(price*quantity) AS monthly_revenue
FROM orders
JOIN products USING (product_id)
WHERE status = 'Completed'
GROUP BY DATE_FORMAT(order_date, '%M %Y'), order_month
ORDER BY MIN(order_date) ASC;

-- Q7. Find all orders placed in the first quarter of 2024 (January, February, March). Show order_id, order_date, and status. Use MONTH() and YEAR().

SELECT order_id, order_date, status
FROM orders
WHERE MONTH(order_date) <= 3 AND YEAR(order_date) = '2024';

/*Part 3 — String Functions
Q8. Show each customer's full display label combining their name and country in this format: 'Alice Reyes (Philippines)'.
Name the column customer_label. Use CONCAT(). */

SELECT CONCAT(customer_name,' (',country,')' ) AS customer_label
FROM customers;

-- Q9. Show each product's product_name in uppercase and its category in lowercase. Name the columns product_upper and category_lower.

SELECT UPPER(product_name) AS product_upper, LOWER(category) AS category_lower
FROM products;

/* Q10. Show each customer's customer_name, the LENGTH() of their name as name_length, and the first 5 characters of their name as name_short. 
Use SUBSTRING(). Sort by name_length descending. */

SELECT customer_name, LENGTH(customer_name) AS name_length, SUBSTRING(customer_name,1,5) AS name_short
FROM customers
ORDER BY name_length DESC;
