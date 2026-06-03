USE sprint_db;
-- Add new customers
-- Note: Multiple customers per country to test PARTITION BY behavior
INSERT INTO customers VALUES
(6,  'Frank Reyes',    'Singapore'),
(7,  'Grace Tan',      'Malaysia'),
(8,  'Henry Cruz',     'Philippines'),
(9,  'Isabel Santos',  'Singapore'),
(10, 'James Lim',      'Malaysia');

-- Add new products
-- Note: Duplicate prices to test RANK vs DENSE_RANK behavior
INSERT INTO products VALUES
(106, 'Keyboard',     'Electronics',  1500.00),  -- same price as Mouse (102)
(107, 'Monitor',      'Electronics', 18000.00),
(108, 'Filing Cabinet','Furniture',  12000.00),  -- same price as Desk Chair (103)
(109, 'Ballpen Set',  'Supplies',      150.00),  -- same price as Notebook (104)
(110, 'Webcam',       'Electronics',  3500.00);

-- Add new orders
-- Note: Multiple orders per customer, varied statuses, spread across months
INSERT INTO orders VALUES
(1009,  6,  102, 2,  '2024-01-20', 'Completed'),
(1010,  6,  107, 1,  '2024-02-10', 'Completed'),
(1011,  7,  101, 1,  '2024-02-15', 'Completed'),
(1012,  7,  103, 2,  '2024-03-01', 'Pending'),
(1013,  8,  106, 3,  '2024-03-10', 'Completed'),
(1014,  8,  110, 1,  '2024-03-25', 'Completed'),
(1015,  9,  101, 1,  '2024-04-05', 'Completed'),
(1016,  9,  107, 2,  '2024-04-15', 'Cancelled'),
(1017, 10,  104, 5,  '2024-04-20', 'Completed'),
(1018, 10,  110, 2,  '2024-05-01', 'Completed'),
(1019,  6,  103, 1,  '2024-05-05', 'Completed'),
(1020,  2,  101, 1,  '2024-05-10', 'Completed'),  -- Bob Santos (Singapore) gets another order
(1021,  3,  104, 4,  '2024-05-15', 'Completed'),  -- Clara Mendoza gets her first completed order
(1022,  4,  102, 2,  '2024-05-20', 'Completed'),  -- David Lim (Malaysia) gets a completed order
(1023,  8,  103, 1,  '2024-05-22', 'Completed'),
(1024,  1,  107, 1,  '2024-05-25', 'Completed');  -- Alice Reyes gets another big order

-- ROW_NUMBER, RANK, DENSE_RANK
-- Q1. Assign a unique row number to each order sorted by order_date ascending. Show order_id, order_date, and row_num.
SELECT  order_id, order_date, ROW_NUMBER() OVER(ORDER BY order_date) row_num
FROM orders;

-- Q2. Rank all products by price from highest to lowest. Show product_name, price, and price_rank. Use RANK().
SELECT product_name, price, RANK() OVER(ORDER BY price DESC) price_rank
FROM products;

-- Q3. Rank all products by price from highest to lowest using DENSE_RANK(). Show product_name, price, and price_rank. What's the difference in output vs Q2?
SELECT product_name, price, DENSE_RANK () OVER(ORDER BY price DESC) price_rank
FROM products; 
-- difference between RANK() and DENSE_RANK is how they rank succeeding ranks if there's a tie. RANK() skips based on the numbe of tied rows while DENSE_RANK doesn't.
	
-- Q4. Rank customers by total amount spent on completed orders. Show customer_name, total_spent, and spend_rank. Use DENSE_RANK().
SELECT c.customer_name, SUM(p.price*o.quantity) AS total_spent, DENSE_RANK() OVER(ORDER BY SUM(p.price*o.quantity) DESC) AS spend_rank
FROM customers c
JOIN orders o USING (customer_id)
JOIN products p USING (product_id)
WHERE o.status = 'Completed'
GROUP BY c.customer_id, c.customer_name;

-- PARTITION BY
-- Q5. Rank products by price within each category. Show product_name, category, price, and price_rank. Use RANK().
SELECT product_name, category, price, RANK() OVER(PARTITION BY category ORDER BY price DESC) price_rank
FROM products;

-- Q6. Assign a row number to each order per customer, ordered by order_date. Show customer_id, order_id, order_date, and order_seq.
SELECT c.customer_id, o.order_id, o.order_date, ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY order_date) order_seq
FROM customers c
JOIN orders o USING (customer_id);

