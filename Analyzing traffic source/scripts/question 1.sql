SELECT 	utm_source,
		utm_campaign,
        http_referer,
        COUNT(DISTINCT website_session_id) AS number_of_sessions
FROM website_sessions
WHERE created_at < '2012-04-12'
GROUP BY utm_source,
		utm_campaign,
        http_referer
ORDER BY number_of_sessions DESC        