-- aggregate querry for total number of bookings made by each user

SELECT COUNT(id) AS "count", user_id
FROM bookings
GROUP BY user_id;

-- 

-- SELECT p.id, p.name
-- ROW_NUMBER() OVER(ORDER BY id DESC) AS popularity
-- RANK() OVER(ORDER BY id DESC) AS rank
-- FROM properties;


--  aggregate queries for bookings and rankings
SELECT 
    PropertyID, 
    COUNT(*) AS TotalBookings,
    ROW_NUMBER() OVER(ORDER BY COUNT(*) DESC) AS Popularity
    RANK() OVER (ORDER BY COUNT(*) DESC) AS BookingRank
FROM Bookings 
GROUP BY PropertyID;
