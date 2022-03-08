-- while we're on gsearch, could you dive into nonbrand, and pull monthly sessions and orders split by device type?
-- i want to flex our analytical muscles a little and show the board we really know our traffic sources.
SELECT
	MIN(DATE(website_sessions.created_at)) AS month_start,
    COUNT(DISTINCT CASE WHEN device_type = 'desktop' THEN website_sessions.website_session_id ELSE NULL END) AS desktop_sessions,
	COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN website_sessions.website_session_id ELSE NULL END) AS mobile_sessions,
    COUNT(DISTINCT CASE WHEN device_type = 'desktop' THEN orders.order_id ELSE NULL END) AS desktop_orders,
	COUNT(DISTINCT CASE WHEN device_type = 'mobile'  THEN orders.order_id ELSE NULL END) AS mobile_orders
FROM website_sessions
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id
WHERE
	website_sessions.created_at < '2012-11-27'
    AND utm_campaign = 'nonbrand'
    AND utm_source = 'gsearch'
GROUP BY
	YEAR(website_sessions.created_at),
    MONTH(website_sessions.created_at);