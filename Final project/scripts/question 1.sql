-- First, I'd like to show our volume growth. can you pull overall session and order volume, trended by quarter for the life of the business?
-- Since the most tecent quarter is incomplete, you can fecide how to handle it.
SELECT 
	MIN(DATE(website_sessions.created_at)) AS created_date,
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS orders
FROM website_sessions
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id
WHERE 
	website_sessions.created_at <'2015-01-01'
GROUP BY
		YEAR(website_sessions.created_at),
        QUARTER(website_sessions.created_at);