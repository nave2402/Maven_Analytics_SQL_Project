CREATE TEMPORARY TABLE sessions_with_days
SELECT
	DATE(created_at) AS created_date,
    WEEKDAY(created_at) AS weekday,
    HOUR(created_at) AS hr,
    COUNT(DISTINCT website_session_id) AS sessions
FROM website_sessions
WHERE
	created_at BETWEEN '2012-09-15' AND '2012-11-15'
GROUP BY
		1,2,3;

SELECT
	hr,
    ROUND(AVG(CASE WHEN weekday = 0 THEN sessions ELSE NULL END),1) AS Monday,
	ROUND(AVG(CASE WHEN weekday = 1 THEN sessions ELSE NULL END),1) AS Tuesday,
	ROUND(AVG(CASE WHEN weekday = 2 THEN sessions ELSE NULL END),1) AS Wednesday,
	ROUND(AVG(CASE WHEN weekday = 3 THEN sessions ELSE NULL END),1) AS Thursday,
	ROUND(AVG(CASE WHEN weekday = 4 THEN sessions ELSE NULL END),1) AS Friday,
	ROUND(AVG(CASE WHEN weekday = 5 THEN sessions ELSE NULL END),1) AS Saturday,
	ROUND(AVG(CASE WHEN weekday = 6 THEN sessions ELSE NULL END),1) AS Sunday
FROM sessions_with_days
GROUP BY 
		1
ORDER BY
		1;