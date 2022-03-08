-- STEP 1:
-- CREATE TEMPORARY TABLE sessions_w_min_pv_and_pv_count
-- SELECT
-- 	website_sessions.website_session_id,
--     MIN(website_pageviews.website_pageview_id) AS first_pageview_id,
--     COUNT(website_pageviews.website_pageview_id) AS count_pageviews
-- FROM website_sessions
-- 		LEFT JOIN website_pageviews
-- 			ON website_sessions.website_session_id = website_pageviews.website_session_id
-- WHERE website_sessions.created_at BETWEEN '2012-06-01' AND '2012-08-31'
-- 	AND utm_source = 'gsearch'
--     AND utm_campaign = 'nonbrand'
-- GROUP BY
-- 		website_sessions.website_session_id;

-- STEP 2:
-- CREATE TEMPORARY TABLE sessions_w_count_lander_and_created_at
-- SELECT
-- 		sessions_w_min_pv_and_pv_count.website_session_id,
--         sessions_w_min_pv_and_pv_count.first_pageview_id,
--         sessions_w_min_pv_and_pv_count.count_pageviews,
--         website_pageviews.pageview_url AS landing_page,
--         website_pageviews.created_at AS session_created_at
-- FROM sessions_w_min_pv_and_pv_count
-- 	LEFT JOIN website_pageviews
-- 		ON sessions_w_min_pv_and_pv_count.first_pageview_id = website_pageviews.website_pageview_id
 
 -- STEP3:
SELECT
	MIN(DATE(session_created_at)) AS week_start,
 --    COUNT(DISTINCT website_session_id) AS total_sessions,
--      COUNT(DISTINCT CASE WHEN count_pageviews = 1 
-- 			THEN website_session_id ELSE NULL END) AS bounced_sessions,
       COUNT(DISTINCT CASE WHEN count_pageviews = 1 
			THEN website_session_id ELSE NULL END) / COUNT(DISTINCT website_session_id) AS bounce_rate,
    COUNT(DISTINCT CASE WHEN landing_page = '/home'
			THEN  website_session_id ELSE NULL END) AS home_sessions,
	COUNT(DISTINCT CASE WHEN landing_page = '/lander-1'
			THEN  website_session_id ELSE NULL END) AS lander1_sessions
FROM sessions_w_count_lander_and_created_at
GROUP BY
		YEAR(session_created_at),
		WEEK(session_created_at);
       