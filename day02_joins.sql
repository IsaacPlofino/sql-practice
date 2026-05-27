-- Q1. Get the customer_name, product_name, and quantity for every completed order.
SELECT c.customer_name, o.quantity, p.product_name
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN products p ON o.product_id = p.product_id
WHERE o.status = 'Completed';

-- Q2. List all orders with the customer's country and the product's category. Show order_id, country, category, and order_date.
SELECT o.order_id, o.order_date, p.category, c.country
FROM customers c
JOIN orders o ON c.customer_id=o.customer_id
JOIN products p ON o.product_id=p.product_id;

--  Q3. Show the total amount spent per customer. Display customer_name and total_spent (quantity × price). Only include completed orders.
SELECT c.customer_name, SUM(o.quantity*p.price) AS total_spent, o.status
FROM customers c
JOIN orders o ON c.customer_id=o.customer_id
JOIN products p ON o.product_id=p.product_id
WHERE o.status LIKE 'completed%'
GROUP BY c.customer_id, c.customer_name, o.status;

-- Q4. List all customers and their orders. Show customer_name and order_id. Customers with no orders should still appear.
SELECT c.customer_name, coalesce(order_id, 'No order') AS order_id
FROM customers c
LEFT JOIN orders o ON c.customer_id=o.customer_id;

-- Q5. Show all customers and the total number of orders they've placed. Name the column order_count. Include customers with zero orders.
SELECT c.customer_name, COUNT(o.order_id) AS order_count
FROM customers c
LEFT JOIN orders o ON c.customer_id=o.customer_id
GROUP BY c.customer_id, c.customer_name;

-- Q6. Find customers who have never placed an order.
SELECT c.customer_name, coalesce(o.order_id, 'No Order') AS Orders
FROM customers c
LEFT JOIN orders o ON c.customer_id=o.customer_id
WHERE o.order_id IS NULL;

-- Q7. List all products and any orders associated with them. Show product_name and order_id. Products with no orders should still appear.
SELECT p.product_name, o.order_id
FROM orders o
RIGHT JOIN products p ON p.product_id=o.product_id;

-- Q8. Show all products and how many times each has been ordered. Name the column times_ordered. Include products never ordered.
SELECT p.product_name, COUNT(o.order_id) AS times_ordered
FROM orders o
RIGHT JOIN products p ON p.product_id=o.product_id
GROUP BY p.product_name, p.product_id;

-- Q9. Show all customers and all orders, including customers with no orders AND orders with no matching customer. Show customer_name and order_id.
SELECT c.customer_name, o.order_id
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id

UNION

SELECT c.customer_name, o.order_id
FROM customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id;

-- Q10. Find both customers who never ordered AND orders with no matching customer. Show customer_name and order_id. Both sides should show NULL where there's no match.
SELECT c.customer_name, o.order_id
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL   

UNION

SELECT c.customer_name, o.order_id
FROM customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id
WHERE c.customer_id IS NULL; 

-- Q11. Show all orders including the one with a NULL customer_id. Display order_id, customer_id, and status.
SELECT order_id, customer_id, status
FROM orders;

-- Q12. Find orders where the customer_id is NULL.
SELECT order_id, customer_id, status
FROM orders
WHERE customer_id IS NULL;

-- Q13. Using a LEFT JOIN, show all orders and their matching customer names. For orders with no customer match, display 'Unknown' instead of NULL. Name the column customer_name.
SELECT coalesce(c.customer_name, 'Unknown') AS customer_name, o.order_id, o.product_id, o.status
FROM orders o 
LEFT JOIN customers c ON o.customer_id=c.customer_id;

-- Q14. Write a single query joining all three tables. Show customer_name, product_name, quantity, price, and a calculated column line_total (quantity × price). Only completed orders.
SELECT c.customer_name, p.product_name, o.quantity, p.price, o.quantity*p.price AS line_total
FROM customers c 
JOIN orders o ON c.customer_id=o.customer_id
JOIN products p ON o.product_id=p.product_id
WHERE o.status = "Completed";

-- Q15. From that same three-table join, rank customers by total amount spent. Show customer_name and total_spent, sorted highest to lowest. Only completed orders.
SELECT c.customer_name, SUM(o.quantity*p.price) AS total_spent
FROM customers c 
JOIN orders o ON c.customer_id=o.customer_id
JOIN products p ON o.product_id=p.product_id
WHERE o.status = "Completed"
GROUP BY c.customer_name, c.customer_id
ORDER BY total_spent DESC;
