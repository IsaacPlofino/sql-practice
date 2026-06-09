/*1. SHOW: customer_name, product_name, order_date
  2. LIVE: customers + orders + products
  3. WANT: all rows, no filter
  4. COLLAPSE: no
  5. POST-FILTER: no
Q1. Show all orders with the customer's name and product name. Show customer_name, product_name, and order_date. */
SELECT customer_name, product_name, order_date
FROM customers 
JOIN orders USING (customer_id)
JOIN products USING (product_id); 

/*1. SHOW: customer_name, COUNT(order_id) AS order_count
  2. LIVE: customers + orders — LEFT JOIN (need to keep unmatched customers)
  3. WANT: all rows, no filter
  4. COLLAPSE: using customer_id, customer_name
  5. POST-FILTER: no
Q2. Show all customers and how many orders they've placed. Include customers with zero orders. Show customer_name and order_count. */
SELECT customer_name, COUNT(order_id) AS order_count
FROM customers 
LEFT JOIN orders USING (customer_id)
GROUP BY customer_id, customer_name;

/*1. SHOW: category, product_name, max_price
  2. LIVE: products
  3. WANT: all rows, no filter
  4. COLLAPSE: using category
  5. POST-FILTER: no
Q3. Find the most expensive product in each category. Show category and max_price. */
SELECT category, MAX(price) AS max_price
FROM products
GROUP BY category;

/*1. SHOW: customer_name, SUM(quantity*price) AS total_revenue
  2. LIVE: customers + orders + products
  3. WANT: status = Completed
  4. COLLAPSE: Per customer only
  5. POST-FILTER: no
Q4. Show total revenue per customer from completed orders only. Show customer_name and total_revenue. */
SELECT c.customer_name, SUM(o.quantity*p.price) AS total_revenue
FROM customers c
JOIN orders o USING (customer_id)
JOIN products p USING (product_id)
WHERE o.status = 'Completed'
GROUP BY c.customer_id, c.customer_name
ORDER BY total_revenue DESC;

/*1. SHOW: customer_name, COUNT(order_id) AS order_count
  2. LIVE: customers + orders 
  3. WANT: status = Completed 
  4. COLLAPSE: Per customer only
  5. POST-FILTER: order_count > 1
Q5. Find customers who have placed more than one completed order. Show customer_name and order_count. */
SELECT customer_name, COUNT(order_id) AS order_count
FROM customers 
JOIN orders USING (customer_id)
WHERE status = 'Completed'
GROUP BY customer_id, customer_name
HAVING order_count > 1;

/*1. SHOW: product_name, COALESCE(SUM(quantity), 0) AS total_quantity
  2. LIVE: products + orders — LEFT JOIN (need to keep unmatched products)
  3. WANT: none
  4. COLLAPSE: Per product_id, product_name
  5. POST-FILTER: none
Q6. Show each product's name and total quantity ever ordered across all statuses. Show product_name and total_quantity. Include products never ordered — show zero. */
SELECT product_name, COALESCE(SUM(quantity), 0) AS total_quantity
FROM products
LEFT JOIN orders USING (product_id)
GROUP BY product_id, product_name
ORDER BY total_quantity DESC;

/*1. SHOW: customer_name, COUNT(order_id) AS order_count
  2. LIVE: customers + orders — LEFT JOIN (need to keep unmatched customers in the Philippines)
  3. WANT: country = 'Philippines'
  4. COLLAPSE: Per customer_id, customer_name
  5. POST-FILTER: none
Q7. List all customers from the Philippines with their total number of orders. Show customer_name and order_count. Include Philippine customers with zero orders. */
SELECT customer_name, COUNT(order_id) AS order_count
FROM customers
LEFT JOIN orders USING (customer_id)
WHERE country = 'Philippines'
GROUP BY customer_id, customer_name
ORDER BY order_count DESC;

/*1. SHOW: category, AVG(price*quantity) AS avg_revenue
  2. LIVE: products + orders
  3. WANT: status = 'Completed' 
  4. COLLAPSE: Per category 
  5. POST-FILTER: none
Q8. Find the average order revenue (quantity × price) per product category. Completed orders only. Show category and avg_revenue. */
SELECT category, AVG(price*quantity) AS avg_revenue
FROM products
JOIN orders USING (product_id)
WHERE status = 'Completed'
GROUP BY category;

/*1. SHOW: product_name, SUM(price*quantity) AS total_revenue
  2. LIVE: products + orders
  3. WANT: status = 'Completed'
  4. COLLAPSE: per product
  5. POST-FILTER: none
Q9. Show the top 3 highest revenue products from completed orders only. Show product_name and total_revenue. Sorted highest to lowest. */
SELECT product_name, SUM(price*quantity) AS total_revenue
FROM products 
JOIN orders USING (product_id)
WHERE status = 'Completed'
GROUP BY product_id, product_name
ORDER BY total_revenue DESC
LIMIT 3;

/*1. SHOW: country, SUM(price*quantity) AS total_revenue
  2. LIVE: customers + orders + products
  3. WANT: status = 'Completed'
  4. COLLAPSE: per country
  5. POST-FILTER: total_revenue > 50000
Q10. Show each country and its total revenue from completed orders. Only include countries where total revenue exceeds ₱50,000. Show country and total_revenue. Sorted highest to lowest. */
SELECT country, SUM(price*quantity) AS total_revenue
FROM customers 
JOIN orders USING (customer_id)
JOIN products USING (product_id)
WHERE status = 'Completed'
GROUP BY country
HAVING total_revenue > 50000
ORDER BY total_revenue DESC;
