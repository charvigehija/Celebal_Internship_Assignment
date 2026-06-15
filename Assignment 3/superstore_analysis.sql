/* =====================================================================
   Data Engineering 003 - Week 3 Assignment
   Superstore Sales Analysis - Subqueries, CTEs, Window Functions
   ===================================================================== */

USE superstore_db;

/* ---------------------------------------------------------------------
   STEP 1: STAGING TABLE
   superstore_raw was created via SSMS Import Flat File Wizard
   and already contains 9994 rows.
   --------------------------------------------------------------------- */

-- Sanity check
-- SELECT COUNT(*) AS total_rows FROM superstore_raw;   -- expect 9994
-- SELECT TOP 5 * FROM superstore_raw;


/* ---------------------------------------------------------------------
   STEP 2: NORMALIZED TABLES
   (Run this section only once - skip if these tables already exist)
   --------------------------------------------------------------------- */

-- CREATE TABLE customers (
--     Customer_ID   VARCHAR(20)  PRIMARY KEY,
--     Customer_Name VARCHAR(100),
--     Segment       VARCHAR(50),
--     Country       VARCHAR(50),
--     City          VARCHAR(50),
--     State         VARCHAR(50),
--     Region        VARCHAR(20)
-- );

-- CREATE TABLE orders (
--     Order_ID    VARCHAR(20) PRIMARY KEY,
--     Order_Date  DATE,
--     Ship_Date   DATE,
--     Ship_Mode   VARCHAR(30),
--     Customer_ID VARCHAR(20) FOREIGN KEY REFERENCES customers(Customer_ID)
-- );

-- CREATE TABLE products (
--     Row_ID       INT PRIMARY KEY,
--     Order_ID     VARCHAR(20) FOREIGN KEY REFERENCES orders(Order_ID),
--     Product_ID   VARCHAR(30),
--     Category     VARCHAR(50),
--     Sub_Category VARCHAR(50),
--     Product_Name VARCHAR(200),
--     Sales        FLOAT,
--     Quantity     INT,
--     Discount     FLOAT,
--     Profit       FLOAT
-- );



-- Populate customers (one row per Customer_ID, resolves duplicates)
INSERT INTO customers (Customer_ID, Customer_Name, Segment, Country, City, State, Region)
SELECT Customer_ID, MAX(Customer_Name), MAX(Segment), MAX(Country), MAX(City), MAX(State), MAX(Region)
FROM superstore_raw
GROUP BY Customer_ID;

-- Populate orders
INSERT INTO orders (Order_ID, Order_Date, Ship_Date, Ship_Mode, Customer_ID)
SELECT DISTINCT Order_ID, Order_Date, Ship_Date, Ship_Mode, Customer_ID
FROM superstore_raw;

-- Populate products
INSERT INTO products (Row_ID, Order_ID, Product_ID, Category, Sub_Category, Product_Name, Sales, Quantity, Discount, Profit)
SELECT DISTINCT Row_ID, Order_ID, Product_ID, Category, Sub_Category, Product_Name, Sales, Quantity, Discount, Profit
FROM superstore_raw;


/* =====================================================================
   STEP 3: REQUIRED QUERIES
   ===================================================================== */

/* ---------------------------------------------------------------------
   Query 1: Orders where sales > average sales   [SUBQUERY]
   --------------------------------------------------------------------- */
SELECT Order_ID, Product_Name, Sales
FROM products
WHERE Sales > (SELECT AVG(Sales) FROM products);


/* ---------------------------------------------------------------------
   Query 2: Highest sales order (line item) for each customer  [SUBQUERY]
   --------------------------------------------------------------------- */
SELECT o.Customer_ID, p.Order_ID, p.Product_Name, p.Sales
FROM products p
JOIN orders o ON p.Order_ID = o.Order_ID
WHERE p.Sales = (
    SELECT MAX(p2.Sales)
    FROM products p2
    JOIN orders o2 ON p2.Order_ID = o2.Order_ID
    WHERE o2.Customer_ID = o.Customer_ID
);


