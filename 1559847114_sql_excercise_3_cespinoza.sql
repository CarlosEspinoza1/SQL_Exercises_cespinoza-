/*
(This one’s a doozy, you might want to leave it til the end) 
After the last report, Toretto's Cafe is now hungry for even more reporting stats. 
Now they want to know how many new guests they had using Kipsu each week vs. how many returning guests. 
Write a query that gets the number of repeat guests vs. the number of returning guests using Kipsu during each week. 
Note: a “repeat guest” can be defined as someone who has sent at least one message to Kipsu prior to that week.
Note: this query doesn’t need to be specific to locations; overall for the company is fine
Structure the result to have the following columns:
-year
-week (you can use the WEEK() function)
-repeat_guest_count
-new_guest_count
-total_guest_count
*/

SELECT guest_t.year, guest_t.week, guest_t.dt
FROM(
	SELECT gmt_1.msg1, gmt_2.msg2, gmt_1.atime - gmt_2.atime as dt, WEEK(FROM_UNIXTIME(gmt_1.msg1)) as 'week',
	YEAR(FROM_UNIXTIME(gmt_1.msg1)) as 'year'
	FROM(
		SELECT MAX(m.timestamp) as atime, i.issue_id, m.timestamp as msg1
		FROM message as m
	    INNER JOIN issue as i ON m.issue_id = i.issue_id
	    WHERE m.type='msg'
	    GROUP BY i.issue_id
    ) as gmt_1
    
    INNER JOIN(
    	SELECT MIN(m.timestamp) as atime, i.issue_id, m.timestamp as msg2
    	FROM message as m
	    INNER JOIN issue as i ON m.issue_id = i.issue_id
	    WHERE m.type='msg'
	    GROUP BY i.issue_id
    ) as gmt_2 ON gmt_2.issue_id = gmt_1.issue_id
    
) as guest_t

WHERE DAY(FROM_UNIXTIME(guest_t.dt)) > 7;

