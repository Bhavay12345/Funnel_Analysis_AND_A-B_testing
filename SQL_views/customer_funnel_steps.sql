CREATE OR REPLACE VIEW vw_customer_funnel_steps AS
WITH customer_activity AS (
    SELECT
        c.customer_id,

        1 AS registered,

        CASE
            WHEN COUNT(DISTINCT s.session_id) > 0 THEN 1
            ELSE 0
        END AS visited,

        MAX(CASE
                WHEN e.event_type = 'page_view' THEN 1
                ELSE 0
            END) AS page_view,

        MAX(CASE
                WHEN e.event_type = 'add_to_cart' THEN 1
                ELSE 0
            END) AS add_to_cart,

        CASE
            WHEN COUNT(DISTINCT o.order_id) > 0 THEN 1
            ELSE 0
        END AS purchased

    FROM customers c

    LEFT JOIN sessions s
        ON c.customer_id = s.customer_id

    LEFT JOIN events e
        ON s.session_id = e.session_id

    LEFT JOIN orders o
        ON c.customer_id = o.customer_id

    GROUP BY c.customer_id
)

SELECT 'Registered' AS funnel_step,
       SUM(registered) AS customer_count
FROM customer_activity

UNION ALL

SELECT 'Visited',
       SUM(visited)
FROM customer_activity

UNION ALL

SELECT 'Page View',
       SUM(page_view)
FROM customer_activity

UNION ALL

SELECT 'Add To Cart',
       SUM(add_to_cart)
FROM customer_activity

UNION ALL

SELECT 'Purchased',
       SUM(purchased)
FROM customer_activity;