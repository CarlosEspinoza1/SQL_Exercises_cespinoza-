/*
A client wants to reward their employees each week for building better relationships with their customers by using Kipsu. Write a query to get the number of messages sent by each employee last week.
Structure the result to have the following columns:
-user_id
-message_count
*/

SELECT m.author as user_id, COUNT(m.msg_id) as message_count
FROM message as m
INNER JOIN issue as i ON m.issue_id = i.issue_id
INNER JOIN convo as c ON i.convo_id = c.convo_id
INNER JOIN location as l ON c.loc_id = l.loc_id
GROUP BY m.author
ORDER BY l.loc_id, m.author DESC;