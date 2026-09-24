----EXPERIMENT 08----------------------

------MEDIUM LEVEL--------------
CREATE TABLE customer_master
(
    customer_id VARCHAR(5) PRIMARY KEY,
    full_name VARCHAR(50) NOT NULL,
      city VARCHAR(30)
);

CREATE TABLE product_catalog
(
    product_id VARCHAR(5) PRIMARY KEY,
    product_name VARCHAR(50) NOT NULL,
    unit_price NUMERIC(10,2) NOT NULL
);

CREATE TABLE sales_orders
(
    order_id SERIAL PRIMARY KEY,
    product_id VARCHAR(5)
        REFERENCES product_catalog(product_id),

    quantity INT NOT NULL,

    customer_id VARCHAR(5)
        REFERENCES customer_master(customer_id),

    discount_percent NUMERIC(5,2),

    order_date DATE NOT NULL
);

INSERT INTO customer_master
(customer_id, full_name, city)
VALUES
('C1', 'Amit Sharma', 'Delhi'),
('C2', 'Priya Verma', 'Mumbai'),
('C3', 'Ravi Kumar', 'Bangalore'),
('C4', 'Neha Singh', 'Kolkata'),
('C5', 'Arjun Mehta', 'Hyderabad');

INSERT INTO product_catalog
(product_id, product_name, unit_price)
VALUES
('P1', 'Smartphone X100', 25000),
('P2', 'Laptop Pro 15', 65000),
('P3', 'Wireless Earbuds', 5000),
('P4', 'Smartwatch Fit', 30000),
('P5', 'Gaming Console', 45000);


INSERT INTO sales_orders
(product_id, quantity, customer_id, discount_percent, order_date)
VALUES
('P1', 2, 'C1', 5, '2025-09-01'),
('P2', 1, 'C2', 10, '2025-09-02'),
('P3', 3, 'C3', 0, '2025-09-03'),
('P4', 1, 'C4', 8, '2025-09-04'),
('P5', 1, 'C5', 12, '2025-09-05'),
('P1', 1, 'C2', 5, '2025-09-06'),
('P3', 2, 'C1', 0, '2025-09-07');












----SOLUTION:
CREATE OR REPLACE VIEW vW_ORDER_PROCESSING
AS
SELECT
    O.order_id,
    O.order_date,
    C.full_name,
    P.product_name,

    (P.unit_price * O.quantity)
    -
    (
        (P.unit_price * O.quantity)
        * O.discount_percent / 100
    ) AS final_amount

FROM customer_master C

JOIN sales_orders O
    ON C.customer_id = O.customer_id

JOIN product_catalog P
    ON P.product_id = O.product_id;




SELECT * FROM vW_ORDER_PROCESSING;



DROP VIEW IF EXISTS vW_ORDER_PROCESSING;

DROP TABLE IF EXISTS sales_orders;
DROP TABLE IF EXISTS product_catalog;
DROP TABLE IF EXISTS customer_master;
------HARD LEVEL--------------


CREATE TABLE category_master (
    category_id VARCHAR(5) PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL
);

CREATE TABLE product_master (
    product_id VARCHAR(5) PRIMARY KEY,
    product_name VARCHAR(50) NOT NULL,
    category_id VARCHAR(5)
        REFERENCES category_master(category_id)
);

CREATE TABLE customer_master (
    customer_id VARCHAR(5) PRIMARY KEY,
    customer_name VARCHAR(50) NOT NULL
);

CREATE TABLE order_details (
    order_id VARCHAR(5) NOT NULL,
    customer_id VARCHAR(5)
        REFERENCES customer_master(customer_id),
    product_id VARCHAR(5)
        REFERENCES product_master(product_id),
    quantity INT NOT NULL,
    unit_price NUMERIC(10,2) NOT NULL
);


INSERT INTO category_master
(category_id, category_name)
VALUES
('C1', 'Electronics'),
('C2', 'Clothing'),
('C3', 'Books');

INSERT INTO product_master
(product_id, product_name, category_id)
VALUES
('P101', 'Laptop', 'C1'),
('P102', 'Headphones', 'C1'),
('P201', 'Jacket', 'C2'),
('P202', 'Shoes', 'C2'),
('P301', 'SQL Book', 'C3');

INSERT INTO customer_master
(customer_id, customer_name)
VALUES
('U1', 'Aman'),
('U2', 'Priya'),
('U3', 'Rahul'),
('U4', 'Simran');

INSERT INTO order_details
(order_id, customer_id, product_id, quantity, unit_price)
VALUES
('O101', 'U1', 'P101', 1, 5000),
('O102', 'U2', 'P102', 2, 1000),
('O103', 'U1', 'P201', 1, 3000),
('O104', 'U3', 'P202', 2, 2000),
('O105', 'U4', 'P301', 3, 500),
('O106', 'U2', 'P101', 1, 5000),
('O107', 'U3', 'P201', 1, 3000),
('O108', 'U4', 'P102', 1, 1000);



--Solution
CREATE MATERIALIZED VIEW mv_category_sales_01
AS

SELECT
    c.category_id,
    c.category_name,

    SUM(od.quantity) AS total_products_sold,

    COUNT(DISTINCT od.order_id) AS total_orders,

    COUNT(DISTINCT od.customer_id) AS unique_customers,

    SUM(od.quantity * od.unit_price) AS total_revenue,

    ROUND(
        SUM(od.quantity * od.unit_price)
        / COUNT(DISTINCT od.order_id),
        2
    ) AS avg_revenue_per_order,

    CASE
        WHEN SUM(od.quantity * od.unit_price) >= 10000
            THEN 'Excellent'

        WHEN SUM(od.quantity * od.unit_price) >= 6000
            THEN 'Good'

        WHEN SUM(od.quantity * od.unit_price) >= 3000
            THEN 'Average'

        ELSE 'Low'
    END AS category_performance

FROM category_master c

JOIN product_master p
    ON c.category_id = p.category_id

JOIN order_details od
    ON p.product_id = od.product_id

GROUP BY
    c.category_id,
    c.category_name;



EXPLAIN ANALYZE 
SELECT * FROM mv_category_sales_01;


REFRESH MATERIALIZED VIEW mv_category_sales_01;




--display materialized view

EXPLAIN ANALYZE
SELECT *
FROM mv_category_sales_01
ORDER BY category_id;
