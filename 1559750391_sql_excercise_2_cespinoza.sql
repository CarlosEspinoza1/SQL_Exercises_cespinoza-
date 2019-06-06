/* 
The previous query was okay, but Toretto's Cafe wants to be able to see trends over time. Write a query that gets the number of messages for each location for each week.
Structure the result to have the following columns:
-loc_id
-location_name
-year
-week_number (you can use the WEEK() function)
-message_count
*/ 


SELECT l.loc_id, l.name as location_name, YEAR(FROM_UNIXTIME(m.timestamp)) as 'Year', WEEK(FROM_UNIXTIME(m.timestamp)) as week_number, COUNT(m.msg_id) as message_count
FROM message as m
INNER JOIN issue as i ON m.issue_id = i.issue_id
INNER JOIN convo as c ON i.convo_id = c.convo_id
INNER JOIN location as l ON c.loc_id = l.loc_id
GROUP BY l.loc_id, YEAR(FROM_UNIXTIME(m.timestamp)), WEEK(FROM_UNIXTIME(m.timestamp))
ORDER BY l.loc_id, YEAR(FROM_UNIXTIME(m.timestamp)), WEEK(FROM_UNIXTIME(m.timestamp));
