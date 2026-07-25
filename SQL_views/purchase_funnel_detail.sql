CREATE OR REPLACE VIEW vw_purchase_funnel_detail AS

SELECT
    s.session_id,
    s.customer_id,
    s.country,
    s.device,
    s.source,
    DATE(s.start_time) AS session_date,

    MAX(CASE WHEN e.event_type='page_view' THEN 1 ELSE 0 END) AS page_view,

    MAX(CASE WHEN e.event_type='add_to_cart' THEN 1 ELSE 0 END) AS add_to_cart,

    MAX(CASE WHEN e.event_type='checkout' THEN 1 ELSE 0 END) AS checkout,

    MAX(CASE WHEN e.event_type='purchase' THEN 1 ELSE 0 END) AS purchase_event,

    CASE
        WHEN o.order_id IS NOT NULL THEN 1
        ELSE 0
    END AS order_created

FROM sessions s

LEFT JOIN events e
    ON s.session_id = e.session_id

LEFT JOIN orders o
    ON s.customer_id = o.customer_id
       AND DATE(o.order_time) = DATE(s.start_time)

GROUP BY
    s.session_id,
    s.customer_id,
    s.country,
    s.device,
    s.source,
    DATE(s.start_time),
    o.order_id;