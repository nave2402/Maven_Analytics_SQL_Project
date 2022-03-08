-- Let's dive deeper into the impact of  introducing new product.
-- Please pull monthly sessions to '/products' page, and show how the % of those sessions clicking through another page has change over time,
-- along with a view of how conversion from '/products' to placing an order has improved.

CREATE TEMPORARY TABLE product_sessions
SELECT
	YEAR(created_at) AS yr,
	MONTH(created_at) AS mo,
	website_session_id,
	website_pageview_id
FROM website_pageviews
WHERE
	created_at < '2015-01-01'
	AND pageview_url = '/products';
    
SELECT 
		product_sessions.yr,
        product_sessions.mo,
        COUNT(DISTINCT product_sessions.website_session_id) AS sessions,
        ROUND(COUNT(DISTINCT website_pageviews.website_session_id) / COUNT(DISTINCT product_sessions.website_session_id),2) AS clicked_through_tr,
		ROUND(COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT product_sessions.website_session_id),2) AS conv_rt_product_to_order
FROM product_sessions  
	LEFT JOIN website_pageviews
		ON product_sessions.website_session_id = website_pageviews.website_session_id
        AND product_sessions.website_pageview_id < website_pageviews.website_pageview_id
		LEFT JOIN orders
			ON product_sessions.website_session_id = orders.website_session_id
GROUP BY
		product_sessions.yr,
        product_sessions.mo;   
    
    



     
