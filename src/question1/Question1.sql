use ecommerce;


CREATE DATABASE ecommerce;


USE ecommerce;


CREATE TABLE gold_member_users
(
    userid VARCHAR(50),
    signup_date DATE
);

CREATE TABLE users
(
    userid VARCHAR(50),
    signup_date DATE
);

CREATE TABLE product
(
    product_id INT,
    product_name VARCHAR(50),
    price DECIMAL(10,2)
);

CREATE TABLE sales
(
    userid VARCHAR(50),
    created_date DATE,
    product_id INT
);



INSERT INTO gold_member_users
VALUES
('John','2017-09-22'),
('Mary','2017-04-21');

INSERT INTO users
VALUES
('John','2014-09-02'),
('Michel','2015-01-15'),
('Mary','2014-04-11');

INSERT INTO product
VALUES
(1,'Mobile',980),
(2,'Ipad',870),
(3,'Laptop',330);

INSERT INTO sales
VALUES
('John','2017-04-19',2),
('Mary','2019-12-18',1),
('Michel','2020-07-20',3),
('John','2019-10-23',2),
('John','2018-03-19',3),
('Mary','2016-12-20',2),
('John','2016-11-09',1),
('John','2016-05-20',3),
('Michel','2017-09-24',1),
('John','2017-03-11',2),
('John','2016-03-11',1),
('Mary','2016-11-10',1),
('Mary','2017-12-07',2);


SELECT name
FROM sys.tables;



SELECT 'gold_member_users' AS table_name, COUNT(*) AS total_records
FROM gold_member_users

UNION ALL

SELECT 'users', COUNT(*)
FROM users

UNION ALL

SELECT 'sales', COUNT(*)
FROM sales

UNION ALL

SELECT 'product', COUNT(*)
FROM product;



SELECT
    s.userid,
    SUM(p.price) AS total_amount_spent
FROM sales s
JOIN product p
ON s.product_id = p.product_id
GROUP BY s.userid;



SELECT DISTINCT
    created_date AS visit_date,
    userid AS customer_name
FROM sales
ORDER BY created_date;



WITH FirstPurchase AS
(
    SELECT
        u.userid,
        s.created_date,
        p.product_name,
        ROW_NUMBER() OVER
        (
            PARTITION BY u.userid
            ORDER BY s.created_date
        ) AS rn
    FROM users u
    JOIN sales s
        ON u.userid = s.userid
    JOIN product p
        ON s.product_id = p.product_id
)

SELECT
    userid,
    created_date,
    product_name
FROM FirstPurchase
WHERE rn = 1;


WITH PurchaseCount AS
(
    SELECT
        userid,
        product_id,
        COUNT(*) AS item_count,
        ROW_NUMBER() OVER
        (
            PARTITION BY userid
            ORDER BY COUNT(*) DESC
        ) AS rn
    FROM sales
    GROUP BY userid, product_id
)

SELECT
    pc.userid AS customer_name,
    p.product_name,
    pc.item_count
FROM PurchaseCount pc
JOIN product p
ON pc.product_id = p.product_id
WHERE rn = 1;



SELECT userid
FROM users
WHERE userid NOT IN
(
    SELECT userid
    FROM gold_member_users
);



SELECT
    s.userid,
    SUM(p.price) AS amount_spent
FROM sales s
JOIN gold_member_users g
ON s.userid = g.userid
JOIN product p
ON s.product_id = p.product_id
WHERE s.created_date >= g.signup_date
GROUP BY s.userid
ORDER BY s.userid;


SELECT userid
FROM users
WHERE userid LIKE 'M%';



SELECT DISTINCT userid
FROM users;



EXEC sp_rename
'product.price',
'price_value',
'COLUMN';



UPDATE product
SET product_name = 'Iphone'
WHERE product_name = 'Ipad';



EXEC sp_rename
'gold_member_users',
'gold_membership_users';

ALTER TABLE gold_membership_users
ADD Status VARCHAR(3);

UPDATE gold_membership_users
SET Status = 'Yes';

SELECT *
FROM gold_membership_users;

BEGIN TRANSACTION;

DELETE FROM users
WHERE userid = 'John';

SELECT * FROM users;

DELETE FROM users
WHERE userid = 'Michel';

SELECT * FROM users;

ROLLBACK;

SELECT * FROM users;

INSERT INTO product (product_id, product_name, price_value)
VALUES (3, 'Laptop', 330);
SELECT *
FROM product;

SELECT
    product_id,
    product_name,
    price_value,
    COUNT(*) AS duplicate_count
FROM product
GROUP BY
    product_id,
    product_name,
    price_value
HAVING COUNT(*) > 1;