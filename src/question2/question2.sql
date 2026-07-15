CREATE TABLE product_details
(
    sell_date DATE,
    product VARCHAR(50)
);

INSERT INTO product_details
VALUES
('2020-05-30','Headphones'),
('2020-06-01','Pencil'),
('2020-06-02','Mask'),
('2020-05-30','Basketball'),
('2020-06-01','Book'),
('2020-06-02','Mask'),
('2020-05-30','T-Shirt');

SELECT
    sell_date,
    COUNT(DISTINCT product) AS total_products,
    STRING_AGG(product, ', ') AS product_names
FROM
(
    SELECT DISTINCT sell_date, product
    FROM product_details
) AS p
GROUP BY sell_date
ORDER BY sell_date;