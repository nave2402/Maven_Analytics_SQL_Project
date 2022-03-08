CREATE TEMPORARY TABLE first_and_second_sessions
SELECT
	website_sessions.user_id,
    first_sessions.website_session_id AS first_session,
    first_sessions.created_at AS date_first_session,
    MIN(website_sessions.website_session_id) AS second_session,
    website_sessions.created_at AS date_second_session
FROM(SELECT
		user_id,
        website_session_id,
        created_at
      FROM website_sessions
      WHERE
			created_at BETWEEN '2014-01-01' AND '2014-11-03'
            AND is_repeat_session = 0) AS first_sessions
   LEFT JOIN website_sessions
		ON website_sessions.user_id = first_sessions.user_id
        AND website_sessions.website_session_id > first_sessions.website_session_id
        AND website_sessions.created_at BETWEEN '2014-01-01' AND '2014-11-03'
        AND website_sessions.is_repeat_session = 1
GROUP BY
		website_sessions.user_id;
        
SELECT
		ROUND(AVG(days_first_to_second),2) AS avg_days_first_to_second,
        MIN(days_first_to_second) AS min_days_first_to_second,
        MAX(days_first_to_second) AS max_days_first_to_second
FROM(SELECT
			DATEDIFF(date_second_session,date_first_session) AS days_first_to_second
     FROM  first_and_second_sessions) AS diff_days;  
     

   
        
        