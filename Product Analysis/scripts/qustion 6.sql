SELECT
	CASE WHEN website_sessions.created_at >= '2013-12-12' THEN 'B.post_Birthday_bear' ELSE 'A.pre_Birthday_bear' END AS time_period,
    ROUND(COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT website_sessions.website_session_id),2) AS conv_rate,
    ROUND(AVG(orders.price_usd),2) AS aov,
    ROUND(SUM(orders.items_purchased) / COUNT(orders.order_id),2) AS product_per_order,
    ROUND(SUM(orders.price_usd) / COUNT(DISTINCT website_sessions.website_session_id),2) AS revenue_per_session
FROM website_sessions
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id
WHERE  
	website_sessions.created_at BETWEEN '2013-11-12' AND '2014-01-12'
GROUP BY 
	time_period;