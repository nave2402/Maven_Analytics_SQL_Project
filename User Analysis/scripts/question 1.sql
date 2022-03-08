CREATE TEMPORARY TABLE sessions_w_repeats
SELECT 
	new_sessions.user_id,
    new_sessions.website_session_id AS new_session_id,
    website_sessions.website_session_id AS repeat_session_id
FROM(
	SELECT
		user_id,
        website_session_id
     FROM website_sessions
     WHERE created_at BETWEEN '2014-01-01' AND '2014-11-01'
     AND is_repeat_session = 0) AS new_sessions
  LEFT JOIN website_sessions
		ON website_sessions.user_id = new_sessions.user_id
        AND website_sessions.is_repeat_session = 1
        AND website_sessions.website_session_id > new_sessions.website_session_id
        AND website_sessions.created_at BETWEEN '2014-01-01' AND '2014-11-01';
        
SELECT
	repeat_sessions,
	COUNT(DISTINCT user_id) AS users
FROM (
	  SELECT
			user_id,
            COUNT(DISTINCT new_session_id) AS new_sessions,
            COUNT(DISTINCT repeat_session_id) AS repeat_sessions
      FROM sessions_w_repeats
      GROUP BY 1
      ORDER BY 3 DESC) AS user_level
GROUP BY 1;      