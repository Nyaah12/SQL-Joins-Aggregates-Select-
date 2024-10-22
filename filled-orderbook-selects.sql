--#Nyasha Mangwanda c402

/*
Basic Selects

REQUIREMENT - Use a multi-line comment to paste the first 5 or fewer results under your query
		     Also include the total records returned.
*/

USE orderbook_activity_db;

-- #1: List all users, including username and dateJoined.
SELECT * 
FROM User;

-- #2: List the username and datejoined from users with the newest users at the top.
SELECT uname, dateJoined
From User
ORDER BY dateJoined ASC;

-- #3: List all usernames and dateJoined for users who joined in March 2023.
Select uname, dateJoined
from User
Where dateJoined between '2023-03-01' and '2023-03-31';

-- #4: List the different role names a user can have.
select * 
from Role;

-- #5: List all the orders.
select * 
from orderbook_activity_db.Order;

-- #6: List all orders in March where the absolute net order amount is greater than 1000.
select * 
from orderbook_activity_db.Order
where orderTime between '2023-03-01' and '2023-03-31' 
and abs(shares*price) > 1000;

-- #7: List all the unique status types from orders.
select distinct(status)
from orderbook_activity_db.Order;

-- #8: List all pending and partial fill orders with oldest orders first.
select *
from orderbook_activity_db.Order
where status in ('partial_fill', 'pending')
order by orderTime Desc;

-- #9: List the 10 most expensive financial products where the productType is stock.
-- Sort the results with the most expensive product at the top
select * 
from Product
where productType = ('stock')
order by price desc
limit 10;



-- #10: Display orderid, fillid, userid, symbol, and absolute net fill amount
-- from fills where the absolute net fill is greater than $1000.
-- Sort the results with the largest absolute net fill at the top.
select orderid, fillid, userid, symbol, abs(share*price) as net_fill_amount
from Fill
where abs(share*price) > 1000
order by net_fill_amount DESC;
