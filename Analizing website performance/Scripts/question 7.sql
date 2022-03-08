SELECT min(website_pageviews.website_pageview_id) from website_pageviews
where pageview_url = '/billing-2'
order by created_at;
-- first billing-2 = 2012-09-10
-- first _pv_id = 53550

SELECT
	billing_version_seen,
    COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(DISTINCT order_id) as orders,
    COUNT(DISTINCT order_id) /  COUNT(DISTINCT website_session_id) AS billing_to_order_rt
FROM (SELECT 
	website_pageviews.website_session_id,
    website_pageviews.pageview_url AS billing_version_seen,
    orders.order_id
FROM website_pageviews
	LEFT JOIN orders
		ON orders.website_session_id = website_pageviews.website_session_id
WHERE website_pageviews.created_at < '2012-11-10'
	AND website_pageviews.website_pageview_id >= 53550 
	AND website_pageviews.pageview_url IN('/billing','/billing-2')
    ) AS billing_sessions_w_orders
GROUP BY billing_version_seen



