-- Next, let's show the overall session-to-order conversion rate trends for those same channels, by quarter.
-- Please also make a note of any periods where we made major improvements of optimizations.
SELECT
	MIN(DATE(website_sessions.created_at)) AS created_date,
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT CASE WHEN website_sessions.utm_campaign = 'nonbrand' AND website_sessions.utm_source = 'gsearch' THEN orders.order_id ELSE NULL END) /
		  COUNT(DISTINCT CASE WHEN website_sessions.utm_campaign = 'nonbrand' AND website_sessions.utm_source = 'gsearch' THEN website_sessions.website_session_id ELSE NULL END)
          AS gsearch_nonbrand_conv_rt,
    COUNT(DISTINCT CASE WHEN website_sessions.utm_campaign = 'nonbrand' AND website_sessions.utm_source = 'bsearch' THEN orders.order_id ELSE NULL END) /
		  COUNT(DISTINCT CASE WHEN website_sessions.utm_campaign = 'nonbrand' AND website_sessions.utm_source = 'bsearch' THEN website_sessions.website_session_id ELSE NULL END)
          AS bsearch_nonbrand_conv_rt,
    COUNT(DISTINCT CASE WHEN website_sessions.utm_campaign = 'brand' THEN orders.order_id ELSE NULL END) / 
		  COUNT(DISTINCT CASE WHEN website_sessions.utm_campaign = 'brand' THEN website_sessions.website_session_id ELSE NULL END)
           AS brand_overall_conv_rt,
	COUNT(DISTINCT CASE WHEN website_sessions.utm_source IS NULL AND website_sessions.http_referer IS NOT NULL THEN orders.order_id ELSE NULL END) /
		  COUNT(DISTINCT CASE WHEN website_sessions.utm_source IS NULL AND website_sessions.http_referer IS NOT NULL THEN website_sessions.website_session_id ELSE NULL END)
          AS organic_search_conv_rt,
    COUNT(DISTINCT CASE WHEN website_sessions.utm_source IS NULL AND website_sessions.http_referer IS NULL THEN orders.order_id ELSE NULL END) /
          COUNT(DISTINCT CASE WHEN website_sessions.utm_source IS NULL AND website_sessions.http_referer IS NULL THEN website_sessions.website_session_id ELSE NULL END)
          AS direct_type_in_conv_rt
FROM website_sessions
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id
WHERE
	website_sessions.created_at < '2015-01-01'
GROUP BY 
		YEAR(website_sessions.created_at),
        QUARTER(website_sessions.created_at);