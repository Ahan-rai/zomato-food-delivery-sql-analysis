-- EDA
 USE new_schema2;
 
 SELECT * FROM customers;
 SELECT * FROM deliveries;
 SELECT * FROM orders;
 SELECT * FROM restaurants;
 SELECT * FROM riders;

-- Handling NULL VALVUES

SELECT COUNT(*)
FROM customers
WHERE
coustomer_name IS NULL
OR signup_date IS NULL;

SELECT COUNT(*)
FROM orders
WHERE
order_item IS NULL
OR order_status IS NULL
OR total_amount IS NULL;

SELECT COUNT(*)
FROM restaurants
WHERE
restaurant_name IS NULL
OR city IS NULL;
 
 DELETE FROM ORDERS WHERE order_iteam is NULL; -- USE WHEN WE WANT TO DELETE THE NULL VALUES, SINCE IN ORDER_ITEAM THEIR IS NO NULL VALVES
 INSERT INTO orders(order_iteam) VALUES (); -- USE WHEN WE WANT TO UPDATE THE VALUES
 
 SELECT COUNT(*)
FROM deliveries
WHERE
delivery_status IS NULL
OR delivery_time IS NULL;
 
  SELECT COUNT(*)
FROM riders
WHERE
rider_name IS NULL
OR joining_date IS NULL;


-- -------------------------
-- Analysis and Reports
-- -------------------------

-- Q.1
--  Find the full order-to-delivery journey for a specific order (end-to-end join).
-- 
SELECT 
    o.order_id,
    c.coustomer_name,
    r.restaurant_name,
    o.order_item,
    o.order_date,
    o.order_time,
    o.total_amount,
    o.order_status,
    d.rider_id,
    rd.rider_name,
    d.delivery_status,
    d.delivery_time
FROM
    orders o
        JOIN
    customers c ON o.customer_id = c.customer_id
        JOIN
    restaurants r ON o.restaurant_id = r.restaurant_id
        LEFT JOIN
    deliveries d ON o.order_id = d.order_id
        LEFT JOIN
    riders rd ON d.rider_id = rd.rider_id
WHERE
    o.order_id = 1;

-- Q.2
--  Find Top 5 restaurants that generated the highest total revenue
--
SELECT 
    R.restaurant_id,
    R.restaurant_name,
    O.order_id,
    SUM(O.total_amount) AS toalat_revenue
FROM
    orders AS O
        JOIN
    restaurants AS R ON R.restaurant_id = O.restaurant_id
WHERE
    order_status = 'delivered'
GROUP BY R.restaurant_id , O.order_id, R.restaurant_name
ORDER BY toalat_revenue DESC
LIMIT 5;

-- Q.3
-- Identify customers who have never placed an order.
-- 
SELECT 
    C.customer_id, C.coustomer_name
FROM
     customers AS C
       LEFT JOIN
    orders AS O
    ON C.customer_id = O.customer_id
WHERE
    O.order_id IS NULL;

-- Q.4
-- List all restaurants located in a specific city (e.g. Mumbai).
--
SELECT 
    *
FROM
    restaurants
WHERE
    city = 'pune';

-- Q.5
-- Find the number of restaurants per city.
-- 
SELECT 
    city, COUNT(*) AS total_restarurant
FROM
    restaurants
GROUP BY city
ORDER BY total_restarurant DESC;

-- Q.6
-- Find the total number of orders by order_status.
--
SELECT 
    order_status, COUNT(*) AS order_count
FROM
    orders
GROUP BY order_status
;

-- Q.7
-- Find the busiest day of the week (by number of orders).
--
SELECT DAYNAME(order_date) AS day_of_week, COUNT(*) AS order_count
FROM orders
GROUP BY DAYNAME(order_date)
ORDER BY order_count DESC;

-- Q.8
-- Identify riders who have completed more than 10 deliveries.
--
 SELECT 
    rider_id, COUNT(*) AS delivery_completed
FROM
    deliveries
WHERE
    delivery_status = 'completed'
GROUP BY rider_id
HAVING COUNT(*) > 10
ORDER BY delivery_completed DESC; 
 
 -- Q.9
 -- Find riders who joined in a specific year (e.g. 2024) and their delivery count.
 -- 
SELECT 
    r.rider_name,
    r.rider_id,
    r.joining_date,
    COUNT(d.delivery_id) AS delivery_done
FROM
    riders AS r
        LEFT JOIN
    deliveries AS d ON r.rider_id = d.rider_id
WHERE
    YEAR(r.joining_date) = 2024
GROUP BY r.rider_name , r.rider_id , r.joining_date;

-- Q.10
-- Find the average age of customers.
--
SELECT 
    ROUND(AVG(age), 2)
FROM
    customers;

-- Q.11
-- Find the customer(s) with the highest average order value.
--
SELECT 
    customer_id, ROUND(AVG(total_amount), 2) AS avg_total_amount
FROM
    orders
WHERE
    order_status = 'delivered'
GROUP BY customer_id
ORDER BY avg_total_amount DESC
LIMIT 5;

-- Q.12
--  Identify restaurants that have never received an order.
--
SELECT 
    r.restaurant_id, r.restaurant_name
FROM
    restaurants r
        LEFT JOIN
    orders o ON r.restaurant_id = o.restaurant_id
WHERE
    o.order_id IS NULL;          
    
    -- Q.13
    -- Calculate the total revenue generated (delivered orders only).
    --
   SELECT 
    ROUND(SUM(total_amount), 2) AS total_delivered_revenue
FROM
    orders
WHERE
    order_status = 'delivered';
    
    -- Q.14
    --  List the top 5 cities with the highest number of customers who signed up in the last year of the dataset (2025).
    -- 
    SELECT 
    city, COUNT(*) AS new_signup
FROM
    customers
WHERE
    YEAR(signup_date) = '2025'
GROUP BY city
LIMIT 5;
    
    -- Q.15
    -- Calculate each customer's total spend and total number of completed deliveries received.
    --
    SELECT 
    c.customer_id,
    c.coustomer_name,
    ROUND(SUM(o.total_amount), 2) total_spend,
    COUNT(DISTINCT CASE
            WHEN d.delivery_status = 'Completed' THEN d.delivery_id
        END) AS completed_deliveries
FROM
    customers c
        JOIN
    orders o ON c.customer_id = o.customer_id
        LEFT JOIN
    deliveries d ON o.order_id = d.order_id
GROUP BY c.customer_id , c.coustomer_name
ORDER BY total_spend DESC;


