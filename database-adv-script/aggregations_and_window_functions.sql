SELECT COUNT(id) AS "count", user_id
FROM bookings
GROUP BY user_id;
