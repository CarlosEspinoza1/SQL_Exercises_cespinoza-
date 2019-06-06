/*
We’re developing a web-based chat widget for people to communicate with Kipsu. 
When a guest first opens the chat, we want to give them an estimate of how long 
it will be before they can expect a response. Write a query that finds, 
for each location at Toretto's Cafe, the average time (in seconds) that it 
takes a staff member to respond to a guest. 
Disregard any response times longer than 10 minutes so they don’t skew the results	
Structure the result to have the following columns:
-company_id
-loc_id
-average_response_time
*/

SELECT c.company_id, c.loc_id, ROUND(AVG(issue_rt.rt), 3) as average_response_time
FROM(
	SELECT umt.convo_id, umt.issue_id, umt.response_time - gmt.response_time as rt
	FROM
	(
		SELECT i.convo_id, i.issue_id, MIN(m.timestamp) as response_time
		FROM message as m
		INNER JOIN issue as i ON m.issue_id = i.issue_id
		WHERE m.type='reply' -- Gets the info for user
		GROUP BY i.issue_id
	) as umt
	
	INNER JOIN(
		SELECT i.convo_id, i.issue_id, MIN(m.timestamp) as response_time
		FROM message as m
		INNER JOIN issue as i ON m.issue_id = i.issue_id
		WHERE m.type='msg'
		GROUP BY i.issue_id
	) as gmt ON gmt.issue_id = umt.issue_id
	WHERE umt.response_time - gmt.response_time BETWEEN 0 AND 600  
) as issue_rt
INNER JOIN convo as c ON issue_rt.convo_id = c.convo_id
GROUP BY c.company_id, c.loc_id;
