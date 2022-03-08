-- STEP 1: find out when the new page '/lander-1' launched
SELECT 
	MIN(created_at) AS first_created_at,
    MIN(website_pageview_id) AS first_pageview_id
FROM website_pageviews
WHERE
	pageview_url = '/lander-1'
    AND created_at IS NOT NULL;
-- first created at = 2012-06-2019
-- first pageview id = 23504

-- STEP 2: finding the first websit_pageview_id for the relevent session
CREATE TEMPORARY TABLE first_pageviews
SELECT 
	website_pageviews.website_session_id,
    MIN(website_pageviews.website_pageview_id) AS first_pageview_id
FROM
	website_pageviews
    JOIN website_sessions
    ON website_pageviews.website_session_id = website_sessions.website_session_id
    AND website_sessions.created_at < '2012-07-28'
	AND website_pageviews.website_pageview_id > '23504'
	AND utm_source = 'gsearch'
	AND utm_campaign = 'nonbrand'
GROUP BY website_pageviews.website_session_id;

-- STEP 3: identifying the landing page of each session
CREATE TEMPORARY TABLE sessions_w_landing_page
SELECT 
	first_pageviews.website_session_id,
    website_pageviews.pageview_url AS landing_page
FROM first_pageviews
	LEFT JOIN website_pageviews
    ON first_pageviews.first_pageview_id = website_pageviews.website_pageview_id
WHERE website_pageviews.pageview_url IN ('/home' , '/lander-1') ;

-- STEP 4: counting pageviews for each session, identify "bounces"
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

-- STEP 5: summarizing total session and bounced session by, LP         
SELECT 
	sessions_w_landing_page.landing_page,
	COUNT(DISTINCT sessions_w_landing_page.website_session_id) AS sessions,
    COUNT(DISTINCT bounced_sessions_only.website_session_id) AS bounced_sessions,
	COUNT(DISTINCT bounced_sessions_only.website_session_id) / COUNT(DISTINCT sessions_w_landing_page.website_session_id) * 100 AS bounce_rate 
FROM sessions_w_landing_page
	LEFT JOIN bounced_sessions_only
		ON sessions_w_landing_page.websitE_session_id = bounced_sessions_only.websitE_session_id
GROUP BY
		sessions_w_landing_page.landing_page
ORDER BY        
		sessions_w_landing_page.website_session_id;
  
    