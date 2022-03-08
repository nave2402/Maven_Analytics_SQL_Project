SELECT COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
	   COUNT(orders.order_id) AS orders,
       COUNT(orders.order_id) / COUNT(DISTINCT website_sessions.website_session_id) * 100  AS sessions_to_order_conv_rate 
FROM website_sessions
		LEFT JOIN orders
			ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at < '2012-04-14'
AND  utm_source = 'gsearch'
AND utm_campaign = 'nonbrand'

       