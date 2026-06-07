
USE superstore;
/*
-- ============================================================
-- DATABASE SETUP - Create Tables
-- ============================================================

-- 1. Customers table
CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    country VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code VARCHAR(20),
    region VARCHAR(50)
);

-- 2. Products table
CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(255),
    unit_price DECIMAL(10,2)
);

-- 3. Orders table
CREATE TABLE orders (
    order_id VARCHAR(50),
    customer_id VARCHAR(50),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(50),
    status VARCHAR(50) DEFAULT 'Delivered',
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- 4. Order Items table
CREATE TABLE order_items (
    row_id INT PRIMARY KEY,
    order_id VARCHAR(50),
    product_id VARCHAR(50),
    quantity INT,
    unit_price DECIMAL(10,2),
    discount_pct DECIMAL(5,2),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Create index on order_date for performance
CREATE INDEX idx_orders_date ON orders(order_date);
*/

-- ============================================================
-- SECTION A: SQL Basics (SELECT, Constraints, Primary Keys)
-- ============================================================

-- Q1: Display all columns and rows from customers table
SELECT * FROM customers;

-- Q2: Retrieve first_name, last_name and city of all customers
SELECT 
    CASE 
        WHEN CHARINDEX(' ', customer_name) > 0 
        THEN SUBSTRING(customer_name, 1, CHARINDEX(' ', customer_name) - 1)
        ELSE customer_name
    END AS first_name,
    CASE 
        WHEN CHARINDEX(' ', customer_name) > 0 
        THEN SUBSTRING(customer_name, CHARINDEX(' ', customer_name) + 1, LEN(customer_name))
        ELSE ''
    END AS last_name,
    city
FROM customers;

-- Q3: List all unique categories in products table
SELECT DISTINCT category FROM products;

-- Q4: Primary Key Explanation (Theory)
-- The customers table uses customer_id as PRIMARY KEY.
-- The products table uses product_id as PRIMARY KEY.
-- The order_items table uses row_id as PRIMARY KEY.
-- Primary Keys must be UNIQUE: No two rows can have the same PK value.
-- Primary Keys must be NOT NULL: A NULL PK means the row cannot be identified.

-- Q5: Constraints on email column (Theory)
-- Email column typically has UNIQUE + NOT NULL constraints.
-- Inserting a duplicate email would raise:
-- "Violation of UNIQUE KEY constraint" and the INSERT is rejected.

-- Q6: INSERT with negative unit_price (no CHECK constraint demo)
INSERT INTO orders (order_id, customer_id, order_date, ship_date, ship_mode, status, total_amount)
VALUES ('TEST-001', 'AA-10315', GETDATE(), GETDATE(), 'Standard Class', 'Pending', -50);
-- Result: Inserted successfully (no CHECK constraint defined)
-- To prevent this, add: ALTER TABLE orders ADD CONSTRAINT chk_amount CHECK (total_amount >= 0);
-- After adding constraint, the same INSERT would raise: "CHECK constraint conflict"
DELETE FROM orders WHERE order_id = 'TEST-001'; -- Cleanup

-- ============================================================
-- SECTION B: Filtering & Optimization (WHERE, Indexes)
-- ============================================================

-- Q7: Retrieve all orders with status = 'Delivered'
SELECT * FROM orders WHERE status = 'Delivered';

-- Q8: Find all products in 'Technology' category with unit_price > 2000
SELECT * FROM products 
WHERE category = 'Technology' 
AND unit_price > 2000;

-- Q9: List customers who belong to state 'Maharashtra'
-- Note: Superstore is a US dataset, so 0 results expected (correct behavior)
SELECT * FROM customers 
WHERE state = 'Maharashtra';

-- Q10: Find orders placed between two dates that are NOT cancelled
SELECT * FROM orders 
WHERE order_date BETWEEN '2016-01-01' AND '2016-12-31'
AND status != 'Cancelled';

-- Q11: Index on order_date explanation (Theory)
-- The index idx_orders_date on orders(order_date) improves performance
-- of queries that filter by order_date, avoiding full table scans.
-- Already created above: CREATE INDEX idx_orders_date ON orders(order_date);

-- Q12: SARGable query using index on order_date
-- Non-SARGable (index NOT used): WHERE YEAR(order_date) = 2016
-- SARGable (index IS used): WHERE order_date >= '2016-01-01' AND order_date < '2017-01-01'
SELECT * FROM orders 
WHERE order_date >= '2016-01-01' 
AND order_date < '2017-01-01';

-- ============================================================
-- SECTION C: Aggregation (GROUP BY, SUM, COUNT, AVG, MIN, MAX)
-- ============================================================

-- Q13: Count total number of orders
SELECT COUNT(*) AS total_orders FROM orders;

-- Q14: Total revenue from all 'Delivered' orders
SELECT SUM(total_amount) AS total_revenue 
FROM orders 
WHERE status = 'Delivered';

-- Q15: Average unit_price of products in each category
SELECT category, AVG(unit_price) AS avg_unit_price 
FROM products 
GROUP BY category;

-- Q16: For each order status, count of orders and total revenue (descending)
SELECT status, COUNT(*) AS order_count, SUM(total_amount) AS total_revenue 
FROM orders 
GROUP BY status 
ORDER BY total_revenue DESC;

