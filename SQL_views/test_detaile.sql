CREATE OR REPLACE VIEW vw_ab_test_detailed AS
SELECT
    c.variant,

    c.country,

    o.device,

    o.source,

    CAST(o.order_time AS DATE) AS order_date,

    COUNT(DISTINCT c.customer_id) AS customers,

    COUNT(DISTINCT o.order_id) AS orders,

    SUM(o.total_usd) AS revenue,

    AVG(o.total_usd) AS avg_order_value

FROM customers c

LEFT JOIN orders o
    ON c.customer_id = o.customer_id

GROUP BY
    c.variant,
    c.country,
    o.device,
    o.source,
    CAST(o.order_time AS DATE);