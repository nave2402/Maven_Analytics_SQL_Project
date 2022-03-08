CREATE TEMPORARY TABLE flags
SELECT
	website_sessions.created_at AS created_date,
    website_sessions.website_session_id AS sessions,
    website_pageviews.website_pageview_id AS pageview_id,
    CASE WHEN website_pageviews.pageview_url = '/products' THEN 1 ELSE 0 END AS product_page,
    CASE WHEN website_pageviews.pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS mrfuzzy_page,
    CASE WHEN website_pageviews.pageview_url = '/the-forever-love-bear' THEN 1 ELSE 0 END AS love_bear_page
FROM website_sessions
	LEFT JOIN website_pageviews
		ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE
	website_sessions.created_at BETWEEN '2012-10-06' AND '2013-04-06'
    AND website_pageviews.pageview_url IN('/products', '/the-original-mr-fuzzy','/the-forever-love-bear')
ORDER BY
		sessions,
        created_date;
        
CREATE TEMPORARY TABLE website_pathway
SELECT
	created_date,
    sessions,
    MAX(product_page) AS product_made_it,
    MAX(mrfuzzy_page) AS mrfuzzy_made_it,
    MAX(love_bear_page) AS love_bear_made_it
FROM flags
GROUP BY
		sessions;

SELECT
		CASE WHEN created_date BETWEEN '2012-10-06' AND '2013-01-06' THEN 'A.pre_product_2' ELSE 'B.post_product_2' END AS time_period,
        COUNT(sessions) AS sessions,
        COUNT(CASE WHEN mrfuzzy_made_it = 1 THEN sessions
				   WHEN love_bear_made_it = 1 THEN sessions ELSE NULL END) AS w_next_page,
        COUNT(CASE WHEN mrfuzzy_made_it = 1 THEN sessions
				   WHEN love_bear_made_it = 1 THEN sessions ELSE NULL END) /  COUNT(sessions) AS pct_w_next_pg,
        COUNT(CASE WHEN mrfuzzy_made_it = 1 THEN sessions ELSE NULL END) AS to_mrfuzzy,
        COUNT(CASE WHEN mrfuzzy_made_it = 1 THEN sessions ELSE NULL END) / COUNT(sessions) AS pct_to_mrfuzzy,
        COUNT(CASE WHEN love_bear_made_it = 1 THEN sessions ELSE NULL END) AS to_love_bear,
        COUNT(CASE WHEN love_bear_made_it = 1 THEN sessions ELSE NULL END) / COUNT(sessions) AS pct_to_love_bear
FROM  website_pathway
GROUP BY
		time_period;
        
-- STEP 1: finding the '/products' pageviews we care about
CREATE TEMPORARY TABLE products_pageviews
SELECT
	website_session_id,
    website_pageview_id,
    created_at,
    CASE WHEN created_at BETWEEN '2012-10-06' AND '2013-01-06' THEN 'A.pre_product_2' ELSE 'B.post_product_2' END AS time_period
FROM website_pageviews
WHERE
	created_at BETWEEN '2012-10-06' AND '2013-04-06'
    AND pageview_url = '/products';
 
-- STEP 2: find the next pageview id that occurs AFTER the product pageview
CREATE TEMPORARY TABLE sessions_w_next_pageview_id
SELECT
	products_pageviews.time_period,
    products_pageviews.website_session_id,
    MIN(website_pageviews.website_pageview_id) AS min_next_pageview_id
FROM  products_pageviews
	LEFT JOIN website_pageviews
		ON products_pageviews.website_session_id = website_pageviews.website_session_id
        AND products_pageviews.website_pageview_id < website_pageviews.website_pageview_id
GROUP BY
		1,2;
  
select * from  sessions_w_next_pageview_id;       
   
 
-- STEP 3: finding the pageview_url associated with any applicable next pageview id
CREATE TEMPORARY TABLE sessions_w_next_pageview_url
SELECT
	sessions_w_next_pageview_id.time_period,
    sessions_w_next_pageview_id.website_session_id,
    website_pageviews.pageview_url AS next_pageview_url
FROM sessions_w_next_pageview_id
	LEFT JOIN website_pageviews
		ON sessions_w_next_pageview_id.min_next_pageview_id = website_pageviews.website_pageview_id;

SELECT
		time_period,
        COUNT(DISTINCT website_session_id) AS sessions,
        COUNT(DISTINCT CASE WHEN next_pageview_url IS NOT NULL THEN website_session_id ELSE NULL END) AS w_next_page,
        COUNT(DISTINCT CASE WHEN next_pageview_url IS NOT NULL THEN website_session_id  ELSE NULL END) /  COUNT(DISTINCT website_session_id)  AS pct_w_next_pg,
        COUNT(DISTINCT CASE WHEN next_pageview_url = '/the-original-mr-fuzzy' THEN website_session_id ELSE NULL END) AS to_mrfuzzy,
        COUNT(DISTINCT CASE WHEN next_pageview_url = '/the-original-mr-fuzzy' THEN website_session_id ELSE NULL END) / COUNT(DISTINCT website_session_id)  AS pct_to_mrfuzzy,
        COUNT(DISTINCT CASE WHEN next_pageview_url = '/the-forever-love-bear' THEN website_session_id ELSE NULL END) AS to_love_bear,
        COUNT(DISTINCT CASE WHEN next_pageview_url = '/the-forever-love-bear' THEN website_session_id ELSE NULL END) / COUNT(DISTINCT website_session_id)  AS pct_to_love_bear
FROM  sessions_w_next_pageview_url
GROUP BY
		time_period;

	

                   
                   