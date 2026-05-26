SELECT * FROM bookings b
INNER JOIN users u 
ON b.user_id = u.id;

SELECT * FROM properties p
LEFT JOIN reviews r
ON p.id = r.property_id;

SELECT * FROM users u
FULL OUTER JOIN bookings b
ON u.id = b.user_id;
