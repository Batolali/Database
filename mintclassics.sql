/* 
Purpose: List all products with stock levels per warehouse. 
Explanation: 
- Joins the 'products' table with the 'warehouses' table using 'warehouseCode'.
- Retrieves product codes, names, warehouse names, and their stock levels.
*/
SELECT p.productCode, p.productName, w.warehouseName, p.quantityInStock
FROM products p
JOIN warehouses w ON p.warehouseCode = w.warehouseCode;

/* 
Purpose: Find customers with outstanding orders. 
Explanation: 
- Joins the 'customers' table with the 'orders' table using 'customerNumber'.
- Filters orders where the 'status' column is not 'Shipped'.
*/
SELECT c.customerName, o.orderNumber, o.orderDate, o.status
FROM customers c
JOIN orders o ON c.customerNumber = o.customerNumber
WHERE o.status != 'Shipped';

/* 
Purpose: Calculate the total sales amount per product line. 
Explanation: 
- Joins the 'productlines', 'products', and 'orderdetails' tables.
- Multiplies 'quantityOrdered' and 'priceEach' to calculate total sales for each product line.
*/
SELECT pl.productLine, SUM(od.quantityOrdered * od.priceEach) AS totalSales
FROM productlines pl
JOIN products p ON pl.productLine = p.productLine
JOIN orderdetails od ON p.productCode = od.productCode
GROUP BY pl.productLine;

/* 
Purpose: Report on employees in each office. 
Explanation: 
- Joins the 'employees' table with the 'offices' table using 'officeCode'.
- Counts the number of employees in each office and groups by office code and city.
*/
SELECT e.officeCode, o.city AS officeCity, COUNT(e.employeeNumber) AS totalEmployees
FROM employees e
JOIN offices o ON e.officeCode = o.officeCode
GROUP BY e.officeCode, o.city;

/* 
Purpose: Find customers who made payments over a specific amount. 
Explanation: 
- Joins the 'customers' table with the 'payments' table using 'customerNumber'.
- Filters rows where 'amount' is greater than 1000.
*/
SELECT c.customerName, p.paymentDate, p.amount
FROM customers c
JOIN payments p ON c.customerNumber = p.customerNumber
WHERE p.amount > 1000;

/* 
Purpose: List products with low stock levels. 
Explanation: 
- Filters the 'products' table for rows where 'quantityInStock' is less than 50.
*/
SELECT productCode, productName, quantityInStock
FROM products
WHERE quantityInStock < 50;

/* 
Purpose: Retrieve all products stored in a specific warehouse. 
Explanation: 
- Filters the 'products' table based on a given 'warehouseCode'.
*/
SELECT productCode, productName, quantityInStock
FROM products
WHERE warehouseCode = 'A';

/* 
Purpose: Identify customers with orders that are not yet shipped. 
Explanation: 
- Joins the 'customers' table with the 'orders' table using 'customerNumber'.
- Filters orders where the 'status' column is not 'Shipped'.
*/
SELECT c.customerName, o.orderNumber, o.status
FROM customers c
JOIN orders o ON c.customerNumber = o.customerNumber
WHERE o.status != 'Shipped';

/* 
Purpose: Calculate the total sales for each product. 
Explanation: 
- Multiplies 'quantityOrdered' and 'priceEach' in the 'orderdetails' table.
- Groups by 'productCode' to summarize total sales for each product.
*/
SELECT productCode, SUM(quantityOrdered * priceEach) AS totalSales
FROM orderdetails
GROUP BY productCode;

/* 
Purpose: Find all employees who report to a specific manager. 
Explanation: 
- Filters the 'employees' table by the 'reportsTo' column.
*/
SELECT employeeNumber, firstName, lastName, jobTitle
FROM employees
WHERE reportsTo = 1002;

/* 
Purpose: Retrieve all orders placed in the last 30 days. 
Explanation: 
- Filters the 'orders' table using the 'orderDate' column.
- Uses the CURRENT_DATE function and arithmetic to filter dates.
*/
SELECT orderNumber, orderDate, status
FROM orders
WHERE orderDate >= CURRENT_DATE - INTERVAL 30 DAY;

/* 
Purpose: Identify the top 5 customers based on total payments. 
Explanation: 
- Summarizes payment amounts in the 'payments' table by 'customerNumber'.
- Orders by total payment in descending order and limits to 5 records.
*/
SELECT customerNumber, SUM(amount) AS totalPayments
FROM payments
GROUP BY customerNumber
ORDER BY totalPayments DESC
LIMIT 5;

