SELECT
	MIN(DATE(order_items.created_at)) AS created_date,
    COUNT(DISTINCT CASE WHEN order_items.product_id = 1 THEN order_items.order_id ELSE NULL END) AS p1_orders,
    COUNT(DISTINCT CASE WHEN order_items.product_id = 1 THEN order_item_refunds.order_item_refund_id ELSE NULL END) /
		  COUNT(DISTINCT CASE WHEN order_items.product_id = 1 THEN order_items.order_id ELSE NULL END) AS p1_refunds_rt,
	COUNT(DISTINCT CASE WHEN order_items.product_id = 2 THEN order_items.order_id ELSE NULL END) AS p2_orders,
    COUNT(DISTINCT CASE WHEN order_items.product_id = 2 THEN order_item_refunds.order_item_refund_id ELSE NULL END) /
		  COUNT(DISTINCT CASE WHEN order_items.product_id = 2 THEN order_items.order_id ELSE NULL END) AS p2_refunds_rt,
	COUNT(DISTINCT CASE WHEN order_items.product_id = 3 THEN order_items.order_id ELSE NULL END) AS p3_orders,
    COUNT(DISTINCT CASE WHEN order_items.product_id = 3 THEN order_item_refunds.order_item_refund_id ELSE NULL END) /
		  COUNT(DISTINCT CASE WHEN order_items.product_id = 3 THEN order_items.order_id ELSE NULL END) AS p3_refunds_rt,
	COUNT(DISTINCT CASE WHEN order_items.product_id = 4 THEN order_items.order_id ELSE NULL END) AS p4_orders,
    COUNT(DISTINCT CASE WHEN order_items.product_id = 4 THEN order_item_refunds.order_item_refund_id ELSE NULL END) /
		  COUNT(DISTINCT CASE WHEN order_items.product_id = 4 THEN order_items.order_id ELSE NULL END) AS p4_refunds_rt
FROM order_items
	LEFT JOIN order_item_refunds
		ON order_items.order_item_id = order_item_refunds.order_item_id
WHERE 
	order_items.created_at < '2014-10-15'
GROUP BY
	YEAR(order_items.created_at),
	MONTH(order_items.created_at)
-- ORDER BY
-- 	YEAR(order_items.created_at),
-- 	MONTH(order_items.created_at);