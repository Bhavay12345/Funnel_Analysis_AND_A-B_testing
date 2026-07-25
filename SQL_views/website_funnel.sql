CREATE OR REPLACE VIEW vw_website_funnel AS
WITH funnel AS (
    SELECT
        session_id,

        MAX(CASE WHEN event_type='page_view' THEN 1 ELSE 0 END) AS page_view,

        MAX(CASE WHEN event_type='add_to_cart' THEN 1 ELSE 0 END) AS add_to_cart,

        MAX(CASE WHEN event_type='checkout' THEN 1 ELSE 0 END) AS checkout,

        MAX(CASE WHEN event_type='purchase' THEN 1 ELSE 0 END) AS purchase

    FROM events
    GROUP BY session_id
)

SELECT
    COUNT(*) AS sessions,
    SUM(page_view) AS page_views,
    SUM(add_to_cart) AS add_to_carts,
    SUM(checkout) AS checkouts,
    SUM(purchase) AS purchases
FROM funnel;