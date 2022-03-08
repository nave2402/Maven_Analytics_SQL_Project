-- Next , it would be great to see a similar monthly trend for gsearch,
-- but this time splitting out nonbrand and brand campaigns separately.
-- i am wondring if brand is picking up[ at all. if so this is a good story to tell.

SELECT
	MIN(DATE(website_sessions.created_at)) AS month_start,
    COUNT(DISTINCT CASE WHEN utm_campaign = 'nonbrand' THEN website_sessions.website_session_id ELSE NULL END) AS nonbrand_sessions,
	COUNT(DISTINCT CASE WHEN utm_campaign = 'brand' THEN website_sessions.website_session_id ELSE NULL END) AS brand_sessions,
      COUNT(DISTINCT CASE WHEN orders.order_id AND utm_campaign = 'nonbrand' THEN orders.website_session_id ELSE NULL END) AS nonbrand_orders,
     COUNT(DISTINCT CASE WHEN orders.order_id AND utm_campaign = 'brand' THEN orders.website_session_id ELSE NULL END) AS brand_orders   
FROM website_sessions
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id
WHERE 
	website_sessions.created_at <'2012-11-27'
    AND utm_source = 'gsearch'
    AND utm_campaign IN ('nonbrand', 'brand')
GROUP BY
	YEAR(website_sessions.created_at),
	MONTH(website_sessions.created_at)



