-- Q1. Count the total number of orders in the orders table. Name the column total_orders.
SELECT COUNT(order_id) AS total_orders
FROM orders;

-- Q2. Find the total revenue across all completed orders. Revenue = quantity × price. Name the column total_revenue.
SELECT SUM(o.quantity*p.price) AS total_revenue
FROM orders o
JOIN products p ON o.product_id = p.product_id
WHERE o.status = 'Completed';

-- Q3. Get the average product price across all products. Name the column avg_price.
SELECT AVG(price) AS avg_price
FROM products;

-- Q4. Find the most expensive and cheapest product price. Name the columns max_price and min_price.
SELECT MAX(price) AS max_price, MIN(price) AS min_price
FROM products;

-- Q5. Count how many orders each customer has placed. Show customer_name and order_count. Include all customers — even those with zero orders.
SELECT c.customer_name AS customer_name, COUNT(o.order_id) as order_count
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id;

-- Q6. Show total revenue per product. Show product_name and total_revenue. Only completed orders. Sort highest to lowest.
SELECT p.product_name, SUM(p.price*o.quantity) AS total_revenue
FROM orders o 
JOIN products p ON o.product_id = p.product_id
WHERE o.status = "Completed"
GROUP BY o.product_id
ORDER BY total_revenue DESC;

-- Q7. Show total quantity ordered per product category. Show category and total_quantity. All order statuses included.
SELECT p.category AS category, SUM(o.quantity) AS total_quantity
FROM products p 
JOIN orders o ON p.product_id = o.product_id
GROUP BY p.category;

-- Q8. Count how many orders exist per status. Show status and order_count.
SELECT status, COUNT(order_id) as order_count
FROM orders
GROUP BY status;

-- Q9. Find customers who have placed more than 1 order. Show customer_name and order_count.
SELECT c.customer_name, COUNT(o.order_id) AS order_count
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
HAVING order_count > 1;

-- Q10. Show product categories where the total quantity ordered exceeds 5. Show category and total_quantity.
SELECT p.category as category, SUM(o.quantity) as total_quantity
FROM products p 
JOIN orders o ON p.product_id = o.product_id
GROUP BY p.category
HAVING total_quantity > 5;

-- Q11. Find products that have been ordered at least twice. Show product_name and times_ordered.
SELECT p.product_name as product_name, COUNT(o.order_id) as times_ordered
FROM products p 
JOIN orders o ON p.product_id = o.product_id
GROUP BY p.product_id
HAVING times_ordered >= 2;

-- Q12. Show total revenue per customer — but only for completed orders AND only show customers whose total revenue exceeds 10,000. Show customer_name and total_revenue.
SELECT c.customer_name, SUM(p.price*o.quantity) as total_revenue
FROM customers c 
JOIN orders o ON c.customer_id = o.customer_id
JOIN products p ON o.product_id = p.product_id
WHERE o.status = "Completed"
GROUP BY c.customer_id
HAVING total_revenue > 10000;

-- Q13. Show the average order quantity per product. Only include products where the average quantity is greater than 1. Show product_name and avg_quantity.
SELECT product_name, AVG(quantity) as avg_quantity
FROM products p
JOIN orders o ON p.product_id = o.product_id
GROUP BY p.product_id
HAVING avg_quantity > 1; 

-- Q14. Show each customer's total spent, number of orders, and average spend per order. Only completed orders. Show customer_name, total_spent, order_count, and avg_per_order. Sort by total_spent descending.
SELECT customer_name, SUM(price*quantity) as total_spent, COUNT(order_id) as order_count, AVG(price*quantity) as avg_per_order
FROM customers c 
LEFT JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN products p ON o.product_id = p.product_id
WHERE status = "Completed"
GROUP BY c.customer_id, customer_name
ORDER BY total_spent DESC;

-- Q15. Find the top-spending country. Show country and total_spent from completed orders only. Only include countries where total spending exceeds 50,000. Sort highest to lowest.
SELECT country, SUM(price*quantity) as total_spent
FROM customers c 
LEFT JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN products p ON o.product_id = p.product_id
WHERE status = "Completed"
GROUP BY country
HAVING total_spent > 50000
ORDER BY total_spent DESC;
