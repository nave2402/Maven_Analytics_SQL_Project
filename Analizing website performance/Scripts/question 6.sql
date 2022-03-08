
-- SETP 1: select all pageviews for relevant sessions
-- STEP 2: idntifay each relevant pageview as the specific funnel step
-- STEP 3: create the session-level conversion funnel view
-- STEP 4: aggregate the data to assess funnel performance
CREATE TEMPORARY TABLE session_level_made_flags
SELECT
	website_session_id,
-- 	MAX(home_page) AS home_made_it,
    MAX(products_page) AS product_made_it,
    MAX(mr_fuzzy_page) AS mrfuzzy_made_it,
    MAX(cart_page) AS cart_made_it,
    MAX(shipping_page) AS shipping_made_it,
    MAX(billing_page) AS billing_made_it,
	MAX(thank_you_page) AS thanks_made_it
FROM (SELECT 
	website_sessions.website_session_id,
    website_pageviews.pageview_url,
    website_pageviews.created_at AS pageview_created_at,
	-- CASE WHEN pageview_url = '/lander-1' THEN 1 ELSE 0 END AS home_page,
    CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END AS products_page,
    CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS mr_fuzzy_page,
    CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page,
    CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping_page,
    CASE WHEN pageview_url = '/billing' THEN 1 ELSE 0 END AS billing_page,
    CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS thank_you_page
FROM website_sessions
	LEFT JOIN website_pageviews
		ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE website_sessions.created_at BETWEEN '2012-08-05'AND '2012-09-05'
    AND website_sessions.utm_campaign = 'nonbrand'
	AND website_sessions.utm_source = 'gsearch'
-- 	AND website_pageviews.pageview_url IN('/lander-1','/products','/the-original-mr-fuzzy','/cart','/shipping','/billing','/thank-you-for-your-order')
ORDER BY
	website_sessions.website_session_id,
    website_pageviews.created_at) AS pageview_level
GROUP BY website_session_id;    


-- SELECT
-- 	COUNT(DISTINCT CASE WHEN product_made_it = 1 THEN website_session_id ELSE NULL END) AS to_product,
-- 	COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END) AS to_mrfuzzy,
--     COUNT(DISTINCT CASE WHEN cart_made_it =1 THEN website_session_id ELSE NULL END) AS to_cart,
-- 	COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END)AS to_shipping,
-- 	COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END)AS to_billing,
--     COUNT(DISTINCT CASE WHEN thanks_made_it = 1 THEN website_session_id ELSE NULL END) AS to_thank_you
-- FROM session_level_made_flags;

SELECT
	COUNT(DISTINCT website_session_id) AS sessions,
	COUNT(DISTINCT CASE WHEN product_made_it = 1 THEN website_session_id ELSE NULL END) / 	COUNT(DISTINCT website_session_id)AS clicked_to_lander_home_page,
	COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END) / COUNT(DISTINCT CASE WHEN product_made_it = 1 THEN website_session_id ELSE NULL END) AS clicked_to_products,
    COUNT(DISTINCT CASE WHEN cart_made_it =1 THEN website_session_id ELSE NULL END) / 	COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END) AS clicked_to_mrfuzzy,
	COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END) / COUNT(DISTINCT CASE WHEN cart_made_it =1 THEN website_session_id ELSE NULL END) AS clicked_to_cart,
	COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END) / 	COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END)AS clicked_to_shipping,
    COUNT(DISTINCT CASE WHEN thanks_made_it = 1 THEN website_session_id ELSE NULL END) / 	COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END) AS clicked_to_billing
--     clicked_to_thank_you
FROM session_level_made_flags;