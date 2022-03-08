SELECT 
		pageview_url,
		COUNT(DISTINCT website_pageview_id) AS sessions
FROM website_pageviews
WHERE created_at < '2012-06-09'
GROUP BY
		pageview_url
ORDER BY
		sessions DESC    