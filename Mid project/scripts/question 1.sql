 -- Gsearch seems top be the biggest driver of our business.
 -- Could you pull monthly trends for gsearch sessions and orders so that we can shopw case the growth there?
 
SELECT 
	MIN(DATE(website_sessions.created_at)) AS start_month,
    COUNT(DISTINCT CASE WHEN website_sessions.utm_source = 'gsearch' THEN website_sessions.website_session_id ELSE NULL END) AS sessions,
    COUNT(DISTINCT CASE WHEN orders.order_id THEN orders.website_session_id ELSE NULL END) AS orders
FROM website_sessions
		LEFT JOIN orders
			ON website_sessions.website_session_id = orders.website_session_id
WHERE 
	website_sessions.created_at < '2012-11-27'
    AND website_sessions.utm_source = 'gsearch'
GROUP BY
		YEAR(website_sessions.created_at),
        MONTH(website_sessions.created_at)