-- 1. SHOW: DISTINCT customer_name
-- 2. LIVE: customers + orders         | JOIN TYPE: inner 
-- 3. WANT: completed orders
-- 4. COLLAPSE: none
-- 5. POST-FILTER: none
-- 6. WINDOW FN: none    | PARTITION BY:     | ORDER IN OVER:
-- 7. SUBQUERY TYPE: [ ] WHERE  [ ] FROM  [ ] SELECT  [ ] HAVING  [ * ] NONE

/*Q1 — Basic JOIN + Filter. 
List the names of all customers who have placed at least one 'completed' order. Show each customer name only once.*/
SELECT DISTINCT customer_name
FROM customers
JOIN orders USING (customer_id)
WHERE status = 'Completed';


-- 1. SHOW: customer_name, COUNT(o.order_id)
-- 2. LIVE: customers c + orders o          | JOIN TYPE: left
-- 3. WANT: none
-- 4. COLLAPSE: group per customer_name, customer_id
-- 5. POST-FILTER: none
-- 6. WINDOW FN:  none    | PARTITION BY:     | ORDER IN OVER:
-- 7. SUBQUERY TYPE: [ ] WHERE  [ ] FROM  [ ] SELECT  [ ] HAVING  [ * ] NONE
/*Q2 — LEFT JOIN + Zero Detection. 
List all customers and the total number of orders they have placed. Include customers who have placed zero orders. Show: customer_name, total_orders. Sort by total_orders descending.*/
SELECT c.customer_name, COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o USING (customer_id)
GROUP by c.customer_id, c.customer_name
ORDER BY total_orders DESC;

-- 1. SHOW: product_name, SUM(quantity) AS total_quantity_ordered
-- 2. LIVE: products + orders         | JOIN TYPE: inner
-- 3. WANT: none
-- 4. COLLAPSE: per product_name and product_id
-- 5. POST-FILTER: total_quantity_ordered > 2
-- 6. WINDOW FN:  NONE   | PARTITION BY:     | ORDER IN OVER:
-- 7. SUBQUERY TYPE: [ ] WHERE  [ ] FROM  [ ] SELECT  [ ] HAVING  [ * ] NONE
/*Q3 — Aggregation + HAVING. 
Find all products that have been ordered more than twice (total quantity across all orders, regardless of status). Show: product_name, total_quantity_ordered. 
Sort by total_quantity_ordered descending. */
SELECT product_name, SUM(quantity) AS total_quantity_ordered
FROM orders
JOIN products USING (product_id)
GROUP BY product_id, product_name
HAVING total_quantity_ordered > 2
ORDER BY total_quantity_ordered DESC;

-- 1. SHOW: order_id, customer_id, quantity
-- 2. LIVE: orders         | JOIN TYPE:
-- 3. WANT: quantity > subquery of avg quantity
-- 4. COLLAPSE: none
-- 5. POST-FILTER: none
-- 6. WINDOW FN:  none   | PARTITION BY:     | ORDER IN OVER:
-- 7. SUBQUERY TYPE: [ * ] WHERE  [ ] FROM  [ ] SELECT  [ ] HAVING  [ * ] NONE
/*Q4 — Subquery in WHERE. 
List all orders where the quantity ordered is above the average quantity across all orders. Show: order_id, customer_id, quantity.*/
SELECT order_id, customer_id, quantity
FROM orders
WHERE quantity > (
	SELECT AVG(quantity)
    FROM orders
    )
 ;   

-- 1. SHOW: product_name, price, CASE of price tier
-- 2. LIVE:    products      | JOIN TYPE:
-- 3. WANT: none
-- 4. COLLAPSE: none
-- 5. POST-FILTER: none
-- 6. WINDOW FN:  none    | PARTITION BY:     | ORDER IN OVER:
-- 7. SUBQUERY TYPE: [ ] WHERE  [ ] FROM  [ ] SELECT  [ ] HAVING  [ * ] NONE
/*Q5 — CASE WHEN
Categorize each product by price:

'Budget' if price < ₱1,000
'Mid-range' if price is between ₱1,000 and ₱10,000 (inclusive)
'Premium' if price > ₱10,000

Show: product_name, price, price_tier. Sort by price ascending. */

SELECT product_name, price,
	CASE 
		WHEN price > 10000 THEN 'Premium'
        WHEN price >= 1000 THEN 'Mid-range'
        ELSE 'Budget'
	END AS price_tier
FROM products
ORDER BY price;

