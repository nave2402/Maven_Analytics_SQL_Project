SELECT
	MIN(DATE(created_at)) AS week_start,
    COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' THEN website_session_id ELSE NULL END) AS gsearch_sessions,
    COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' THEN website_session_id ELSE NULL END) AS bsearch_sessions
FROM website_sessions
WHERE 
	created_at BETWEEN '2012-08-22' AND '2012-11-27'
    AND utm_campaign = 'nonbrand'
GROUP BY
		WEEK(created_at);