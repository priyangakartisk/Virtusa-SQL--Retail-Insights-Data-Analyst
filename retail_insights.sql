-- CHECK DATA
SELECT * FROM Products;
SELECT * FROM Categories;
SELECT * FROM SalesTransactions;

-- 1. CREATE TABLES

CREATE TABLE Categories (
    category_id INTEGER PRIMARY KEY,
    category_name TEXT
);

CREATE TABLE Products (
    product_id INTEGER PRIMARY KEY,
    product_name TEXT,
    category_id INTEGER,
    price REAL,
    stock_count INTEGER,
    expiry_date TEXT,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

CREATE TABLE SalesTransactions (
    transaction_id INTEGER PRIMARY KEY,
    product_id INTEGER,
    quantity INTEGER,
    sale_date TEXT,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- 2. INSERT SAMPLE DATA

-- Categories
INSERT INTO Categories VALUES (1, 'Dairy');
INSERT INTO Categories VALUES (2, 'Beverages');
INSERT INTO Categories VALUES (3, 'Snacks');

-- Products
INSERT INTO Products VALUES (101, 'Milk', 1, 50, 60, '2026-04-20');
INSERT INTO Products VALUES (102, 'Cheese', 1, 120, 30, '2026-05-10');
INSERT INTO Products VALUES (103, 'Juice', 2, 80, 100, '2026-04-18');
INSERT INTO Products VALUES (104, 'Chips', 3, 20, 200, '2026-06-01');
INSERT INTO Products VALUES (105, 'Butter', 1, 90, 80, '2026-04-17');

-- Sales Transactions
INSERT INTO SalesTransactions VALUES (1, 101, 10, '2026-04-10');
INSERT INTO SalesTransactions VALUES (2, 103, 20, '2026-04-12');
INSERT INTO SalesTransactions VALUES (3, 104, 15, '2026-03-01');
INSERT INTO SalesTransactions VALUES (4, 101, 5, '2026-03-25');


-- 3. REPORT QUERIES

-- Expiring Soon Products
SELECT product_name, stock_count, expiry_date
FROM Products
WHERE expiry_date <= date('now', '+7 days')
AND stock_count > 50;


-- Dead Stock 
SELECT p.product_name
FROM Products p
WHERE p.product_id NOT IN (
    SELECT DISTINCT product_id
    FROM SalesTransactions
    WHERE sale_date >= date('now', '-60 days')
);


-- Revenue by Category 
SELECT c.category_name,
       SUM(p.price * s.quantity) AS total_revenue
FROM SalesTransactions s
JOIN Products p ON s.product_id = p.product_id
JOIN Categories c ON p.category_id = c.category_id
WHERE strftime('%Y-%m', s.sale_date) = strftime('%Y-%m', 'now', '-1 month')
GROUP BY c.category_name
ORDER BY total_revenue DESC;


