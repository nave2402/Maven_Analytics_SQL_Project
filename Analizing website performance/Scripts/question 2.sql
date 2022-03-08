CREATE TEMPORARY TABLE first_pageview
SELECT 
		website_session_id,
        MIN(website_pageview_id) AS entry
FROM website_pageviews
WHERE created_at < '2012-06-12'
GROUP BY website_session_id;

SELECT 
		website_pageviews.pageview_url,
        COUNT(entry)
FROM first_pageview
	LEFT JOIN website_pageviews
    ON first_pageview.entry = website_pageviews.website_pageview_id
GROUP BY     website_pageviews.pageview_url



