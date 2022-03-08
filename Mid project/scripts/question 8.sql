-- I'd love for you to quantify the impact of pur biling test, as well .
-- Please analyze the lift generated from the test (Sep 10 - Nov 10), in terms of revenue per billing page session, and then pull the number of billing page
-- sessions for the past month to understand the monthly impact

select * from website_pageviews
where pageview_url = '/billing-2'
order by created_at  ; 
-- first pageview = 53550 
-- first created_at = 2012-09-10

CREATE TEMPORARY TABLE billing_page_sessions_w_orders
SELECT 
	website_pageviews.website_session_id,
    website_pageviews.pageview_url,
    orders.order_id,
    orders.price_usd
FROM website_pageviews
	LEFT JOIN orders
		ON website_pageviews.website_session_id = orders.website_session_id
WHERE
	website_pageviews.created_at BETWEEN '2012-09-10' AND '2012-11-10'
    AND website_pageviews.website_pageview_id >'53550'
    AND website_pageviews.pageview_url IN ('/billing','/billing-2');

SELECT
	pageview_url,
    COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(DISTINCT order_id) AS orders,
    COUNT(DISTINCT order_id) / COUNT(DISTINCT website_session_id) AS billing_page_session_to_order_rate,
    SUM(price_usd) / COUNT(DISTINCT website_session_id) AS revenue_per_billing_page_seen
FROM
	billing_page_sessions_w_orders
GROUP BY
    pageview_url;
select * from billing_page_sessions_w_orders;    

-- An increase of almost 17 % !! 
-- 109 more orders
-- An increase of almost 9 $ for the billing page seen

SELECT
	COUNT(website_session_id) AS sessions
FROM website_pageviews
WHERE
	created_at BETWEEN '2012-10-27' AND '2012-11-27'
    AND pageview_url IN('/BILLING','/BILLING-2');
    
-- in the last month we had 1137 session
-- 1137 * 8.39 = 9539
-- the monthly impact for the past month is 9539 $    
    



 


    


    
