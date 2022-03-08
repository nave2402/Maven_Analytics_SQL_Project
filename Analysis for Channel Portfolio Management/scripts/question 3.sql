  SELECT
		website_sessions.device_type,
        website_sessions.utm_source,
        COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
        COUNT(DISTINCT orders.order_id) AS orders,
        COUNT(DISTINCT orders.order_id) /  COUNT(DISTINCT website_sessions.website_session_id) AS conversion_rate

 FROM website_sessions
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id
WHERE
	website_sessions.created_at BETWEEN '2012-08-22' AND '2012-09-19'
    AND website_sessions.utm_campaign = 'nonbrand'
GROUP BY
		website_sessions.device_type,
        website_sessions.utm_source;
        
                COUNT(DISTINCT CASE WHEN website_sessions.utm_source = 'gsearch' THEN orders.order_id ELSE NULL END) AS gsearch_orders,
        COUNT(DISTINCT CASE WHEN website_sessions.utm_source = 'bsearch' THEN orders.order_id ELSE NULL END) AS bsearch_orders,
		COUNT(DISTINCT CASE WHEN website_sessions.utm_source = 'gsearch' THEN orders.order_id ELSE NULL END)
			/ COUNT(DISTINCT website_sessions.website_session_id) AS gsearch_orders_conversion_rt,
       		COUNT(DISTINCT CASE WHEN website_sessions.utm_source = 'bsearch' THEN orders.order_id ELSE NULL END)
            / COUNT(DISTINCT website_sessions.website_session_id) AS bsearch_orders_conversion_rt  