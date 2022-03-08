SELECT MIN(DATE(website_sessions.created_at)) AS week_start,
	COUNT(DISTINCT CASE WHEN website_sessions.device_type = 'mobile'
			THEN website_sessions.website_session_id ELSE NULL END) AS mobile, 
    COUNT(DISTINCT CASE WHEN website_sessions.device_type = 'desktop'
			THEN website_sessions.website_session_id  ELSE NULL END) AS desktop 
FROM website_sessions
WHERE website_sessions.created_at BETWEEN '2012-04-15' AND '2012-06-09'
      AND utm_source = 'gsearch'
      AND utm_campaign = 'nonbrand'
GROUP BY WEEK(website_sessions.created_at);
		