SELECT p.id, p.title
FROM properties p
WHERE (SELECT AVG(rating) FROM reviews);