/* 
Purpose: Count the total number of products stored in each warehouse. 
Explanation: 
- Groups products by 'warehouseCode' to count the items per warehouse.
*/
SELECT warehouseCode, COUNT(productCode) AS productCount
FROM products
GROUP BY warehouseCode;

/* 
Purpose: Identify customers who have not placed any orders. 
Explanation: 
- Uses a LEFT JOIN between 'customers' and 'orders' tables.
- Filters where 'orderNumber' is NULL to find customers without orders.
*/
SELECT c.customerName, c.customerNumber
FROM customers c
LEFT JOIN orders o ON c.customerNumber = o.customerNumber
WHERE o.orderNumber IS NULL;

/* 
Purpose: Calculate the average payment amount across all transactions. 
Explanation: 
- Uses the AVG function on the 'amount' column in the 'payments' table.
*/
SELECT AVG(amount) AS averagePayment
FROM payments;

/* 
Purpose: Identify products with a low stock level. 
Explanation: 
- Filters the 'products' table for items with 'quantityInStock' below 50.
*/
SELECT productCode, productName, quantityInStock
FROM products
WHERE quantityInStock < 50;

/* 
Purpose: Retrieve all customers grouped by their country. 
Explanation: 
- Groups the 'customers' table by the 'country' column.
- Returns the number of customers in each country.
*/
SELECT country, COUNT(customerNumber) AS customerCount
FROM customers
GROUP BY country;

/* 
Purpose: Identify orders that were shipped late. 
Explanation: 
- Filters the 'orders' table where the 'shippedDate' is greater than the 'requiredDate'.
*/
SELECT orderNumber, orderDate, shippedDate, requiredDate
FROM orders
WHERE shippedDate > requiredDate;
/* 
Purpose: Generate a sequence of dates using a recursive Common Table Expression (CTE).
Explanation:
- Starts from a base date and iteratively adds one day until a target date.
*/
WITH RECURSIVE DateSequence AS (
    SELECT CAST('2024-01-01' AS DATE) AS generatedDate
    UNION ALL
    SELECT DATE_ADD(generatedDate, INTERVAL 1 DAY)
    FROM DateSequence
    WHERE generatedDate < '2024-01-10'
)
SELECT * FROM DateSequence;

