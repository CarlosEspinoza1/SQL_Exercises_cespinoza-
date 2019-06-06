/*
After the first round of rewarding their employees, our client has found that some employees 
were cheating the system and inflating their numbers by sending a lot of extra messages. 
It has now become necessary to develop a better method of evaluating an employee’s use of Kipsu. 
Write a query that will get, for each user, the number of conversations (i.e. the issue table) 
which happened in the previous year that began with a message from that user and had at least 
one message in response from the guest. 
Note: a “conversation that happened in 2018” can be defined as an issue whose first message’s 
timestamp falls within 2018
Structure the result to have the following columns:
-user_id
-issue_count
*/


SELECT Msg_table.author as user_id, COUNT(*) as issue_count
FROM(
	SELECT i.issue_id, m.author, m.type, MIN(m.timestamp)
	FROM message as m
	INNER JOIN issue as i ON m.issue_id = i.issue_id
	WHERE YEAR(FROM_UNIXTIME(m.timestamp)) = 2015
	GROUP BY i.issue_id
) as Msg_table
INNER JOIN(
	SELECT i.issue_id, COUNT(*) as msg_count
	FROM message as m
	INNER JOIN issue as i ON m.issue_id = i.issue_id
	WHERE m.type='msg'
	GROUP BY i.issue_id
) as Issue_table ON Issue_table.issue_id = Msg_table.issue_id
WHERE Issue_table.msg_count >= 1 AND Msg_table.type = 'reply'
GROUP BY Msg_table.author;	