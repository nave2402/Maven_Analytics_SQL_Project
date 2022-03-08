-- STEP 1: select all pageviews for relevent sessions
CREATE TEMPORARY TABLE sessions_seeing_product_page
SELECT 
		website_session_id,
        created_at,
		website_pageview_id,
        pageview_url AS product_seen_page
FROM website_pageviews
WHERE
	created_at BETWEEN '2013-01-06' AND '2013-04-10'
    AND pageview_url IN ('/the-original-mr-fuzzy', '/the-forever-love-bear');

    
-- STEP 2: figure out which pageviews url to look for 
SELECT DISTINCT
	website_pageviews.pageview_url
FROM sessions_seeing_product_page
	LEFT JOIN website_pageviews
		ON sessions_seeing_product_page.website_session_id = website_pageviews.website_session_id
		AND sessions_seeing_product_page.website_pageview_id < website_pageviews.website_pageview_id;
    
-- SETP 3: pull all pageviews and identify the funnel steps & create the session-level conversion funnel view
CREATE TEMPORARY TABLE conv_funnel
SELECT
    sessions,
	CASE WHEN product_seen_page = '/the-original-mr-fuzzy' THEN 'mrfuzzy' 
 		 WHEN product_seen_page = '/the-forever-love-bear' THEN 'lovebear' ELSE NULL
 	END AS product_seen, 

    MAX(cart_page) AS cart_made_it,
    MAX(shipping_page) AS shipping_made_it,
    MAX(billing_page) AS billing_made_it,
    MAX(thank_you_page) AS thank_you_made_it
FROM (SELECT
			sessions_seeing_product_page.website_session_id AS sessions,
            sessions_seeing_product_page.product_seen_page,
            CASE WHEN website_pageviews.pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page,
            CASE WHEN website_pageviews.pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping_page,
            CASE WHEN website_pageviews.pageview_url = '/billing-2' THEN 1 ELSE 0 END AS billing_page,
            CASE WHEN website_pageviews.pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS thank_you_page
      FROM sessions_seeing_product_page
		 LEFT JOIN website_pageviews
				ON sessions_seeing_product_page.website_session_id = website_pageviews.website_session_id
                AND sessions_seeing_product_page.website_pageview_id < website_pageviews.website_pageview_id
      ORDER BY
			sessions_seeing_product_page.website_session_id,
            sessions_seeing_product_page.created_at) AS flags
GROUP BY
		sessions;
select * from  conv_funnel;       
        
-- STEP 4: aggregate the data to assess funnel performance
SELECT
    product_seen,
	COUNT(DISTINCT sessions) AS sessions,
	COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN sessions ELSE NULL END) AS to_cart,
	COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN sessions ELSE NULL END) AS to_shipping,
	COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN sessions ELSE NULL END) AS to_billing,
	COUNT(DISTINCT CASE WHEN thank_you_made_it = 1 THEN sessions ELSE NULL END) AS to_thank_you
FROM  conv_funnel  
GROUP BY 
		product_seen;
        
-- STEP 5: conversion funnel rate
SELECT
    product_seen,
   --  COUNT(DISTINCT sessions) AS sessions,
	ROUND(COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN sessions ELSE NULL END) / COUNT(DISTINCT sessions),2) AS cart_conversion_rate,
	ROUND(COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN sessions ELSE NULL END) / COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN sessions ELSE NULL END),2) AS shipping_conversion_rate,
	ROUND(COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN sessions ELSE NULL END)  / COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN sessions ELSE NULL END),2) AS billing_conversion_rate,
	ROUND(COUNT(DISTINCT CASE WHEN thank_you_made_it = 1 THEN sessions ELSE NULL END) / COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN sessions ELSE NULL END),2)  AS thank_you_conversion_rate
FROM  conv_funnel  
GROUP BY 
		product_seen;


    
    