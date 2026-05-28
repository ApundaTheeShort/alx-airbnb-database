-- all properties whose avg rating is > 4.0

SELECT p.id, p.title
FROM properties p
WHERE (SELECT AVG(rating) FROM reviews) > 4.0;

-- correlated subquery to find users who have made more than 3 bookings.
SELECT outer.user_id 
FROM bookings outer
WHERE outer.user_id = inner.user_id
(SELECT COUNT(inner.id),  inner.user_id 
  FROM bookings inner 
  GROUP BY inner.user_id 
  HAVING COUNT(inner.id) > 3 
  );
