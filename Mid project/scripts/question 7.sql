-- For the landing page test you analyzed previously, it would be great to show a full cunversion funnel from each of the two pages to orders.
-- you can use the same time pariod you analyzed last time (Jun 19 - Jul 28)
CREATE TEMPORARY TABLE flags
SELECT
	website_sessions.website_session_id,
    website_pageviews.pageview_url,
    website_pageviews.created_at AS pageview_created_at,
    CASE WHEN website_pageviews.pageview_url = '/home' THEN 1 ELSE 0 END AS home_page,
	CASE WHEN website_pageviews.pageview_url = '/lander-1' THEN 1 ELSE 0 END AS lander1_page,
    CASE WHEN website_pageviews.pageview_url = '/products' THEN 1 ELSE 0 END AS products_page,
	CASE WHEN website_pageviews.pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS mrfuzzy_page,
	CASE WHEN website_pageviews.pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page,
	CASE WHEN website_pageviews.pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping_page,
	CASE WHEN website_pageviews.pageview_url = '/billing' THEN 1 ELSE 0 END AS billing_page,
	CASE WHEN website_pageviews.pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS thank_you_page
FROM website_sessions
	LEFT JOIN website_pageviews
		ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE 
	website_sessions.created_at BETWEEN '2012-06-19' AND '2012-07-28'
    AND utm_source = 'gsearch'
    AND utm_campaign = 'nonbrand'
ORDER BY 
	website_sessions.website_session_id,
    website_pageviews.created_at;
    
-- SELECT * FROM flags;

CREATE TEMPORARY TABLE website_pathway
SELECT
	website_session_id,
    MAX(home_page) AS home_landing_page,
    MAX(lander1_page) AS lander1_landing_page,
    MAX(products_page) AS product_made_it,
    MAX(mrfuzzy_page) AS mrfuzzy_made_it,
    MAX(cart_page) AS cart_nade_id,
    MAX(shipping_page) AS shipping_made_it,
    MAX(billing_page) AS billing_made_id,
    MAX(thank_you_page) AS thank_you_made_it
FROM flags
GROUP BY
	website_session_id;

SELECT * FROM website_pathway;

 
CREATE TEMPORARY TABLE web_funnel
SELECT
	CASE
		WHEN home_landing_page = 1 THEN 'saw_home_page'
        WHEN lander1_landing_page = 1 THEN 'saw_lander_page'
        ELSE 'check_logic'
    END AS segment,    
    COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(DISTINCT CASE WHEN product_made_it = 1 THEN	website_session_id ELSE NULL END) AS product_page,
    COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN	website_session_id ELSE NULL END) AS mrfuzzy_page,
    COUNT(DISTINCT CASE WHEN cart_nade_id = 1 THEN	website_session_id ELSE NULL END) AS cart_page,
    COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN	website_session_id ELSE NULL END) AS shipping_page,
    COUNT(DISTINCT CASE WHEN billing_made_id = 1 THEN	website_session_id ELSE NULL END) AS billing_page,
    COUNT(DISTINCT CASE WHEN thank_you_made_it = 1 THEN	website_session_id ELSE NULL END) AS thank_you_page
FROM website_pathway
GROUP BY  
	segment;

-- SELECT * FROM web_funnel;
CREATE TEMPORARY TABLE conversion_funnel
SELECT
	CASE
		WHEN home_landing_page = 1 THEN 'saw_home_page'
        WHEN lander1_landing_page = 1 THEN 'saw_lander_page'
        ELSE 'check_logic'
    END AS segment,    
    COUNT(DISTINCT CASE WHEN product_made_it = 1 THEN	website_session_id ELSE NULL END) / COUNT(DISTINCT website_session_id) AS products_rate,
	COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN	website_session_id ELSE NULL END) / COUNT(DISTINCT CASE WHEN product_made_it = 1 THEN website_session_id ELSE NULL END) AS mr_fuzzy_rate,
	COUNT(DISTINCT CASE WHEN cart_nade_id = 1 THEN	website_session_id ELSE NULL END) / COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN	website_session_id ELSE NULL END) AS cart_rate,
	COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN	website_session_id ELSE NULL END) / COUNT(DISTINCT CASE WHEN cart_nade_id = 1 THEN	website_session_id ELSE NULL END) AS shipping_rate,
    COUNT(DISTINCT CASE WHEN billing_made_id = 1 THEN	website_session_id ELSE NULL END) / COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN	website_session_id ELSE NULL END) AS billing_rate,
    COUNT(DISTINCT CASE WHEN thank_you_made_it = 1 THEN	website_session_id ELSE NULL END) /  COUNT(DISTINCT CASE WHEN billing_made_id = 1 THEN	website_session_id ELSE NULL END) AS thank_you_rate
FROM website_pathway
GROUP BY  
	segment;
select * from conversion_funnel;
    