/* ---------------------------------------------------------------------
   Query 3: Total sales per customer   [CTE]
   --------------------------------------------------------------------- */
WITH CustomerSales AS (
    SELECT o.Customer_ID, SUM(p.Sales) AS Total_Sales
    FROM products p
    JOIN orders o ON p.Order_ID = o.Order_ID
    GROUP BY o.Customer_ID
)
SELECT cs.Customer_ID, c.Customer_Name, cs.Total_Sales
FROM CustomerSales cs
JOIN customers c ON cs.Customer_ID = c.Customer_ID
ORDER BY cs.Total_Sales DESC;


/* ---------------------------------------------------------------------
   Query 4: Customers with above-average total sales   [CTE + SUBQUERY]
   (Also answers Mini-Project Q4)
   --------------------------------------------------------------------- */
WITH CustomerSales AS (
    SELECT o.Customer_ID, c.Customer_Name, SUM(p.Sales) AS Total_Sales
    FROM products p
    JOIN orders o ON p.Order_ID = o.Order_ID
    JOIN customers c ON o.Customer_ID = c.Customer_ID
    GROUP BY o.Customer_ID, c.Customer_Name
)
SELECT Customer_ID, Customer_Name, Total_Sales
FROM CustomerSales
WHERE Total_Sales > (SELECT AVG(Total_Sales) FROM CustomerSales)
ORDER BY Total_Sales DESC;


/* ---------------------------------------------------------------------
   Query 5: Rank all customers by total sales   [WINDOW FUNCTION]
   --------------------------------------------------------------------- */
WITH CustomerSales AS (
    SELECT o.Customer_ID, c.Customer_Name, SUM(p.Sales) AS Total_Sales
    FROM products p
    JOIN orders o ON p.Order_ID = o.Order_ID
    JOIN customers c ON o.Customer_ID = c.Customer_ID
    GROUP BY o.Customer_ID, c.Customer_Name
)
SELECT Customer_ID, Customer_Name, Total_Sales,
    RANK() OVER (ORDER BY Total_Sales DESC) AS Sales_Rank
FROM CustomerSales;


/* ---------------------------------------------------------------------
   Query 6: Row number per order within each customer
            [WINDOW FUNCTION + PARTITION BY]
   --------------------------------------------------------------------- */
SELECT
    o.Customer_ID,
    c.Customer_Name,
    p.Order_ID,
    p.Sales,
    ROW_NUMBER() OVER (PARTITION BY o.Customer_ID ORDER BY p.Sales DESC) AS Row_Num
FROM products p
JOIN orders o ON p.Order_ID = o.Order_ID
JOIN customers c ON o.Customer_ID = c.Customer_ID;


/* ---------------------------------------------------------------------
   Query 7: Top 3 customers by total sales   [WINDOW FUNCTION]
   --------------------------------------------------------------------- */
WITH CustomerSales AS (
    SELECT o.Customer_ID, c.Customer_Name, SUM(p.Sales) AS Total_Sales,
        RANK() OVER (ORDER BY SUM(p.Sales) DESC) AS Sales_Rank
    FROM products p
    JOIN orders o ON p.Order_ID = o.Order_ID
    JOIN customers c ON o.Customer_ID = c.Customer_ID
    GROUP BY o.Customer_ID, c.Customer_Name
)
SELECT Customer_ID, Customer_Name, Total_Sales, Sales_Rank
FROM CustomerSales
WHERE Sales_Rank <= 3;


/* ---------------------------------------------------------------------
   Query 8: FINAL COMBINED QUERY
            Customer Name | Total Sales | Rank   [JOIN + CTE + WINDOW]
   --------------------------------------------------------------------- */
WITH CustomerSales AS (
    SELECT o.Customer_ID, SUM(p.Sales) AS Total_Sales
    FROM products p
    JOIN orders o ON p.Order_ID = o.Order_ID
    GROUP BY o.Customer_ID
)
SELECT
    c.Customer_Name,
    cs.Total_Sales,
    RANK() OVER (ORDER BY cs.Total_Sales DESC) AS Sales_Rank
