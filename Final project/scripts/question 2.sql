-- Next, let's showcase all of our efficiency.
-- i would love to show quarterly figures since we launched, for session-to-order conversion-rate, revenue-per-order, and revenue-per-session.
SELECT
	MIN(DATE(website_sessions.created_at)) AS created_date,
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    ROUND(COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT website_sessions.website_session_id),3) AS conversion_rate,
    ROUND(SUM(orders.price_usd) / COUNT(DISTINCT orders.order_id),2) AS revenue_per_order,
    ROUND(SUM(orders.price_usd)  / COUNT(DISTINCT website_sessions.website_session_id),2) AS revenue_per_session
FROM website_sessions
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id
WHERE 
	website_sessions.created_at < '2015-01-01'
GROUP BY 
		YEAR(website_sessions.created_at),
        QUARTER(website_sessions.created_at);