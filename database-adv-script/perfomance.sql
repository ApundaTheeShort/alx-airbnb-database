SELECT * FROM bookings b
LEFT JOIN users u ON b.user_id = u.user_id 
LEFT JOIN properties p ON u.user_id = p.owners_id
LEFT JOIN payment pnt ON b.id = pnt.booking_id
ORDER BY b.id DESC;