FROM CustomerSales cs
JOIN customers c ON cs.Customer_ID = c.Customer_ID
ORDER BY Sales_Rank;


/* =====================================================================
   MINI PROJECT - CUSTOMER SALES INSIGHTS (Queries 9-13)
   ===================================================================== */

/* ---------------------------------------------------------------------
   Query 9: Top 5 customers by total sales
   --------------------------------------------------------------------- */
WITH CustomerSales AS (
    SELECT o.Customer_ID, c.Customer_Name, SUM(p.Sales) AS Total_Sales,
        RANK() OVER (ORDER BY SUM(p.Sales) DESC) AS Sales_Rank
    FROM products p
    JOIN orders o ON p.Order_ID = o.Order_ID
    JOIN customers c ON o.Customer_ID = c.Customer_ID
    GROUP BY o.Customer_ID, c.Customer_Name
)
SELECT Customer_ID, Customer_Name, Total_Sales, Sales_Rank
FROM CustomerSales
WHERE Sales_Rank <= 5;


/* ---------------------------------------------------------------------
   Query 10: Bottom 5 customers by total sales
   --------------------------------------------------------------------- */
WITH CustomerSales AS (
    SELECT o.Customer_ID, c.Customer_Name, SUM(p.Sales) AS Total_Sales,
        RANK() OVER (ORDER BY SUM(p.Sales) ASC) AS Sales_Rank
    FROM products p
    JOIN orders o ON p.Order_ID = o.Order_ID
    JOIN customers c ON o.Customer_ID = c.Customer_ID
    GROUP BY o.Customer_ID, c.Customer_Name
)
SELECT Customer_ID, Customer_Name, Total_Sales, Sales_Rank
FROM CustomerSales
WHERE Sales_Rank <= 5;


/* ---------------------------------------------------------------------
   Query 11: Customers who placed only one order
   --------------------------------------------------------------------- */
SELECT o.Customer_ID, c.Customer_Name, COUNT(DISTINCT o.Order_ID) AS Order_Count
FROM orders o
JOIN customers c ON o.Customer_ID = c.Customer_ID
GROUP BY o.Customer_ID, c.Customer_Name
HAVING COUNT(DISTINCT o.Order_ID) = 1;


/* ---------------------------------------------------------------------
   Query 12: Customers with above-average total sales
   (Same logic as Query 4 - re-listed here to satisfy mini-project item 4)
   --------------------------------------------------------------------- */
WITH CustomerSales AS (
    SELECT o.Customer_ID, c.Customer_Name, SUM(p.Sales) AS Total_Sales
    FROM products p
    JOIN orders o ON p.Order_ID = o.Order_ID
    JOIN customers c ON o.Customer_ID = c.Customer_ID
    GROUP BY o.Customer_ID, c.Customer_Name
)
SELECT Customer_ID, Customer_Name, Total_Sales
FROM CustomerSales
WHERE Total_Sales > (SELECT AVG(Total_Sales) FROM CustomerSales)
ORDER BY Total_Sales DESC;


/* ---------------------------------------------------------------------
   Query 13: Highest order value (sum of an entire order) per customer
   --------------------------------------------------------------------- */
WITH OrderTotals AS (
    SELECT o.Customer_ID, p.Order_ID, SUM(p.Sales) AS Order_Total
    FROM products p
    JOIN orders o ON p.Order_ID = o.Order_ID
    GROUP BY o.Customer_ID, p.Order_ID
)
SELECT c.Customer_Name, ot.Customer_ID, MAX(ot.Order_Total) AS Highest_Order_Value
FROM OrderTotals ot
JOIN customers c ON ot.Customer_ID = c.Customer_ID
GROUP BY c.Customer_Name, ot.Customer_ID
ORDER BY Highest_Order_Value DESC;
