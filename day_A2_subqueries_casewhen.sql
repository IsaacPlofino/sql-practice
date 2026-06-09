  /*Part 1 — Subquery Rewrites From Memory
No looking at your Day 4 file. No AI. Write these cold using the framework.

Q1. (Day 4 Q8 rewrite) Using a derived table, calculate total revenue per customer from completed orders. 
Show only customers whose total exceeds ₱10,000. Show customer_name and total_revenue.*/

SELECT customer_name, total_revenue
FROM (
	SELECT c.customer_name, SUM(o.quantity*p.price) AS total_revenue
    FROM customers c 
    JOIN orders o ON c.customer_id = o.customer_id AND status = 'Completed'
    JOIN products p USING (product_id)
    GROUP BY c.customer_id, c.customer_name
) t
WHERE total_revenue > 10000;

-- Q2A. (Day 4 Q13 rewrite) Find the single highest-spending customer from completed orders only. Show customer_name and total_spent. Use a subquery — no window functions.
SELECT c.customer_name,SUM(p.price*o.quantity) total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id AND status = 'Completed'
JOIN products p USING (product_id)
GROUP BY c.customer_id, c.customer_name
HAVING total_spent = (
	SELECT MAX(total)
    FROM (
		SELECT SUM(quantity*price) total
        FROM orders 
        JOIN products USING (product_id)
        WHERE status = 'Completed'
        GROUP BY customer_id
        ) c
	);
    
-- Q2B. Without subquery
SELECT customer_name, SUM(price*quantity) total_spent
FROM customers
JOIN orders USING (customer_id)
JOIN products USING (product_id)
WHERE status = 'Completed' 
GROUP BY customer_id, customer_name
ORDER BY total_spent DESC
LIMIT 1;
							
-- Q3. (Day 4 Q15A rewrite) Find the top-spending customer per country from completed orders. Show country, customer_name, and total_spent. Use a correlated subquery in HAVING.
SELECT c.country, c.customer_name, SUM(o.quantity*p.price) total_spent
FROM customers c
JOIN orders o USING (customer_id)
JOIN products P USING (product_id)
WHERE status = 'Completed'
GROUP BY c.customer_id, c.country, c.customer_name
HAVING total_spent = (
	SELECT MAX(total)
    FROM (
		SELECT country, SUM(quantity*price) total
        FROM customers 
        JOIN orders USING (customer_id)
        JOIN products USING (product_id)
        WHERE status = 'Completed' AND country = c.country
        GROUP BY customer_id, country
        ) country_totals
	);

/*Part 2 — CASE WHEN + Conditional Aggregation
Q4. Add a price_tier column to the products table output. Rules: price above ₱20,000 = 'Premium', between ₱5,000 and ₱20,000 = 'Mid-range',
below ₱5,000 = 'Budget'. Show product_name, price, and price_tier.*/

SELECT product_name, price, 
	CASE 
		WHEN price > 20000 THEN 'Premium'
        WHEN price >= 5000 THEN 'Mid-range'
        ELSE 'Budget'
	END AS price_tier
FROM products;

-- Q5. For each order, show the order_id, status, and a column called status_flag. Rules: 'Completed' = 'Done', 'Pending' = 'Waiting', 'Cancelled' = 'Dropped'. Any other value = 'Unknown'.

SELECT order_id, status, 
	CASE status
		WHEN 'Completed' THEN 'Done'
        WHEN 'Pending' THEN 'Waiting'
        WHEN 'Cancelled' THEN 'Dropped'
        ELSE 'Unknown'
	END AS status_flag
FROM orders;

/* Q6. Count how many orders are Completed, Pending, and Cancelled — all in a single row. Name the columns completed_count, pending_count, and cancelled_count.
 This is conditional aggregation — one COUNT per status using CASE WHEN inside COUNT().*/
 
SELECT 
	COUNT(CASE WHEN status = 'Completed' THEN 1 END) AS completed_count,
    COUNT(CASE WHEN status = 'Pending' THEN 1 END) AS pending_count,
	COUNT(CASE WHEN status = 'Cancelled' THEN 1 END) AS cancelled_count
FROM orders;
    
-- Q7. Show total revenue from completed orders and total revenue from pending orders side by side — in a single row. Name the columns completed_revenue and pending_revenue.

SELECT 
	SUM(CASE WHEN status = 'Completed' THEN price*quantity ELSE 0 END) AS completed_revenue,
    SUM(CASE WHEN status = 'Pending' THEN price*quantity ELSE 0 END) AS pending_revenue
FROM orders
JOIN products USING (product_id);

/* Q8. Show each customer's name alongside two columns: completed_orders (count of completed orders) and cancelled_orders (count of cancelled orders).
 Include all customers. Use conditional aggregation — no subqueries, no UNION.*/
 
SELECT customer_name,
	COUNT(CASE WHEN status = 'Completed' THEN 1 END) AS completed_orders,
    COUNT(CASE WHEN status = 'Cancelled' THEN 1 END) AS cancelled_orders
FROM customers
LEFT JOIN orders USING (customer_id)
GROUP BY customer_id, customer_name;

/* Q9. For each product category, show the total revenue from completed orders and the total revenue from cancelled orders side by side. 
Show category, completed_revenue, and cancelled_revenue. Sort by completed_revenue descending.*/

SELECT category, 
	SUM(CASE WHEN status = 'Completed' THEN quantity*price ELSE 0 END) AS completed_revenue,
    SUM(CASE WHEN status = 'Cancelled' THEN quantity*price ELSE 0 END) AS cancelled_revenue
FROM products
JOIN orders USING (product_id)
GROUP BY category
ORDER BY completed_revenue DESC;

/* Q10. Show each customer's name, their total spending on completed orders, and a column called spending_tier.
 Rules: above ₱50,000 = 'High', between ₱10,000 and ₱50,000 = 'Medium', below ₱10,000 or no completed orders = 'Low'. Sort by total spending descending.*/

SELECT customer_name, total_spent,
	CASE 
		WHEN COALESCE(total_spent,0) > 50000 THEN 'High'
        WHEN COALESCE(total_spent,0) >= 10000 THEN 'Medium'
        ELSE 'Low'
	END AS spending_tier
FROM(
	SELECT customer_name, SUM(CASE WHEN status = 'Completed' THEN quantity*price END) AS total_spent
	FROM customers
	LEFT JOIN orders USING (customer_id)
	LEFT JOIN products USING (product_id)
	GROUP BY customer_id, customer_name
) totalspending
ORDER BY total_spent DESC;
