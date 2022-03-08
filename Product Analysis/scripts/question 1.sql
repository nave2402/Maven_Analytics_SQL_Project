SELECT
	MIN(DATE(created_at)) AS month_start,
    COUNT(order_id) AS number_of_sales,
    SUM(price_usd) AS total_revenue,
    SUM(price_usd - cogs_usd) AS total_margin
FROM orders
WHERE
	created_at < '2013-01-04'
GROUP BY
		MONTH(created_at);