/*
Toretto's Cafe wants to figure out which of their phone lines is getting the most traffic. 
Write a query that gets the number of messages for each location.
Structure the result to have the following columns:
-loc_id
-location_name
-message_count
*/


SELECT l.loc_id, l.name as location_name, COUNT(m.msg_id) as message_count
FROM message as m
INNER JOIN issue as i ON m.issue_id = i.issue_id
INNER JOIN convo as c ON i.convo_id = c.convo_id
INNER JOIN location as l ON c.loc_id = l.loc_id
GROUP BY l.loc_id;
