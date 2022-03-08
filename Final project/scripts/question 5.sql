-- We've come a long way since the days of selling a single product.
-- Let's pull monthly trending for revenue and margin by product, along total sales and revenue.
-- Note anything you notice about seasonality.
SELECT
	YEAR(created_at) AS yr,
    MONTH(created_at) AS created_month,
	SUM(CASE WHEN product_id = 1 THEN price_usd ELSE NULL END) AS mrfuzzy_revenue,
    ROUND(SUM(CASE WHEN product_id = 1 THEN price_usd - cogs_usd ELSE NULL END),1) AS mrfuzzy_margin,
	SUM(CASE WHEN product_id = 2 THEN price_usd ELSE NULL END) AS love_bear_revenue,
    ROUND(SUM(CASE WHEN product_id = 2 THEN price_usd - cogs_usd ELSE NULL END),1) AS love_bear_margin,
	SUM(CASE WHEN product_id = 3 THEN price_usd ELSE NULL END) AS birthday_bear_revenue,
    ROUND(SUM(CASE WHEN product_id = 3 THEN price_usd - cogs_usd ELSE NULL END),1) AS birthday_bear_margin,
	SUM(CASE WHEN product_id = 4 THEN price_usd ELSE NULL END) AS mini_bear_revenue,
    ROUND(SUM(CASE WHEN product_id = 4 THEN price_usd - cogs_usd ELSE NULL END),1) AS mini_bear_margin,
    SUM(price_usd) AS total_revenue,
    COUNT(DISTINCT order_id) AS total_sales
FROM order_items
WHERE
     created_at < '2015-01-01'
GROUP BY
	YEAR(created_at),
    MONTH(created_at);
    
    
  