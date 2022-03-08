-- I'd like to show how we've grown specific channels.
-- Could you pull a quarterly view of orders from gsearch nonbrand, bsearch nonbrand brand search overall, organic search. and direct type-in?
SELECT
	MIN(DATE(website_sessions.created_at)) AS created_date,
    COUNT(DISTINCT CASE WHEN website_sessions.utm_campaign = 'nonbrand' AND website_sessions.utm_source = 'gsearch' THEN orders.order_id ELSE NULL END) AS gsearch_nonbrand,
    COUNT(DISTINCT CASE WHEN website_sessions.utm_campaign = 'nonbrand' AND website_sessions.utm_source = 'bsearch' THEN orders.order_id ELSE NULL END) AS bsearch_nonbrand,
    COUNT(DISTINCT CASE WHEN website_sessions.utm_campaign = 'brand' THEN orders.order_id ELSE NULL END) AS brand_overall,
	COUNT(DISTINCT CASE WHEN website_sessions.utm_source IS NULL AND website_sessions.http_referer IS NOT NULL THEN orders.order_id ELSE NULL END) AS organic_search,
    COUNT(DISTINCT CASE WHEN website_sessions.utm_source IS NULL AND website_sessions.http_referer IS NULL THEN orders.order_id ELSE NULL END) AS direct_type_in
FROM website_sessions
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id
WHERE
	website_sessions.created_at < '2015-01-01'
GROUP BY 
		YEAR(website_sessions.created_at),
        QUARTER(website_sessions.created_at);