-- Q17: Most expensive and cheapest product in each category
SELECT category, 
    MAX(unit_price) AS most_expensive, 
    MIN(unit_price) AS cheapest 
FROM products 
GROUP BY category;

-- Q18: Categories where average unit_price > 200 (HAVING clause)
SELECT category, AVG(unit_price) AS avg_price 
FROM products 
GROUP BY category 
HAVING AVG(unit_price) > 200;

-- ============================================================
-- SECTION D: Joins & Relationships
-- ============================================================

-- Q19: INNER JOIN - orders with customer first_name, last_name, total_amount
SELECT o.order_id, o.order_date,
    SUBSTRING(c.customer_name, 1, CHARINDEX(' ', c.customer_name + ' ') - 1) AS first_name,
    SUBSTRING(c.customer_name, CHARINDEX(' ', c.customer_name + ' ') + 1, LEN(c.customer_name)) AS last_name,
    o.total_amount
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id;

-- Q20: LEFT JOIN - all customers and their orders (NULLs for customers with no orders)
SELECT c.customer_id, c.customer_name, o.order_id, o.order_date, o.total_amount
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;

-- Q21: JOIN across 3 tables - orders, order_items, products
SELECT o.order_id, p.product_name, oi.quantity, oi.unit_price, oi.discount_pct
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id;

-- Q22: LEFT JOIN vs RIGHT JOIN vs FULL OUTER JOIN (Theory)
-- LEFT JOIN: All rows from left table, NULLs for unmatched right rows
-- RIGHT JOIN: All rows from right table, NULLs for unmatched left rows
-- FULL OUTER JOIN: All rows from both tables, NULLs where no match
-- Use FULL OUTER JOIN when you want to see all records from both sides.

-- Q23: Foreign Key relationships (Theory)
-- orders.customer_id -> customers.customer_id
-- order_items.product_id -> products.product_id
-- If you INSERT an order with customer_id = 999 (not in customers table):
-- Error: "The INSERT statement conflicted with the FOREIGN KEY constraint"

-- ============================================================
-- SECTION E: Advanced Concepts (CASE, ACID, Transactions)
-- ============================================================

-- Q24: CASE to classify products into price tiers
SELECT product_name, unit_price,
    CASE 
        WHEN unit_price < 1000 THEN 'Budget'
        WHEN unit_price BETWEEN 1000 AND 3000 THEN 'Mid-Range'
        WHEN unit_price > 3000 THEN 'Premium'
    END AS price_tier
FROM products;

-- Q25: CASE inside aggregate - count Delivered vs Not Delivered
SELECT 
    SUM(CASE WHEN status = 'Delivered' THEN 1 ELSE 0 END) AS delivered,
    SUM(CASE WHEN status != 'Delivered' THEN 1 ELSE 0 END) AS not_delivered
FROM orders;

-- Q26: ACID Properties (Theory)
-- A - Atomicity: All steps in a transaction succeed or all fail together.
--     Example: Bank transfer debits AND credits, or neither happens.
-- C - Consistency: DB moves from one valid state to another, constraints never violated.
-- I - Isolation: Concurrent transactions don't interfere with each other.
-- D - Durability: Committed data is permanently saved even after system crash.

-- Q27: Complete Transaction with BEGIN...COMMIT/ROLLBACK
BEGIN TRANSACTION;

INSERT INTO orders (order_id, customer_id, order_date, ship_date, ship_mode, status, total_amount)
VALUES ('CA-2024-999999', 'AA-10315', GETDATE(), GETDATE(), 'Standard Class', 'Pending', 1598.00);

INSERT INTO order_items (row_id, order_id, product_id, quantity, unit_price, discount_pct)
VALUES (99991, 'CA-2024-999999', 'FUR-BO-10001798', 2, 799.00, 0.0);

INSERT INTO order_items (row_id, order_id, product_id, quantity, unit_price, discount_pct)
VALUES (99992, 'CA-2024-999999', 'FUR-CH-10000454', 1, 799.00, 0.0);

COMMIT;

-- Verify the transaction
SELECT * FROM orders WHERE order_id = 'CA-2024-999999';

-- ============================================================
-- BONUS: Business Queries (Assignment Step 6 & 7)
-- ============================================================

-- Monthly Sales Trends
SELECT 
    YEAR(order_date) AS year,
    MONTH(order_date) AS month,
    COUNT(*) AS total_orders,
    SUM(total_amount) AS monthly_revenue
FROM orders
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY year, month;

-- Top 10 Customers by Total Spending
SELECT TOP 10 c.customer_name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY total_spent DESC;

-- Find Duplicate Orders
SELECT order_id, COUNT(*) AS count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

-- Row Count Validation
SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM customers UNION ALL
SELECT 'products', COUNT(*) FROM products UNION ALL
SELECT 'orders', COUNT(*) FROM orders UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items;

-- Data Quality Check (NULL values)
SELECT 
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS null_customer_id,
    SUM(CASE WHEN order_date IS NULL THEN 1 ELSE 0 END) AS null_order_date,
    SUM(CASE WHEN total_amount IS NULL THEN 1 ELSE 0 END) AS null_total_amount,
    SUM(CASE WHEN status IS NULL THEN 1 ELSE 0 END) AS null_status
FROM orders;

-- ============================================================
-- END OF ASSIGNMENT
-- ============================================================