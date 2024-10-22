-- Nyasha Mangwanda c402

/*
Aggregate Queries

REQUIREMENT - Use a multi-line comment to paste the first 5 or fewer results under your query
		     THEN records returned. 
*/

USE orderbook_activity_db;

-- #1: How many users do we have?
select count(*)
from User;

-- #2: List the username, userid, and number of orders each user has placed.
SELECT 
    u.uname AS username, 
    u.userid, 
    COUNT(o.orderid) AS number_of_orders
FROM 
    orderbook_activity_db.User u
LEFT JOIN 
    orderbook_activity_db.Order o ON u.userid = o.userid
GROUP BY 
    u.uname, u.userid;




-- #3: List the username, symbol, and number of orders placed for each user and for each symbol. 
-- Sort results in alphabetical order by symbol.
SELECT 
    u.uname AS username, 
    o.symbol, 
    COUNT(o.orderid) AS number_of_orders
FROM 
    orderbook_activity_db.User u
LEFT JOIN 
    orderbook_activity_db.Order o ON u.userid = o.userid
GROUP BY 
    u.uname, o.symbol
ORDER BY 
    o.symbol ASC;



-- #4: Perform the same query as the one above, but only include admin users.



-- #5: List the username and the average absolute net order amount for each user with an order.
-- Round the result to the nearest hundredth and use an alias (averageTradePrice).
-- Sort the results by averageTradePrice with the largest value at the top.
SELECT 
    u.uname AS username, 
    ROUND(AVG(ABS(o.shares * o.price)), 2) AS averageTradePrice
FROM 
    orderbook_activity_db.User u
JOIN 
    orderbook_activity_db.Order o ON u.userid = o.userid
GROUP BY 
    u.uname
ORDER BY 
    averageTradePrice DESC;


-- #6: How many shares for each symbol does each user have?
-- Display the username and symbol with number of shares.
SELECT 
    u.uname AS username, 
    o.symbol, 
    SUM(o.shares) AS number_of_shares
FROM 
    orderbook_activity_db.User u
JOIN 
    orderbook_activity_db.Order o ON u.userid = o.userid
GROUP BY 
    u.uname, o.symbol
ORDER BY 
    u.uname, o.symbol;  -- Optional: sort by username and symbol


-- #7: What symbols have at least 3 orders?
SELECT 
    o.symbol
FROM 
    orderbook_activity_db.Order o
GROUP BY 
    o.symbol
HAVING 
    COUNT(o.orderid) >= 3;  


-- #8: List all the symbols and absolute net fills that have fills exceeding $100.
-- Do not include the WLY symbol in the results.
-- Sort the results by highest net with the largest value at the top.
-- Sort by absolute net fill in descending order
select symbol, abs(share*price) as absolute_net_fills 
from orderbook_activity_db.Fill
where abs(share*price) > 100
and symbol <> 'WLY'
order by absolute_net_fills DESC;
     


-- #9: List the top five users with the greatest amount of outstanding orders.
-- Display the absolute amount filled, absolute amount ordered, and net outstanding.
-- Sort the results by the net outstanding amount with the largest value at the top.
SELECT * FROM orderbook_activity_db.Order;
select 
	u.uname as username,
    sum(abs(o.shares*o.price)) as absolute_amount_ordered,
    sum(abs(f.share*f.price)) as absolute_amount_filled,
    sum(abs(o.shares*o.price)) - coalesce(sum(abs(f.share*f.price)), 0) as net_outstanding
from
	orderbook_activity_db.User u
left join
	orderbook_activity_db.Order o on u.userid = o.userid
left join 
	orderbook_activity_db.Fill f on o.orderid = f.orderid
group by
	u.userid, u.uname
order by
	net_outstanding DESC
limit 5;
    
    


