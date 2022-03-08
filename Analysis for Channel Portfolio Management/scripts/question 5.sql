SELECT 
	MIN(DATE(created_at)) AS month_start,
    COUNT(DISTINCT CASE WHEN utm_campaign = 'nonbrand' THEN website_session_id ELSE NULL END) AS nonbrand,
	COUNT(DISTINCT CASE WHEN utm_campaign = 'brand' THEN website_session_id ELSE NULL END) AS brand,
	COUNT(DISTINCT CASE WHEN utm_campaign = 'brand' THEN website_session_id ELSE NULL END) /
		  COUNT(DISTINCT CASE WHEN utm_campaign = 'nonbrand' THEN website_session_id ELSE NULL END) AS brand_pct_of_nonbrand,
    COUNT(DISTINCT CASE WHEN http_referer IS NULL AND utm_source IS NULL THEN website_session_id ELSE NULL END) AS direct,
	COUNT(DISTINCT CASE WHEN http_referer IS NULL AND utm_source IS NULL THEN website_session_id ELSE NULL END) /
		  COUNT(DISTINCT CASE WHEN utm_campaign = 'nonbrand' THEN website_session_id ELSE NULL END) AS direct_pct_of_nonbrand,
    COUNT(DISTINCT CASE WHEN http_referer IN ('https://www.gsearch.com','https://www.bsearch.com') AND utm_source IS NULL THEN website_session_id ELSE NULL END) AS organic,
	COUNT(DISTINCT CASE WHEN http_referer IN ('https://www.gsearch.com','https://www.bsearch.com') AND utm_source IS NULL  THEN website_session_id ELSE NULL END) /
		  COUNT(DISTINCT CASE WHEN utm_campaign = 'nonbrand' THEN website_session_id ELSE NULL END) AS organic_pct_of_nonbrand
FROM website_sessions
WHERE
	created_at < '2012-12-23'
GROUP BY
		MONTH(created_at);
        
        
        
     