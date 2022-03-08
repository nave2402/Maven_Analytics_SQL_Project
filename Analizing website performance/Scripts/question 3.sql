CREATE TEMPORARY TABLE first_pageviews
SELECT 
	website_pageviews.website_session_id,
    MIN(website_pageviews.website_pageview_id) AS first_pageview_id
FROM
	website_pageviews
    JOIN website_sessions
    ON website_pageviews.website_session_id = website_sessions.website_session_id
    AND website_sessions.created_at < '2012-06-14'
GROUP BY website_pageviews.website_session_id;

CREATE TEMPORARY TABLE sessions_w_landing_page
SELECT 
	first_pageviews.website_session_id,
    website_pageviews.pageview_url AS landing_page
FROM first_pageviews
	LEFT JOIN website_pageviews
    ON first_pageviews.first_pageview_id = website_pageviews.website_pageview_id
WHERE website_pageviews.pageview_url = '/home'
ORDER BY website_pageviews.created_at;
    
CREATE TEMPORARY TABLE bounced_sessions_only
SELECT 
	sessions_w_landing_page.website_session_id,
    sessions_w_landing_page.landing_page,
    COUNT(website_pageviews.website_pageview_id) AS count_of_page_views
FROM sessions_w_landing_page
		LEFT JOIN website_pageviews
			ON sessions_w_landing_page.website_session_id = website_pageviews.website_session_id
GROUP BY
		sessions_w_landing_page.website_session_id,
		sessions_w_landing_page.landing_page
HAVING
		 COUNT(website_pageviews.website_pageview_id) = 1;
SELECT 
	sessions_w_landing_page.landing_page,
	COUNT(DISTINCT sessions_w_landing_page.website_session_id) AS sessions,
    COUNT(DISTINCT bounced_sessions_only.website_session_id) AS bounced_sessions,
	COUNT(DISTINCT bounced_sessions_only.website_session_id) / COUNT(DISTINCT sessions_w_landing_page.website_session_id)  AS bounce_rate 
FROM sessions_w_landing_page
	LEFT JOIN bounced_sessions_only
		ON sessions_w_landing_page.website_session_id = bounced_sessions_only.website_session_id
GROUP BY
		sessions_w_landing_page.landing_page
ORDER BY        
		sessions_w_landing_page.website_session_id;
    