/*
Our previous average response time estimate is pretty good, but let’s make it a little more accurate and useful. 
Like the previous question, write a query that finds, for each location at Toretto's Cafe, the average time (in seconds) 
that it takes a staff member to respond to a guest, but this time also group it so that the numbers are broken down for each 
AM / PM period of each weekday (Sunday, Monday, Tuesday, etc.).
Disregard any response times longer than 10 minutes so they don’t skew the results
Use the timestamp of the first message from the guest to decide which day and AM/PM the issue should be considered
Structure the result to have the following columns:
-company_id
-loc_id
-weekday (you can use the DAYNAME() function to get the name of the day)
-am_pm (values: AM or PM)
-average_response_time
*/


SELECT c.company_id, c.loc_id, FROM_UNIXTIME(issue_rt.ap, '%a') as weekday, 
FROM_UNIXTIME(issue_rt.ap, '%p') as 'am_pm', ROUND(AVG(issue_rt.rt), 3) as average_response_time
FROM(
	SELECT umt.convo_id, umt.issue_id, umt.response_time - gmt_a.response_time as rt, gmt_a.ap as ap
	FROM
	(
		SELECT i.convo_id, i.issue_id, MIN(m.timestamp) as response_time
		FROM message as m
		INNER JOIN issue as i ON m.issue_id = i.issue_id
		WHERE m.type='reply' -- Makes sure its a user message
		GROUP BY i.issue_id
	) as umt
	
	INNER JOIN(
		SELECT i.convo_id, i.issue_id, MIN(m.timestamp) as response_time, m.timestamp as ap, 
		FROM_UNIXTIME(m.timestamp, '%a') as weekday, FROM_UNIXTIME(m.timestamp, '%p') as am_pm
		FROM message as m
		INNER JOIN issue as i ON m.issue_id = i.issue_id
		WHERE m.type='msg' -- Makes sure its a customer message in the AM
		GROUP BY i.issue_id
	) as gmt_a ON gmt_a.issue_id = umt.issue_id
	WHERE umt.response_time - gmt_a.response_time BETWEEN 0 AND 600
) as issue_rt
INNER JOIN convo as c ON issue_rt.convo_id = c.convo_id
GROUP BY weekday, am_pm;