/* 
Purpose: Calculate a moving average of total sales over the last 3 orders.
Explanation:
- Uses the `ROWS` clause in a window function to compute the moving average.
*/
SELECT orderNumber, 
       SUM(quantityOrdered * priceEach) AS totalAmount,
       AVG(SUM(quantityOrdered * priceEach)) 
       OVER (ORDER BY orderNumber ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS movingAverage
FROM orderdetails
GROUP BY orderNumber;

/* 
Purpose: Pivot sales data by year.
Explanation:
- Uses conditional aggregation to pivot data from rows into columns.
*/
SELECT customerNumber,
       SUM(CASE WHEN YEAR(orderDate) = 2022 THEN quantityOrdered * priceEach ELSE 0 END) AS sales2022,
       SUM(CASE WHEN YEAR(orderDate) = 2023 THEN quantityOrdered * priceEach ELSE 0 END) AS sales2023
FROM orders
JOIN orderdetails USING (orderNumber)
GROUP BY customerNumber;

/* 
Purpose: Identify overlapping date ranges in orders.
Explanation:
- Compares the start and end dates of orders to detect overlaps.
*/
SELECT a.orderNumber AS order1, b.orderNumber AS order2
FROM orders a, orders b
WHERE a.orderNumber < b.orderNumber
  AND a.requiredDate <= b.shippedDate
  AND b.requiredDate <= a.shippedDate;

/* 
Purpose: Calculate the churn rate by identifying customers with no orders in a specific period.
Explanation:
- Finds customers who made no orders in the last year.
*/
SELECT customerNumber, customerName
FROM customers
WHERE customerNumber NOT IN (
    SELECT customerNumber
    FROM orders
    WHERE YEAR(orderDate) = 2023
);

/* 
Purpose: Create a hierarchy of employees and their managers.
Explanation:
- Joins the `employees` table to itself to establish manager relationships.
*/
SELECT e.employeeNumber AS employee, e.firstName AS employeeName, 
       m.employeeNumber AS manager, m.firstName AS managerName
FROM employees e
LEFT JOIN employees m ON e.reportsTo = m.employeeNumber;

/* 
Purpose: Perform cohort analysis to group customers by their first purchase year.
Explanation:
- Extracts the earliest order date for each customer to define cohorts.
*/
SELECT c.customerNumber, c.customerName, YEAR(MIN(o.orderDate)) AS cohortYear
FROM customers c
JOIN orders o ON c.customerNumber = o.customerNumber
GROUP BY c.customerNumber, c.customerName;

/* 
Purpose: Find the top 5 most popular products based on total quantity sold.
Explanation:
- Aggregates order details and sorts by total quantity sold.
*/
SELECT productCode, SUM(quantityOrdered) AS totalSold
FROM orderdetails
GROUP BY productCode
ORDER BY totalSold DESC
LIMIT 5;

/* 
Purpose: Calculate cumulative sales for each customer.
Explanation:
- Uses a window function to compute cumulative sums.
*/
SELECT customerNumber, orderDate,
       SUM(quantityOrdered * priceEach) 
       OVER (PARTITION BY customerNumber ORDER BY orderDate) AS cumulativeSales
FROM orders
JOIN orderdetails USING (orderNumber);

/* 
Purpose: Identify missing product codes in the sequence.
Explanation:
- Finds gaps between consecutive product codes using `LEAD()` function.
*/
WITH cte_lead_product AS (
    SELECT productCode, 
           LEAD(productCode) OVER (ORDER BY productCode) AS nextProductCode
    FROM products
)
SELECT productCode, nextProductCode
FROM cte_lead_product
WHERE productCode + 1 <> nextProductCode;

/* 
Purpose: Generate dynamic SQL queries to count rows in multiple tables.
Explanation:
- Uses metadata to dynamically create queries for each table.
*/
SELECT CONCAT('SELECT COUNT(*) AS count FROM ', table_name, ';') AS query
FROM information_schema.tables
WHERE table_schema = 'your_database';

/* 
Purpose: Analyze and optimize indexes for a query.
Explanation:
- Uses `EXPLAIN` to understand how indexes are being used in a query.
*/
EXPLAIN SELECT * FROM orders WHERE customerNumber = 103;

/* 
Purpose: Retrieve random rows from a table.
Explanation:
- Orders rows randomly and limits the results to generate a sample.
*/
SELECT * 
FROM customers
ORDER BY RAND()
LIMIT 10;

/* 
Purpose: Merge data from two tables with a full outer join.
Explanation:
- Combines `LEFT JOIN` and `UNION` to simulate a full outer join.
*/
SELECT * FROM customers c
LEFT JOIN orders o ON c.customerNumber = o.customerNumber
UNION
SELECT * 
FROM customers c
RIGHT JOIN orders o ON c.customerNumber = o.customerNumber;

/* 
Purpose: Count the number of products in each product line. 
Explanation: 
- Groups the 'products' table by 'productLine' and counts items in each group.
*/
SELECT productLine, COUNT(productCode) AS productCount
FROM products
GROUP BY productLine;

/* 
Purpose: Calculate total payments made by year. 
Explanation: 
- Extracts the year from 'paymentDate' and groups payments by year.
*/
SELECT YEAR(paymentDate) AS paymentYear, SUM(amount) AS totalPayments
FROM payments
GROUP BY paymentYear;

/* 
Purpose: Retrieve all customers located in specific cities. 
Explanation: 
- Filters the 'customers' table for rows where 'city' is in a given list.
*/
SELECT customerName, city, country
FROM customers
WHERE city IN ('New York', 'San Francisco', 'Los Angeles');

/* 
Purpose: Retrieve orders with total amounts exceeding $10,000. 
Explanation: 
- Joins 'orders' and 'orderdetails' to calculate the total amount per order.
*/
SELECT o.orderNumber, SUM(od.quantityOrdered * od.priceEach) AS totalAmount
FROM orders o
JOIN orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY o.orderNumber
HAVING totalAmount > 10000;

/* 
Purpose: Set stock quantity to 0 for discontinued products. 
Explanation: 
- Updates 'quantityInStock' to 0 for products with 'productLine' marked as discontinued.
*/
UPDATE products
SET quantityInStock = 0
WHERE productLine = 'Discontinued';

/* 
Purpose: Remove customers who have never made a payment. 
Explanation: 
- Deletes rows in the 'customers' table where no payments exist in 'payments'.
*/
DELETE FROM customers
WHERE customerNumber NOT IN (SELECT DISTINCT customerNumber FROM payments);

/* 
Purpose: Identify the top 3 employees based on their total sales. 
Explanation: 
- Joins 'employees', 'customers', and 'orders' to calculate sales by employee.
*/
SELECT e.employeeNumber, e.firstName, e.lastName, SUM(od.quantityOrdered * od.priceEach) AS totalSales
FROM employees e
JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
JOIN orders o ON c.customerNumber = o.customerNumber
JOIN orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY e.employeeNumber
ORDER BY totalSales DESC
LIMIT 3;

/* 
Purpose: Calculate the average stock of products in each warehouse. 
Explanation: 
- Groups the 'products' table by 'warehouseCode' and calculates the average stock.
*/
SELECT warehouseCode, AVG(quantityInStock) AS averageStock
FROM products
GROUP BY warehouseCode;

/* 
Purpose: Find products that have not been ordered. 
Explanation: 
- Uses a LEFT JOIN to find products not referenced in 'orderdetails'.
*/
SELECT p.productCode, p.productName
FROM products p
LEFT JOIN orderdetails od ON p.productCode = od.productCode
WHERE od.productCode IS NULL;

/* 
Purpose: Calculate the total payments received per month. 
Explanation: 
- Extracts the month and year from 'paymentDate' and groups payments by these.
*/
SELECT CONCAT(YEAR(paymentDate), '-', MONTH(paymentDate)) AS paymentMonth, SUM(amount) AS totalPayments
FROM payments
GROUP BY paymentMonth;

/* 
Purpose: Retrieve customers grouped by their credit limit range. 
Explanation: 
- Uses CASE statements to categorize customers into credit limit ranges.
*/
SELECT customerName, creditLimit,
       CASE 
           WHEN creditLimit <= 5000 THEN 'Low'
           WHEN creditLimit BETWEEN 5001 AND 10000 THEN 'Medium'
           ELSE 'High'
       END AS creditCategory
FROM customers;

/* 
Purpose: Retrieve all employees grouped by their office location. 
Explanation: 
- Joins 'employees' with 'offices' to get the office location of each employee.
*/
SELECT e.firstName, e.lastName, o.city AS officeCity
FROM employees e
JOIN offices o ON e.officeCode = o.officeCode
ORDER BY officeCity;

/* 
Purpose: Calculate the total revenue from all orders. 
Explanation: 
- Sums up the product of 'quantityOrdered' and 'priceEach' for all rows in 'orderdetails'.
*/
SELECT SUM(quantityOrdered * priceEach) AS totalRevenue
FROM orderdetails;

/* 
Purpose: Identify customers who consistently place orders each month for at least 6 consecutive months.
Explanation:
- Uses a window function to calculate the difference between the order month and the row number, creating groups for consecutive months.
*/
WITH customer_order_months AS (
    SELECT customerNumber, 
           DATE_FORMAT(orderDate, '%Y-%m') AS orderMonth,
           ROW_NUMBER() OVER (PARTITION BY customerNumber ORDER BY orderDate) - 
           MONTH(orderDate) AS monthGroup
    FROM orders
)
SELECT customerNumber, COUNT(DISTINCT orderMonth) AS consecutiveMonths
FROM customer_order_months
GROUP BY customerNumber, monthGroup
HAVING consecutiveMonths >= 6;

/* 
Purpose: Detect overlapping time intervals in schedules.
Explanation:
- Self-joins a table of schedules to compare each interval with others for overlap.
*/
SELECT a.scheduleID AS schedule1, b.scheduleID AS schedule2
FROM schedules a
JOIN schedules b ON a.scheduleID < b.scheduleID
WHERE a.startTime < b.endTime AND a.endTime > b.startTime;

/* 
Purpose: Generate a calendar heatmap of order counts by day of the week and hour of the day.
Explanation:
- Aggregates orders by day of the week and hour, then creates a pivot-like structure using conditional aggregation.
*/
SELECT DAYNAME(orderDate) AS dayOfWeek,
       SUM(CASE WHEN HOUR(orderDate) BETWEEN 0 AND 5 THEN 1 ELSE 0 END) AS midnightToMorning,
       SUM(CASE WHEN HOUR(orderDate) BETWEEN 6 AND 11 THEN 1 ELSE 0 END) AS morning,
       SUM(CASE WHEN HOUR(orderDate) BETWEEN 12 AND 17 THEN 1 ELSE 0 END) AS afternoon,
       SUM(CASE WHEN HOUR(orderDate) BETWEEN 18 AND 23 THEN 1 ELSE 0 END) AS evening
FROM orders
GROUP BY dayOfWeek;

/* 
Purpose: Identify all products with cumulative sales exceeding 50% of total sales (Pareto principle).
Explanation:
- Calculates a running total of product sales and filters products reaching 50% of the overall total.
*/
WITH product_sales AS (
    SELECT productCode, 
           SUM(quantityOrdered * priceEach) AS totalSales
    FROM orderdetails
    GROUP BY productCode
),
cumulative_sales AS (
    SELECT productCode, totalSales, 
           SUM(totalSales) OVER (ORDER BY totalSales DESC) AS runningTotal,
           SUM(totalSales) OVER () AS grandTotal
    FROM product_sales
)
SELECT productCode, totalSales, runningTotal
FROM cumulative_sales
WHERE runningTotal <= 0.5 * grandTotal;

/* 
Purpose: Simulate a "full outer join" without a UNION, using `FULL OUTER APPLY` in databases like SQL Server.
Explanation:
- Combines data from two tables to include all matching and non-matching rows.
*/
SELECT COALESCE(c.customerName, o.orderNumber) AS key, 
       c.customerName, 
       o.orderNumber
FROM customers c
FULL OUTER JOIN orders o ON c.customerNumber = o.customerNumber;

/* 
Purpose: Detect cycles in hierarchical relationships using a recursive CTE.
Explanation:
- Tracks paths in an organizational hierarchy and checks for cycles by revisiting the same employee.
*/
WITH RECURSIVE hierarchy AS (
    SELECT employeeNumber, reportsTo, 
           CAST(employeeNumber AS CHAR(255)) AS path
    FROM employees
    WHERE reportsTo IS NOT NULL
    UNION ALL
    SELECT e.employeeNumber, e.reportsTo, 
           CONCAT(h.path, '->', e.employeeNumber)
    FROM employees e
    JOIN hierarchy h ON e.reportsTo = h.employeeNumber
    WHERE FIND_IN_SET(e.employeeNumber, h.path) = 0
)
SELECT *
FROM hierarchy
WHERE FIND_IN_SET(employeeNumber, path) > 1;

/* 
Purpose: Rank customers by their average order value and assign them to performance tiers.
Explanation:
- Uses window functions to calculate the average order value and rank customers accordingly.
*/
WITH customer_avg_order AS (
    SELECT customerNumber, 
           AVG(quantityOrdered * priceEach) AS avgOrderValue
    FROM orders o
    JOIN orderdetails od ON o.orderNumber = od.orderNumber
    GROUP BY customerNumber
)
SELECT customerNumber, avgOrderValue,
       CASE 
           WHEN RANK() OVER (ORDER BY avgOrderValue DESC) <= 10 THEN 'Top Tier'
           WHEN RANK() OVER (ORDER BY avgOrderValue DESC) BETWEEN 11 AND 50 THEN 'Middle Tier'
           ELSE 'Low Tier'
       END AS performanceTier
FROM customer_avg_order;

/* 
Purpose: Detect products with fluctuating stock levels over time (e.g., restocking patterns).
Explanation:
- Uses window functions to compare stock levels with previous entries.
*/
SELECT productCode, stockDate, quantityInStock,
       LAG(quantityInStock) OVER (PARTITION BY productCode ORDER BY stockDate) AS previousStock,
       CASE 
           WHEN quantityInStock > LAG(quantityInStock) OVER (PARTITION BY productCode ORDER BY stockDate) THEN 'Restocked'
           WHEN quantityInStock < LAG(quantityInStock) OVER (PARTITION BY productCode ORDER BY stockDate) THEN 'Decreased'
           ELSE 'Stable'
       END AS stockChange
FROM productStocks;

/* 
Purpose: Generate a time-series forecast based on a moving average of previous sales.
Explanation:
- Computes a rolling average of sales and projects the next value.
*/
WITH rolling_avg AS (
    SELECT orderDate, 
           AVG(SUM(quantityOrdered * priceEach)) OVER (ORDER BY orderDate ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) AS movingAverage
    FROM orders o
    JOIN orderdetails od ON o.orderNumber = od.orderNumber
    GROUP BY orderDate
)
SELECT *, movingAverage + (movingAverage - LAG(movingAverage) OVER (ORDER BY orderDate)) AS forecast
FROM rolling_avg;

/* 
Purpose: Identify the top 5 customers with the highest variance in order values.
Explanation:
- Measures variability in customer spending using the VARIANCE aggregate function.
*/
SELECT customerNumber, 
       VARIANCE(quantityOrdered * priceEach) AS orderVariance
FROM orders o
JOIN orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY customerNumber
ORDER BY orderVariance DESC
LIMIT 5;

