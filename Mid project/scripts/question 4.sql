-- I'm worried that one of our more passimistic board members may be concerned about the large % of traffic from gsearch.
-- Can you pull monthly trends for gsearch, alongside monthly trends for each of our other channels?

SELECT
	MIN(DATE(website_sessions.created_at)) AS month_start,
    COUNT(DISTINCT CASE WHEN website_sessions.utm_source = 'gsearch' THEN website_sessions.website_session_id ELSE NULL END) AS gsearch_sessions,
	COUNT(DISTINCT CASE WHEN website_sessions.utm_source = 'bsearch' THEN website_sessions.website_session_id ELSE NULL END) AS bsearch_sessions
FROM website_sessions
WHERE 
	website_sessions.created_at < '2012-11-27'
GROUP BY
		YEAR(website_sessions.created_at),
        MONTH(website_sessions.created_at);
        

