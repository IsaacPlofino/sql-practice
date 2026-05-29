-- Q1. Find all products that cost more than the average product price.
SELECT product_name, price
FROM products 
WHERE price > (SELECT AVG(price) FROM products);

-- Q2. Find all orders where the quantity is above the average quantity across all orders.
SELECT order_id, quantity
FROM orders
WHERE quantity > (SELECT AVG(quantity) FROM orders);

-- Q3. Find all customers who have placed at least one completed order. Use IN — no JOINs.
SELECT customer_name
FROM customers
WHERE customer_id IN (SELECT customer_id FROM orders WHERE status = 'Completed');

-- Q4. Find all products that have never been ordered. Use a subquery — no JOINs.
SELECT product_name
FROM products 
WHERE product_id NOT IN (SELECT product_id FROM orders WHERE product_id IS NOT NULL);

-- Q5. Find all customers who have never placed an order. Use a subquery — no JOINs.
SELECT customer_name
FROM customers
WHERE customer_id NOT IN (SELECT customer_id FROM orders WHERE customer_id IS NOT NULL);

-- Q6. Show each product's name, price, and the difference between its price and the average.
SELECT product_name, price, (price - (SELECT AVG(price) FROM products)) AS price_vs_avg 
FROM products;

-- Q7. Show each order's ID, quantity, and the overall average quantity.
SELECT order_id, quantity, (SELECT AVG (quantity) FROM orders) AS avg_quantity
FROM orders;

-- Q8. Calculate total revenue per customer from completed orders. Show only totals > ₱10,000.
SELECT customer_name, total_revenue
FROM (SELECT c.customer_name, SUM(o.quantity*p.price) as total_revenue
	FROM customers c 
	JOIN orders o ON c.customer_id = o.customer_id
	JOIN products p ON o.product_id = p.product_id
	WHERE o.status = 'Completed'
	GROUP BY c.customer_id, c.customer_name) AS customer_revenues
WHERE total_revenue > 10000;

-- Q9. Find the average number of orders placed per customer.
SELECT AVG(order_count) AS avg_orders_per_customers
FROM (SELECT COUNT(*) AS order_count
	FROM orders
	GROUP BY customer_id) order_counts;

-- Q10. For each customer, find their most recent order date.	
SELECT c.customer_name, (SELECT MAX(o.order_date) FROM orders o WHERE o.customer_id = c.customer_id) AS last_order_date
FROM customers c;

-- Q11. Find customers whose total spending is above the average total spending.
SELECT customer_name, total_spent
FROM ( 
		SELECT c.customer_id, c.customer_name, SUM(p.price*o.quantity) AS total_spent
		FROM customers c 
		JOIN orders o ON c.customer_id = o.customer_id
		JOIN products p ON o.product_id = p.product_id
		GROUP BY c.customer_id, c.customer_name) AS cust_spending
WHERE total_spent > (
		SELECT AVG(total)
		FROM (
			SELECT SUM(p.price*o.quantity) AS total
            FROM orders o
            JOIN products p ON o.product_id = p.product_id
            GROUP BY o.customer_id) AS avg_spending
);
				
-- Q12. Find the second highest product price (no LIMIT/OFFSET).
SELECT MAX(price) AS second_highest_price
FROM products
WHERE price < (SELECT MAX(price) FROM products);

-- Q13. Find the single highest-spending customer overall (completed orders, no window functions).
SELECT c.customer_name, SUM(o.quantity * p.price) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN products p ON o.product_id = p.product_id
WHERE o.status = 'Completed'
GROUP BY c.customer_id, c.customer_name
HAVING total_spent = (
    SELECT MAX(total)
    FROM (
        SELECT SUM(o2.quantity * p2.price) AS total
        FROM orders o2
        JOIN products p2 ON o2.product_id = p2.product_id
        WHERE o2.status = 'Completed'
        GROUP BY o2.customer_id
    ) AS all_totals
);

-- Q14. Find all orders placed by customers from the Philippines (no JOINs).
SELECT order_id, order_date 
FROM orders 
WHERE customer_id IN (
    SELECT customer_id 
    FROM customers 
    WHERE country = 'Philippines'
);

-- Top spender per country (completed orders) — Two Ways.
-- Version A — Using a Subquery (Correlated via HAVING):
SELECT c1.country, c1.customer_name, SUM(o1.quantity * p1.price) AS total_spent
FROM customers c1
JOIN orders o1 ON c1.customer_id = o1.customer_id
JOIN products p1 ON o1.product_id = p1.product_id
WHERE o1.status = 'Completed'
GROUP BY c1.country, c1.customer_id, c1.customer_name
HAVING total_spent = (
    SELECT MAX(country_totals.total)
    FROM (
        SELECT c2.country, SUM(o2.quantity * p2.price) AS total
        FROM customers c2
        JOIN orders o2 ON c2.customer_id = o2.customer_id
        JOIN products p2 ON o2.product_id = p2.product_id
        WHERE o2.status = 'Completed'
        GROUP BY c2.country, c2.customer_id
    ) AS country_totals
    WHERE country_totals.country = c1.country
);

-- Version B — Using JOINs + GROUP BY:
SELECT t1.country, t1.customer_name, t1.total_spent
FROM (
    SELECT c.country, c.customer_name, SUM(o.quantity * p.price) AS total_spent
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN products p ON o.product_id = p.product_id
    WHERE o.status = 'Completed'
    GROUP BY c.country, c.customer_id, c.customer_name
) AS t1
LEFT JOIN (
    SELECT c.country, SUM(o.quantity * p.price) AS total_spent
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN products p ON o.product_id = p.product_id
    WHERE o.status = 'Completed'
    GROUP BY c.country, c.customer_id
) AS t2 
    ON t1.country = t2.country 
    AND t1.total_spent < t2.total_spent
WHERE t2.total_spent IS NULL;
