# Database Performance Monitoring Report

## Repository Information

* Repository: alx-airbnb-database
* Directory: database-adv-script
* File: performance_monitoring.md

---

# Objective

The objective of this task was to continuously monitor database performance, identify bottlenecks in frequently executed queries, implement optimizations, and evaluate the resulting improvements.

Performance analysis was conducted using `EXPLAIN ANALYZE` and query execution plans.

---

# Query 1: Retrieve Bookings with User, Property, and Payment Details

## Original Query

```sql
SELECT *
FROM Booking b
JOIN User u
    ON b.user_id = u.user_id
JOIN Property p
    ON b.property_id = p.property_id
LEFT JOIN Payment pay
    ON b.booking_id = pay.booking_id;
```

## Performance Analysis

```sql
EXPLAIN ANALYZE
SELECT *
FROM Booking b
JOIN User u
    ON b.user_id = u.user_id
JOIN Property p
    ON b.property_id = p.property_id
LEFT JOIN Payment pay
    ON b.booking_id = pay.booking_id;
```

### Bottlenecks Identified

1. Use of `SELECT *` retrieves unnecessary columns.
2. Full table scans may occur on join columns.
3. Increased I/O due to large result sets.
4. Join operations become expensive as tables grow.

### Optimization Implemented

Created indexes on join columns:

```sql
CREATE INDEX idx_booking_user_id
ON Booking(user_id);

CREATE INDEX idx_booking_property_id
ON Booking(property_id);

CREATE INDEX idx_payment_booking_id
ON Payment(booking_id);
```

Refactored query:

```sql
SELECT
    b.booking_id,
    b.start_date,
    b.end_date,
    b.status,
    u.first_name,
    u.last_name,
    u.email,
    p.name,
    p.location,
    pay.amount
FROM Booking b
JOIN User u
    ON b.user_id = u.user_id
JOIN Property p
    ON b.property_id = p.property_id
LEFT JOIN Payment pay
    ON b.booking_id = pay.booking_id;
```

### Improvement Observed

* Reduced number of columns retrieved.
* Indexes enabled faster join operations.
* Lower query execution cost.
* Reduced execution time on larger datasets.

---

# Query 2: Search Bookings by Date Range

## Original Query

```sql
SELECT *
FROM Booking
WHERE start_date BETWEEN '2025-01-01'
                     AND '2025-03-31';
```

## Performance Analysis

```sql
EXPLAIN ANALYZE
SELECT *
FROM Booking
WHERE start_date BETWEEN '2025-01-01'
                     AND '2025-03-31';
```

### Bottlenecks Identified

1. Sequential scan on the Booking table.
2. Large number of rows examined.
3. Query performance decreases as booking records increase.

### Optimization Implemented

Created an index on `start_date`.

```sql
CREATE INDEX idx_booking_start_date
ON Booking(start_date);
```

Additionally, table partitioning was implemented based on `start_date`.

### Improvement Observed

* Index scan replaced sequential scan.
* Fewer rows examined.
* Improved date-range query performance.
* Better scalability for large datasets.

---

# Query 3: Filter Confirmed Bookings

## Original Query

```sql
SELECT *
FROM Booking
WHERE status = 'confirmed';
```

## Performance Analysis

```sql
EXPLAIN ANALYZE
SELECT *
FROM Booking
WHERE status = 'confirmed';
```

### Bottlenecks Identified

1. Full table scan on Booking.
2. Slow filtering when dataset grows.

### Optimization Implemented

Created an index on status.

```sql
CREATE INDEX idx_booking_status
ON Booking(status);
```

### Improvement Observed

* Faster filtering operations.
* Reduced query execution cost.
* Improved lookup speed for booking statuses.

---

# Query 4: Search Properties by Location

## Original Query

```sql
SELECT *
FROM Property
WHERE location = 'Nairobi';
```

## Performance Analysis

```sql
EXPLAIN ANALYZE
SELECT *
FROM Property
WHERE location = 'Nairobi';
```

### Bottlenecks Identified

1. Sequential scan on Property table.
2. Increased execution time as property records grow.

### Optimization Implemented

Created an index on location.

```sql
CREATE INDEX idx_property_location
ON Property(location);
```

### Improvement Observed

* Faster property searches.
* Reduced number of scanned rows.
* Lower query execution cost.

---

# Summary of Schema Improvements

The following indexes were added:

```sql
CREATE INDEX idx_booking_user_id
ON Booking(user_id);

CREATE INDEX idx_booking_property_id
ON Booking(property_id);

CREATE INDEX idx_payment_booking_id
ON Payment(booking_id);

CREATE INDEX idx_booking_start_date
ON Booking(start_date);

CREATE INDEX idx_booking_status
ON Booking(status);

CREATE INDEX idx_property_location
ON Property(location);
```

Additional optimization:

```sql
Partitioned Booking table by start_date
```

---

# Overall Results

| Query Type          | Bottleneck                  | Optimization         | Result           |
| ------------------- | --------------------------- | -------------------- | ---------------- |
| Multi-table joins   | Expensive joins, full scans | Foreign key indexes  | Faster joins     |
| Date range searches | Sequential scan             | Index + partitioning | Faster retrieval |
| Status filtering    | Full table scan             | Status index         | Faster filtering |
| Property searches   | Sequential scan             | Location index       | Faster searches  |

---

# Conclusion

Performance monitoring using `EXPLAIN ANALYZE` helped identify inefficient queries and schema bottlenecks. The primary issues were full table scans, inefficient joins, and missing indexes on frequently queried columns.

By creating indexes on join keys, filtering columns, and date columns, as well as implementing partitioning on the Booking table, query execution costs were reduced and overall performance improved significantly. These optimizations will become increasingly beneficial as the database grows in size and usage.
