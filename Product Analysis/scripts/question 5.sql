-- STEP 1: select all pageviews for the relevent sessions
CREATE TEMPORARY TABLE sessions_seeing_cart_page
SELECT
	CASE WHEN website_pageviews.created_at > '2013-09-25' THEN 'B.post_Croos_sell' ELSE 'A.pre_Croos_sell' END AS time_period,
	website_pageviews.website_session_id,
    website_pageviews.website_pageview_id,
    website_pageviews.pageview_url,
    orders.items_purchased,
    orders.order_id,
    orders.price_usd
FROM website_pageviews
	LEFT JOIN orders
		ON website_pageviews.website_session_id = orders.website_session_id
WHERE
	website_pageviews.created_at BETWEEN '2013-08-25' and '2013-10-25'
    AND website_pageviews.pageview_url = '/cart';

-- STEP 2: checking the next clicks options
SELECT DISTINCT
	website_pageviews.pageview_url
FROM  sessions_seeing_cart_page
	LEFT JOIN website_pageviews
		ON sessions_seeing_cart_page.website_session_id = website_pageviews.website_session_id
        AND sessions_seeing_cart_page.website_pageview_id < website_pageviews.website_pageview_id;
-- '/shipping' , '/billing-2' , '/thank-you-for-your-order'
-- SETP 3: look for the one how clickthroughs to next pageviews
CREATE TEMPORARY TABLE clicked_to_next_pageview
SELECT 
		sessions_seeing_cart_page.time_period,
		sessions_seeing_cart_page.website_session_id,
		MIN(website_pageviews.website_pageview_id) AS clicked_to_next_pageview
FROM sessions_seeing_cart_page
	LEFT JOIN website_pageviews
		ON sessions_seeing_cart_page.website_session_id = website_pageviews.website_session_id
        AND sessions_seeing_cart_page.website_pageview_id < website_pageviews.website_pageview_id
WHERE website_pageviews.pageview_url IN ('/shipping' , '/billing-2' , '/thank-you-for-your-order')
GROUP BY 
 	sessions_seeing_cart_page.time_period,
 	sessions_seeing_cart_page.website_session_id;
-- HAVING   
-- 	MIN(website_pageviews.website_pageview_id) IS NOT NULL;
DROP TABLE  clicked_to_next_pageview ; 
SELECT * FROM clicked_to_next_pageview;    

SELECT
	sessions_seeing_cart_page.time_period,
	COUNT(DISTINCT sessions_seeing_cart_page.website_session_id) AS cart_sessions,
    COUNT(DISTINCT clicked_to_next_pageview.clicked_to_next_pageview) AS clickthroughs ,
    ROUND(COUNT(DISTINCT clicked_to_next_pageview.clicked_to_next_pageview) / COUNT(DISTINCT sessions_seeing_cart_page.website_session_id),2) AS cart_ctr,
    ROUND(SUM(sessions_seeing_cart_page.items_purchased) / COUNT(DISTINCT sessions_seeing_cart_page.order_id),2)  AS products_per_order,
    ROUND(AVG(sessions_seeing_cart_page.price_usd),2) AS aov,
    ROUND(SUM(sessions_seeing_cart_page.price_usd) / COUNT(DISTINCT sessions_seeing_cart_page.website_session_id),2) as revenue
FROM sessions_seeing_cart_page
	LEFT JOIN clicked_to_next_pageview
		ON sessions_seeing_cart_page.website_session_id = clicked_to_next_pageview.website_session_id
GROUP BY time_period;    

        