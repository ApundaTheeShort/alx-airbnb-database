-- partitioning.sql
-- Repository: alx-airbnb-database
-- Directory: database-adv-script

-- ============================================================
-- STEP 1: CREATE PARTITIONED BOOKING TABLE
-- ============================================================
-- Example uses RANGE partitioning on start_date.
-- Adjust data types and columns to match your schema.

CREATE TABLE Booking_partitioned (
    booking_id VARCHAR(255) NOT NULL,
    property_id VARCHAR(255) NOT NULL,
    user_id VARCHAR(255) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10,2),
    status VARCHAR(50),
    created_at TIMESTAMP,

    PRIMARY KEY (booking_id, start_date)
)
PARTITION BY RANGE (YEAR(start_date)) (

    PARTITION p2022 VALUES LESS THAN (2023),

    PARTITION p2023 VALUES LESS THAN (2024),

    PARTITION p2024 VALUES LESS THAN (2025),

    PARTITION p2025 VALUES LESS THAN (2026),

    PARTITION p_future VALUES LESS THAN MAXVALUE
);

-- ============================================================
-- STEP 2: COPY DATA INTO PARTITIONED TABLE
-- ============================================================

INSERT INTO Booking_partitioned
SELECT *
FROM Booking;

-- ============================================================
-- STEP 3: PERFORMANCE TEST BEFORE PARTITIONING
-- ============================================================

EXPLAIN
SELECT *
FROM Booking
WHERE start_date BETWEEN '2025-01-01'
                     AND '2025-03-31';

-- ============================================================
-- STEP 4: PERFORMANCE TEST AFTER PARTITIONING
-- ============================================================

EXPLAIN
SELECT *
FROM Booking_partitioned
WHERE start_date BETWEEN '2025-01-01'
                     AND '2025-03-31';

-- ============================================================
-- STEP 5: ADD INDEX TO PARTITIONED TABLE
-- ============================================================

CREATE INDEX idx_partitioned_booking_start_date
ON Booking_partitioned(start_date);

-- ============================================================
-- STEP 6: ANALYZE QUERY PERFORMANCE
-- ============================================================

EXPLAIN ANALYZE
SELECT *
FROM Booking_partitioned
WHERE start_date BETWEEN '2025-01-01'
                     AND '2025-03-31';

-- Additional test

EXPLAIN ANALYZE
SELECT booking_id,
       property_id,
       user_id,
       start_date,
       end_date
FROM Booking_partitioned
WHERE start_date BETWEEN '2025-06-01'
                     AND '2025-06-30';
