SELECT
		CASE 
			WHEN utm_campaign = 'nonbrand' THEN 'paid_nonbrand'
			WHEN utm_campaign = 'brand' THEN 'paid_brand'
			WHEN utm_source = 'socialbook' THEN 'paid_social'
            WHEN utm_source IS NULL AND http_referer IS NULL THEN 'direct_type_in'
            WHEN utm_source IS NULL AND http_referer IS NOT NULL THEN 'organic_search'
            END AS channel_group,
            COUNT(DISTINCT CASE WHEN is_repeat_session = 0 THEN website_session_id ELSE NULL END) AS new_sessions,
            COUNT(DISTINCT CASE WHEN is_repeat_session = 1 THEN website_session_id ELSE NULL END) AS repeat_sessions
FROM website_sessions
WHERE created_at BETWEEN '2014-01-01' AND '2014-11-05'
GROUP BY
		channel_group;
    
   
            
            