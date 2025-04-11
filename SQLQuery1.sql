SELECT *
 FROM orders

SELECT *
 FROM order_items

 SELECT *
 FROM customers


 --Query: Find the top to bottam states with the most customers.

 SELECT customer_state, COUNT(*) AS total_customers
FROM customers
GROUP BY customer_state
ORDER BY total_customers DESC


--Query: Find order details with customer and product info (INNER JOIN).
SELECT 
    o.order_id,
    c.customer_id,
    c.customer_city,
    p.product_category_name
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON oi.product_id = p.product_id


-- Find all sellers who sold more than the average number of products per seller
SELECT seller_id, COUNT(*) AS total_sold
FROM order_items
GROUP BY seller_id
HAVING COUNT(*) > (
    SELECT AVG(seller_count)
    FROM (
        SELECT seller_id, COUNT(*) AS seller_count
        FROM order_items
        GROUP BY seller_id
    ) AS avg_sellers
);


--Total and average payment per order.
SELECT 
    order_id,
    SUM(payment_value) AS total_payment,
    AVG(payment_value) AS avg_payment
FROM order_payments
GROUP BY order_id


--Create a view for detailed customer order info.
CREATE VIEW customer_order_summary AS
SELECT 
    o.order_id,
    c.customer_id,
    c.customer_state,
    p.product_category_name,
    op.payment_type,
    op.payment_value
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN order_payments op ON o.order_id = op.order_id;

SELECT * FROM customer_order_summary;



--Indexes improve query speed. Example: add an index on order_id and customer_id
CREATE INDEX idx_order_id ON orders(order_id);
CREATE INDEX idx_customer_id ON customers(customer_id);
