-- I'd like to tell the story of our website performans improvements over the course of the first 8 months.
-- Could you pull session to order conversion rates, by month?
SELECT
	MIN(DATE(website_sessions.created_at)) AS month_start,
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS orders,
    COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT website_sessions.website_session_id) * 100 AS session_to_order_rt
FROM website_sessions
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at < '2012-11-27'
GROUP BY
		YEAR(website_sessions.created_at),
        MONTH(website_sessions.created_at)
        