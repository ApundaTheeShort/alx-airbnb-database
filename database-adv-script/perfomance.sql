-- SELECT * FROM bookings b
-- LEFT JOIN users u ON b.user_id = u.user_id 
-- LEFT JOIN properties p ON u.user_id = p.owners_id
-- LEFT JOIN payment pnt ON b.id = pnt.booking_id
-- ORDER BY b.id DESC;

-- perfomance.sql
-- Repository: alx-airbnb-database
-- Directory: database-adv-script
-- Purpose:
--   1. Write an initial query that retrieves all bookings with user, property, and payment details.
--   2. Analyze performance using EXPLAIN.
--   3. Refactor the query to reduce execution time.
--
-- NOTE:
-- This file uses the table names: Booking, User, Property, and Payment.
-- If your schema uses lowercase/plural names such as bookings, users, properties, payments,
-- rename the table names accordingly.
--
-- If your database does not allow the table name User because it is reserved,
-- use the quoted version supported by your DBMS:
--   MySQL:      `User`
--   PostgreSQL: "User"


-- ============================================================
-- 1. INITIAL QUERY
-- ============================================================
-- This query retrieves all bookings together with user details,
-- property details, and payment details.
-- It uses SELECT *, which may return unnecessary columns and increase execution time.

SELECT *
FROM Booking b
JOIN User u
    ON b.user_id = u.user_id
JOIN Property p
    ON b.property_id = p.property_id
LEFT JOIN Payment pay
    ON b.booking_id = pay.booking_id;


-- ============================================================
-- 2. PERFORMANCE ANALYSIS OF INITIAL QUERY
-- ============================================================
-- Run this before optimization to inspect the execution plan.
-- Look for full table scans, high row counts, temporary tables, filesort,
-- and joins that do not use indexes.

EXPLAIN
SELECT *
FROM Booking b
JOIN User u
    ON b.user_id = u.user_id
JOIN Property p
    ON b.property_id = p.property_id
LEFT JOIN Payment pay
    ON b.booking_id = pay.booking_id;


-- ============================================================
-- 3. INDEXES USED FOR OPTIMIZATION
-- ============================================================
-- These indexes improve JOIN performance because the query joins tables
-- using foreign key columns.
--
-- Use IF NOT EXISTS only if your DBMS supports it.
-- If unsupported, remove IF NOT EXISTS.

CREATE INDEX idx_booking_user_id
ON Booking(user_id);

CREATE INDEX idx_booking_property_id
ON Booking(property_id);

CREATE INDEX idx_payment_booking_id
ON Payment(booking_id);

-- Optional indexes for sorting/filtering if you later add WHERE or ORDER BY clauses.
CREATE INDEX idx_booking_created_at
ON Booking(created_at);

CREATE INDEX idx_booking_status
ON Booking(status);


-- ============================================================
-- 4. REFACTORED / OPTIMIZED QUERY
-- ============================================================
-- Improvements:
--   1. Avoids SELECT *.
--   2. Returns only useful columns.
--   3. Keeps only required joins.
--   4. Uses indexed join columns.
--   5. Uses LEFT JOIN for Payment so bookings without payment are still returned.

SELECT
    b.booking_id,
    b.user_id,
    b.property_id,
    b.start_date,
    b.end_date,
    b.status AS booking_status,
    b.created_at AS booking_created_at,

    u.first_name,
    u.last_name,
    u.email,

    p.name AS property_name,
    p.location,
    p.pricepernight,

    pay.payment_id,
    pay.amount,
    pay.payment_method,
    pay.payment_status,
    pay.payment_date
FROM Booking b
JOIN User u
    ON b.user_id = u.user_id
JOIN Property p
    ON b.property_id = p.property_id
LEFT JOIN Payment pay
    ON b.booking_id = pay.booking_id;


-- ============================================================
-- 5. PERFORMANCE ANALYSIS OF OPTIMIZED QUERY
-- ============================================================
-- Run this after adding indexes and compare the output with the first EXPLAIN.
-- The optimized query should show better index usage on:
--   Booking.user_id
--   Booking.property_id
--   Payment.booking_id

EXPLAIN
SELECT
    b.booking_id,
    b.user_id,
    b.property_id,
    b.start_date,
    b.end_date,
    b.status AS booking_status,
    b.created_at AS booking_created_at,

    u.first_name,
    u.last_name,
    u.email,

    p.name AS property_name,
    p.location,
    p.pricepernight,

    pay.payment_id,
    pay.amount,
    pay.payment_method,
    pay.payment_status,
    pay.payment_date
FROM Booking b
JOIN User u
    ON b.user_id = u.user_id
JOIN Property p
    ON b.property_id = p.property_id
LEFT JOIN Payment pay
    ON b.booking_id = pay.booking_id;


-- ============================================================
-- OPTIONAL: POSTGRESQL VERSION WITH EXPLAIN ANALYZE
-- ============================================================
-- If you are using PostgreSQL, you can run this for actual runtime statistics:
--
-- EXPLAIN ANALYZE
-- SELECT
--     b.booking_id,
--     b.user_id,
--     b.property_id,
--     b.start_date,
--     b.end_date,
--     b.status AS booking_status,
--     b.created_at AS booking_created_at,
--     u.first_name,
--     u.last_name,
--     u.email,
--     p.name AS property_name,
--     p.location,
--     p.pricepernight,
--     pay.payment_id,
--     pay.amount,
--     pay.payment_method,
--     pay.payment_status,
--     pay.payment_date
-- FROM Booking b
-- JOIN User u
--     ON b.user_id = u.user_id
-- JOIN Property p
--     ON b.property_id = p.property_id
-- LEFT JOIN Payment pay
--     ON b.booking_id = pay.booking_id;
