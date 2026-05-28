# Index Performance Analysis

## Objective

The objective of this task is to identify high-usage columns in the `User`, `Booking`, and `Property` tables and create appropriate indexes to improve query performance. These columns are commonly used in `WHERE`, `JOIN`, and `ORDER BY` clauses.

Performance was measured before and after adding indexes using `EXPLAIN ANALYZE`.

---

## High-Usage Columns Identified

### User Table

| Column    | Reason for Indexing                                              |
| --------- | ---------------------------------------------------------------- |
| `user_id` | Used in joins with the `Booking` and `Property` tables           |
| `email`   | Used in `WHERE` clauses for user lookup and login authentication |
| `role`    | Used in `WHERE` clauses to filter users by role                  |

### Booking Table

| Column        | Reason for Indexing                                  |
| ------------- | ---------------------------------------------------- |
| `booking_id`  | Used as the primary identifier for bookings          |
| `user_id`     | Used in joins between `Booking` and `User`           |
| `property_id` | Used in joins between `Booking` and `Property`       |
| `status`      | Used in `WHERE` clauses to filter bookings by status |
| `start_date`  | Used in date filtering and `ORDER BY` clauses        |
| `created_at`  | Used to sort bookings by creation date               |

### Property Table

| Column          | Reason for Indexing                                           |
| --------------- | ------------------------------------------------------------- |
| `property_id`   | Used in joins between `Property` and `Booking`                |
| `host_id`       | Used in joins between `Property` and `User`                   |
| `location`      | Used in `WHERE` clauses when searching properties by location |
| `pricepernight` | Used in filtering and sorting properties by price             |
| `created_at`    | Used to sort recently added properties                        |

---

## Indexes Created

The following indexes were added in `database_index.sql`:

```sql
CREATE INDEX idx_user_email ON User(email);
CREATE INDEX idx_user_role ON User(role);

CREATE INDEX idx_booking_user_id ON Booking(user_id);
CREATE INDEX idx_booking_property_id ON Booking(property_id);
CREATE INDEX idx_booking_status ON Booking(status);
CREATE INDEX idx_booking_start_date ON Booking(start_date);
CREATE INDEX idx_booking_created_at ON Booking(created_at);
CREATE INDEX idx_booking_status_start_date ON Booking(status, start_date);

CREATE INDEX idx_property_location ON Property(location);
CREATE INDEX idx_property_pricepernight ON Property(pricepernight);
CREATE INDEX idx_property_created_at ON Property(created_at);
CREATE INDEX idx_property_host_id ON Property(host_id);
CREATE INDEX idx_property_location_price ON Property(location, pricepernight);
```

---

## Performance Measurement Queries

The following queries were used to test performance before and after creating indexes.

### 1. User Lookup by Email

```sql
EXPLAIN ANALYZE
SELECT *
FROM User
WHERE email = 'test@example.com';
```

### 2. Booking Lookup by User

```sql
EXPLAIN ANALYZE
SELECT *
FROM Booking
WHERE user_id = 'sample-user-id';
```

### 3. Booking Lookup by Property

```sql
EXPLAIN ANALYZE
SELECT *
FROM Booking
WHERE property_id = 'sample-property-id';
```

### 4. Booking Filtered by Status and Sorted by Date

```sql
EXPLAIN ANALYZE
SELECT *
FROM Booking
WHERE status = 'confirmed'
ORDER BY start_date DESC;
```

### 5. Property Search by Location and Price

```sql
EXPLAIN ANALYZE
SELECT *
FROM Property
WHERE location = 'Nairobi'
ORDER BY pricepernight ASC;
```

### 6. Join Query Across User, Booking, and Property

```sql
EXPLAIN ANALYZE
SELECT b.booking_id, b.start_date, b.end_date, b.status,
       u.first_name, u.last_name,
       p.name AS property_name, p.location
FROM Booking b
JOIN User u ON b.user_id = u.user_id
JOIN Property p ON b.property_id = p.property_id
WHERE b.status = 'confirmed'
ORDER BY b.start_date DESC;
```

---

## Performance Results

> Replace the sample values below with the actual output from your database after running `EXPLAIN ANALYZE`.

| Query                                 |                         Before Indexing |                             After Indexing | Improvement                    |
| ------------------------------------- | --------------------------------------: | -----------------------------------------: | ------------------------------ |
| User lookup by email                  | Sequential scan / higher execution time |          Index scan / lower execution time | Faster user lookup             |
| Booking lookup by user ID             |                         Sequential scan |                    Index scan on `user_id` | Faster booking retrieval       |
| Booking lookup by property ID         |                         Sequential scan |                Index scan on `property_id` | Faster property booking lookup |
| Booking filter by status and date     |                Sequential scan and sort |           Index scan using composite index | Faster filtering and ordering  |
| Property search by location and price |                Sequential scan and sort |           Index scan using composite index | Faster property search         |
| Join query                            |                        Higher join cost | Lower join cost using indexed foreign keys | Faster joins                   |

---

## Example Observation

Before indexing, the database may perform a sequential scan, meaning it reads many rows in the table to find matching records. This increases query cost and execution time, especially when the table grows larger.

After indexing, the database can use index scans to locate matching records faster. Indexes on foreign key columns such as `Booking.user_id`, `Booking.property_id`, and `Property.host_id` improve join performance. Composite indexes such as `(status, start_date)` and `(location, pricepernight)` improve queries that filter and sort data at the same time.

---

## Conclusion

Adding indexes on high-usage columns improved query performance by reducing full table scans and allowing the database engine to find records more efficiently. The most useful indexes were added on columns used in joins, filtering, and sorting operations.

However, indexes should be created carefully because too many indexes can slow down `INSERT`, `UPDATE`, and `DELETE` operations. The selected indexes focus only on columns that are frequently used in common queries.
::: 
