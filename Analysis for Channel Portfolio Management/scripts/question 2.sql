SELECT
	utm_source,
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN website_session_id ELSE NULL END) AS mobile_sessions,
    COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN website_session_id ELSE NULL END) /  COUNT(DISTINCT website_sessions.website_session_id) AS pct_mobile
FROM website_sessions
WHERE
	created_at BETWEEN '2012-08-22' AND '2012-11-30'
    AND utm_campaign = 'nonbrand'
    AND utm_source IN ('gsearch','bsearch')
GROUP BY
	utm_source;