-- 1. SHOW: country, SUM(price*quantity) AS total_revenue
-- 2. LIVE:  customers + orders + products        | JOIN TYPE: inner
-- 3. WANT: status = 'Completed' 
-- 4. COLLAPSE: GROUP BY country
-- 5. POST-FILTER: total_revenue > 50000
-- 6. WINDOW FN:  none   | PARTITION BY:     | ORDER IN OVER:
-- 7. SUBQUERY TYPE: [ ] WHERE  [ ] FROM  [ ] SELECT  [ ] HAVING  [ * ] NONE
/*Q6 — Aggregation + GROUP BY + Filter
For each country, find the total revenue generated from 'completed' orders only. Revenue = quantity × price. 
Show: country, total_revenue. Only include countries with total revenue above ₱50,000. Sort by total_revenue descending.*/

SELECT country, SUM(price*quantity) AS total_revenue
FROM customers 
JOIN orders USING (customer_id)
JOIN products USING (product_id)
WHERE status = 'Completed'
GROUP BY country
HAVING total_revenue > 50000
ORDER BY total_revenue DESC;

-- 1. SHOW: product_name, SUM(quantity) AS total_quantity_sold, RANK(total_quantity_sold) OVER(ORDER BY total_quantity_sold) AS sales_rank
-- 2. LIVE: subquery products + orders         | JOIN TYPE: INNER
-- 3. WANT: none
-- 4. COLLAPSE: none
-- 5. POST-FILTER: none
-- 6. WINDOW FN: RANK    | PARTITION BY:     | ORDER IN OVER: total_quantity_sold DESC
-- 7. SUBQUERY TYPE: [ ] WHERE  [ * ] FROM  [ ] SELECT  [ ] HAVING  [  ] NONE
/*Q7 — Window Function: RANK
Rank all products by their total quantity sold (across all statuses). Show: product_name, total_quantity_sold, sales_rank. 
Use RANK() — ties should share a rank. Sort by sales_rank ascending. */
SELECT product_name, total_quantity_sold, RANK() OVER(ORDER BY total_quantity_sold DESC) AS sales_rank
FROM (
	SELECT product_name, SUM(quantity) AS total_quantity_sold
    FROM products
    JOIN orders USING (product_id)
    GROUP BY product_id, product_name
    ) total
ORDER BY sales_rank ASC;
    

-- 1. SHOW: order_id, order_date, quantity, SUM(quantity) OVER(ORDER BY order_date) AS running_total
-- 2. LIVE: orders         | JOIN TYPE: none
-- 3. WANT: none
-- 4. COLLAPSE: none
-- 5. POST-FILTER: none
-- 6. WINDOW FN:  SUM   | PARTITION BY: none    | ORDER IN OVER: order_date
-- 7. SUBQUERY TYPE: [ ] WHERE  [ ] FROM  [ ] SELECT  [ ] HAVING  [ * ] NONE
/*Q8 — Window Function: Running Total
Show a running total of order quantities by order_date, ordered chronologically. Show: order_id, order_date, quantity, running_total. 
The running total should accumulate across all orders in date order. */

SELECT order_id, order_date, quantity, SUM(quantity) OVER(ORDER BY order_date) AS running_total
FROM orders;

-- 1. SHOW: order_id, customer_id, order_date, status
-- 2. LIVE:   orders       | JOIN TYPE:
-- 3. WANT: MONTH(order_date) > 3 AND YEAR(order_date) = 2024
-- 4. COLLAPSE: none
-- 5. POST-FILTER: none
-- 6. WINDOW FN:  none   | PARTITION BY:     | ORDER IN OVER:
-- 7. SUBQUERY TYPE: [ ] WHERE  [ ] FROM  [ ] SELECT  [ ] HAVING  [ * ] NONE
/*Q9 — Date Function
List all orders placed in the first quarter of 2024 (January–March). Show: order_id, customer_id, order_date, status. Sort by order_date ascending. */
SELECT order_id, customer_id, order_date, status
FROM orders
WHERE MONTH(order_date) <= 3 AND YEAR(order_date) = 2024
ORDER BY order_date;


-- 1. SHOW: customer_name, SUM(price*quantity) total_revenue
-- 2. LIVE:    customers + orders + products      | JOIN TYPE: LEFT
-- 3. WANT: status = 'Completed'
-- 4. COLLAPSE: per customer_name, customer_id
-- 5. POST-FILTER: none
-- 6. WINDOW FN: none    | PARTITION BY:     | ORDER IN OVER:
-- 7. SUBQUERY TYPE: [ ] WHERE  [ ] FROM  [ ] SELECT  [ ] HAVING  [ * ] NONE
/*Q10 — Multi-condition LEFT JOIN + Aggregation
List all customers and the total revenue they have generated from 'completed' orders only. 
Include customers who have zero completed orders — show 0 for their revenue. Show: customer_name, total_revenue. Sort by total_revenue descending. */

SELECT c.customer_name, COALESCE(SUM(p.price*o.quantity),0) total_revenue
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id AND status = 'Completed' 
LEFT JOIN products p USING (product_id)
GROUP BY c.customer_id, c.customer_name
ORDER BY total_revenue DESC;
