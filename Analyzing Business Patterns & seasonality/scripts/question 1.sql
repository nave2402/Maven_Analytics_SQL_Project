SELECT
	MIN(DATE(website_sessions.created_at)) AS month_start,
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS orders
FROM website_sessions
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id
WHERE
	website_sessions.created_at < '2013-01-01'
GROUP BY
		MONTH(website_sessions.created_at);

SELECT
	MIN(DATE(website_sessions.created_at)) AS week_start,
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS orders
FROM website_sessions
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id
WHERE
	website_sessions.created_at < '2013-01-01'
GROUP BY
		WEEK(website_sessions.created_at);        