-- For the gsearsh lander test, please estimate the revenue that test earnd us.
-- (Hint: Look at the increase in CVR (conversion rate) from the test (Jun 19 - Jul 28), and use nonbrand sessions and revenue since then to calculate incremental value)

-- STEP 1: find out when the page ' /lander-1' launched
SELECT
	MIN(created_at) AS first_created_at,
    MIN(website_pageview_id) AS dirst_pageview
FROM website_pageviews
WHERE
	pageview_url = '/lander-1';
-- first created at = 2012-06-19
-- first pageview = 23504    

-- STEP 2: finding the first website_pageview_id for the relevent sessions
CREATE TEMPORARY TABLE first_pageview_w_landing_page
SELECT
	website_sessions.website_session_id ,
    MIN(website_pageviews.website_pageview_id) AS first_pageview,
    website_pageviews.pageview_url AS landing_page
FROM website_sessions
	LEFT JOIN website_pageviews
		ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE 
	website_sessions.created_at BETWEEN '2012-06-19' AND '2012-07-28'
    AND website_pageviews.website_pageview_id >= '23504'
    AND website_sessions.utm_source = 'gsearch'
    AND website_sessions.utm_campaign = 'nonbrand'
    AND website_pageviews.pageview_url IN ('/home','/lander-1')
GROUP BY
    website_sessions.website_session_id;

    
-- SETP 3: combine with the orders table and find the orders rate from each landing page
SELECT
		first_pageview_w_landing_page.landing_page,
		COUNT(DISTINCT first_pageview_w_landing_page.website_session_id) AS sessions,
		COUNT(DISTINCT orders.order_id) AS orders,
        COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT first_pageview_w_landing_page.website_session_id) * 100 AS conversion_rate
FROM first_pageview_w_landing_page
	LEFT JOIN orders
		ON first_pageview_w_landing_page.website_session_id = orders.website_session_id
GROUP BY
		first_pageview_w_landing_page.landing_page;

-- STEP4: finding the most recent pageview for 'gsearch' where the traffic sent to '/home'
-- 		  and then we can see how many sessions we have since that test

SELECT 
	MAX(website_sessions.website_session_id) AS most_recent_gsearch_nonbrand_home_pageview
FROM website_sessions
	LEFT JOIN website_pageviews
		ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE
	utm_source = 'gsearch'
	AND utm_campaign = 'nonbrand'
    AND website_sessions.created_at < '2012-11-27'
    AND pageview_url = '/home';
-- max website session id = 17145
SELECT
		COUNT(website_session_id) AS sessions_since_test
FROM website_sessions
WHERE
	created_at < '2012-11-27'
    AND utm_source = 'gsearch'
    AND utm_campaign = 'nonbrand'
    AND website_session_id > '17145';
-- the number of session is 22450
-- and now we just need to calculte the incremental value
-- we are going to multyply the number of session that we found (22450) by the additional orders per session (0.00926)
-- 22450 * 0.00926 = 207.88
-- so roughly 4 month (end of August to end of November) we have approximately 50 extra orders per month!
    
        
        