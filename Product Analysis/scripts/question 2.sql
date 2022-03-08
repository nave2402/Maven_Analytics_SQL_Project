SELECT
	MIN(DATE(website_sessions.created_at)) AS month_start,
    COUNT(orders.order_id) AS orders,
    ROUND(COUNT(orders.order_id) / COUNT(website_sessions.website_session_id),1) AS conv_rate,
    ROUND(SUM(price_usd) / COUNT(website_sessions.website_session_id),1) AS revenue_per_session,
    COUNT(DISTINCT CASE WHEN primary_product_id = 1 THEN orders.order_id ELSE NULL END) AS product_one_orders,
    COUNT(DISTINCT CASE WHEN primary_product_id = 2 THEN orders.order_id ELSE NULL END) AS product_two_orders
FROM website_sessions
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id
WHERE 
	website_sessions.created_at BETWEEN '2012-04-01' AND '2013-04-01'
GROUP BY
		YEAR(website_sessions.created_at),
		MONTH(website_sessions.created_at)