/*Q7. For each order, show the total revenue of the product's category alongside the order. 
Show order_id, product_name, category, and category_revenue. Use SUM() as a window function — do not use GROUP BY.*/
SELECT o.order_id, p.product_name, p.category, SUM(p.price*o.quantity) OVER(PARTITION BY p.category) category_revenue
FROM orders o JOIN products p USING (product_id);

-- LAG and LEAD
-- Q8. For each order sorted by order_date, show the previous order's date alongside the current one. Show order_id, order_date, and prev_order_date. Use LAG().
SELECT order_id, order_date, LAG(order_date) OVER(ORDER BY order_date) prev_order_date
FROM orders;

-- Q9. For each order sorted by order_date, show the next order's date. Show order_id, order_date, and next_order_date. Use LEAD().
SELECT order_id, order_date, LEAD(order_date) OVER(ORDER BY order_date) next_order_date
FROM orders;

/*Q10. For each customer's orders sorted by order_date, show the previous order date within the same customer.
 Show customer_id, order_id, order_date, and prev_order_date. Use LAG() with PARTITION BY. */
SELECT c.customer_id, o.order_id, o.order_date, LAG(order_date) OVER(PARTITION BY customer_id ORDER BY order_date) prev_order_date
FROM customers c
JOIN orders o USING (customer_id);

-- Running Totals and Moving Aggregates
-- Q11. Calculate a running total of quantity ordered by order_date. Show order_id, order_date, quantity, and running_total.
SELECT order_id, order_date, quantity, SUM(quantity) OVER(ORDER BY order_id, order_date) running_total
FROM orders;

-- Q12. For each order, show the running total revenue (quantity × price) ordered by order_date. Show order_id, order_date, and running_revenue.
SELECT order_id, order_date, SUM(quantity*price) OVER(ORDER BY order_id, order_date) running_revenue
FROM orders JOIN products USING (product_id);

-- CTEs — WITH clause
-- Q13. Using a CTE, find the top spender per country from completed orders. Show country, customer_name, and total_spent.
WITH ranked_spenders AS (
	SELECT 
    c.country,
    c.customer_name,
    SUM(price*quantity) total_spent,
    ROW_NUMBER() OVER(
		PARTITION BY c.country 
        ORDER BY SUM(price*quantity) DESC
	) ranking
    FROM customers c
    JOIN orders o USING (customer_id)
    JOIN products p USING (product_id)
    WHERE o.status = 'Completed'
    GROUP BY c.customer_id, c.customer_name, c.country) 

SELECT country, customer_name, total_spent
FROM ranked_spenders 
WHERE ranking = 1;


/* Q14. Using a CTE, calculate each customer's total orders and total spent. 
Then from that CTE, return only customers who placed more than 1 order AND spent more than ₱10,000. Show customer_name, order_count, and total_spent. */
WITH total_orders_and_spent AS (
	SELECT 
    c.customer_name, 
    COUNT(o.order_id) OVER(
		PARTITION BY c.customer_id) order_count, 
    SUM(o.quantity*p.price) OVER(
		PARTITION BY c.customer_id) total_spent
    FROM customers c 
    JOIN orders o USING (customer_id)
    JOIN products p USING (product_id)
    )
SELECT DISTINCT customer_name, order_count, total_spent
FROM total_orders_and_spent
WHERE order_count > 1 AND total_spent > 10000;

-- Combined — Window Function + CTE
/* Q15. Using a CTE and ROW_NUMBER(), find the single top-spending customer per country from completed orders only. 
Show country, customer_name, and total_spent. If two customers in the same country have equal spending, return both. */

WITH ranked_spenders AS (
	SELECT 
    c.country,
    c.customer_name,
    SUM(price*quantity) total_spent,
    ROW_NUMBER() OVER(
		PARTITION BY c.country 
        ORDER BY SUM(price*quantity) DESC
	) ranking
    FROM customers c
    JOIN orders o USING (customer_id)
    JOIN products p USING (product_id)
    WHERE o.status = 'Completed'
    GROUP BY c.customer_id, c.customer_name, c.country) 

SELECT country, customer_name, total_spent
FROM ranked_spenders 
WHERE (country, total_spent) IN (
	SELECT country, total_spent
    FROM ranked_spenders
    WHERE ranking = 1
);
