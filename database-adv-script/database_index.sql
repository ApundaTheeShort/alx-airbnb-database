-- database_index.sql
-- Lowercase table-name version

-- ============================================================
-- PERFORMANCE CHECKS BEFORE ADDING INDEXES
-- ============================================================

EXPLAIN ANALYZE
SELECT *
FROM users
WHERE email = 'test@example.com';

EXPLAIN ANALYZE
SELECT *
FROM bookings
WHERE user_id = 'sample-user-id';

EXPLAIN ANALYZE
SELECT *
FROM bookings
WHERE property_id = 'sample-property-id';

EXPLAIN ANALYZE
SELECT *
FROM bookings
WHERE status = 'confirmed'
ORDER BY start_date DESC;

EXPLAIN ANALYZE
SELECT *
FROM properties
WHERE location = 'Nairobi'
ORDER BY pricepernight ASC;

EXPLAIN ANALYZE
SELECT b.booking_id, b.start_date, b.end_date, b.status,
       u.first_name, u.last_name,
       p.name AS property_name, p.location
FROM bookings b
JOIN users u ON b.user_id = u.user_id
JOIN properties p ON b.property_id = p.property_id
WHERE b.status = 'confirmed'
ORDER BY b.start_date DESC;


-- ============================================================
-- CREATE INDEX COMMANDS
-- ============================================================

-- User indexes
CREATE INDEX idx_users_email
ON users(email);

CREATE INDEX idx_users_role
ON users(role);

-- Booking indexes
CREATE INDEX idx_bookings_user_id
ON bookings(user_id);

CREATE INDEX idx_bookings_property_id
ON bookings(property_id);

CREATE INDEX idx_bookings_status
ON bookings(status);

CREATE INDEX idx_bookings_start_date
ON bookings(start_date);

CREATE INDEX idx_bookings_created_at
ON bookings(created_at);

CREATE INDEX idx_bookings_status_start_date
ON bookings(status, start_date);

-- Property indexes
CREATE INDEX idx_properties_location
ON properties(location);

CREATE INDEX idx_properties_pricepernight
ON properties(pricepernight);

CREATE INDEX idx_properties_created_at
ON properties(created_at);

CREATE INDEX idx_properties_host_id
ON properties(host_id);

-- If your properties table uses user_id instead of host_id, use this:
-- CREATE INDEX idx_properties_user_id
-- ON properties(user_id);

CREATE INDEX idx_properties_location_price
ON properties(location, pricepernight);


-- ============================================================
-- PERFORMANCE CHECKS AFTER ADDING INDEXES
-- ============================================================

EXPLAIN ANALYZE
SELECT *
FROM users
WHERE email = 'test@example.com';

EXPLAIN ANALYZE
SELECT *
FROM bookings
WHERE user_id = 'sample-user-id';

EXPLAIN ANALYZE
SELECT *
FROM bookings
WHERE property_id = 'sample-property-id';

EXPLAIN ANALYZE
SELECT *
FROM bookings
WHERE status = 'confirmed'
ORDER BY start_date DESC;

EXPLAIN ANALYZE
SELECT *
FROM properties
WHERE location = 'Nairobi'
ORDER BY pricepernight ASC;

EXPLAIN ANALYZE
SELECT b.booking_id, b.start_date, b.end_date, b.status,
       u.first_name, u.last_name,
       p.name AS property_name, p.location
FROM bookings b
JOIN users u ON b.user_id = u.user_id
JOIN properties p ON b.property_id = p.property_id
WHERE b.status = 'confirmed'
ORDER BY b.start_date DESC;
