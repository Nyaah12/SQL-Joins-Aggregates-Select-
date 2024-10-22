#c402 Nyasha Mangwanda

/*
Join Queries

REQUIREMENT - Use a multi-line comment to paste the first 5 or fewer results under your query
		     Also include the total records returned.
*/



-- #1: Display the dateJoined and username for admin users
SELECT U.dateJoined, U.uname
FROM User U
JOIN UserRoles UR ON U.userid = UR.userid
WHERE UR.roleid = 1;




-- #2: Display each absolute order net (share*price), status, symbol, trade date, and username.
-- Sort the results with largest the absolute order net (share*price) at the top.
-- Include only orders that were not canceled or partially canceled.
SELECT ABS(shares * price) AS absolute_net_order, O.status, O.symbol, O.orderTime, U.uname
FROM orderbook_activity_db.Order O
JOIN orderbook_activity_db.User U ON O.userid = U.userid
WHERE O.status NOT IN ('canceled', 'partial_canceled')
ORDER BY absolute_net_order DESC;

      



-- #3: Display the orderid, symbol, status, order shares, filled shares, and price for orders with fills.
-- Note that filledShares are the opposite sign (+-) because they subtract from ordershares!
SELECT 
    o.orderid, 
    o.symbol, 
    o.status, 
    o.shares AS order_shares, 
    f.share * -1 AS filled_shares,  -- Opposite sign for filled shares
    o.price
FROM 
    `Order` o  -- Ensure the table name is correctly specified
JOIN 
    `Fill` f ON o.orderid = f.orderid  -- Matching orders with fills
WHERE 
    f.share IS NOT NULL;

 


-- #4: Display all partial_fill orders and how many outstanding shares are left.
-- Also include the username, symbol, and orderid.
SELECT 
    o.orderid, 
    u.uname AS username,  
    o.symbol, 
    o.shares - IFNULL(SUM(f.share), 0) AS outstanding_shares  
FROM 
    `Order` o
JOIN 
    `Fill` f ON o.orderid = f.orderid
JOIN 
    `User` u ON o.userid = u.userid 
JOIN 
    `UserRoles` ur ON u.userid = ur.userid  
GROUP BY 
    o.orderid, u.uname, o.symbol, o.shares
HAVING 
    outstanding_shares > 0  
ORDER BY 
    o.orderid;

    

-- #5: Display the orderid, symbol, status, order shares, filled shares, and price for orders with fills.
-- Also include the username, role, absolute net amount of shares filled, and absolute net order.
-- Sort by the absolute net order with the largest value at the top.
SELECT 
    o.orderid, 
    o.symbol, 
    o.status, 
    o.shares AS order_shares, 
    o.price,
    u.uname, 
    ur.roleid AS role,  
    ABS(SUM(f.share * f.price)) AS absolute_net_filled, 
    ABS(o.shares * o.price) AS absolute_net_order
FROM 
    orderbook_activity_db.Order o
JOIN 
    orderbook_activity_db.Fill f ON o.orderid = f.orderid
JOIN 
    orderbook_activity_db.User u ON o.userid = u.userid
JOIN 
    orderbook_activity_db.UserRoles ur ON u.userid = ur.userid
GROUP BY 
    o.orderid, o.symbol, o.status, o.shares, o.price, u.uname, ur.roleid
ORDER BY 
    absolute_net_order DESC;



-- #6: Display the username and user role for users who have not placed an order.
SELECT u.uname, ur.roleid  
FROM orderbook_activity_db.User u
LEFT JOIN orderbook_activity_db.Order o ON u.userid = o.userid
JOIN orderbook_activity_db.UserRoles ur ON u.userid = ur.userid
WHERE o.orderid IS NULL;


-- #7: Display orderid, username, role, symbol, price, and number of shares for orders with no fills.
SELECT 
    o.orderid, 
    u.uname AS username, 
    ur.roleid AS role, 
    o.symbol, 
    o.price, 
    o.shares AS number_of_shares
FROM 
    orderbook_activity_db.Order o
LEFT JOIN 
    orderbook_activity_db.Fill f ON o.orderid = f.orderid
JOIN 
    orderbook_activity_db.User u ON o.userid = u.userid
JOIN 
    orderbook_activity_db.UserRoles ur ON u.userid = ur.userid
WHERE 
    f.share IS NULL; 
    


-- #8: Display the symbol, username, role, and number of filled shares where the order symbol is WLY.
-- Include all orders, even if the order has no fills.
SELECT 
    o.symbol, 
    u.uname AS username, 
    ur.roleid AS role,  
    COALESCE(SUM(f.share), 0) AS number_of_filled_shares  
FROM 
    orderbook_activity_db.Order o
LEFT JOIN 
    orderbook_activity_db.Fill f ON o.orderid = f.orderid
JOIN 
    orderbook_activity_db.User u ON o.userid = u.userid
JOIN 
    orderbook_activity_db.UserRoles ur ON u.userid = ur.userid
WHERE 
    o.symbol = 'WLY'  
GROUP BY 
    o.symbol, u.uname, ur.roleid;  





