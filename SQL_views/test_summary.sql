CREATE OR REPLACE VIEW vw_ab_test_summary AS
SELECT
    c.variant,

    COUNT(DISTINCT c.customer_id) AS customers,

    COUNT(DISTINCT o.order_id) AS orders,

    SUM(o.total_usd) AS revenue,

    AVG(o.total_usd) AS avg_order_value,

    COUNT(DISTINCT o.order_id) * 1.0
        / COUNT(DISTINCT c.customer_id)
        AS conversion_rate

FROM customers c

LEFT JOIN orders o
    ON c.customer_id = o.customer_id

GROUP BY c.variant;