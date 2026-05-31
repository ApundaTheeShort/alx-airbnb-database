# Partition Performance Report

## Repository Information

* Repository: alx-airbnb-database
* Directory: database-adv-script
* SQL File: partitioning.sql
* Report File: partition_performance.md

---

# Objective

The objective of this task was to improve query performance on a large Booking table by implementing table partitioning based on the `start_date` column.

Range partitioning was selected because booking queries frequently filter records by date ranges.

---

# Partitioning Strategy

The Booking table was partitioned using RANGE partitioning on the year extracted from the `start_date` column.

Partitions created:

| Partition | Date Range      |
| --------- | --------------- |
| p2022     | Before 2023     |
| p2023     | 2023 bookings   |
| p2024     | 2024 bookings   |
| p2025     | 2025 bookings   |
| p_future  | Future bookings |

Example:

```sql
PARTITION BY RANGE (YEAR(start_date))
```

This allows the database engine to scan only the relevant partition instead of scanning the entire Booking table.

---

# Performance Testing

## Query Tested

```sql
SELECT *
FROM Booking
WHERE start_date BETWEEN '2025-01-01'
                     AND '2025-03-31';
```

The same query was executed on both:

1. Original Booking table
2. Partitioned Booking table

Performance was analyzed using:

```sql
EXPLAIN
```

and

```sql
EXPLAIN ANALYZE
```

---

# Observations Before Partitioning

The execution plan showed:

* Full table scan on Booking.
* Large number of rows examined.
* Increased execution cost as table size grows.
* Query performance degraded when the table contained many years of booking data.

Example observations:

| Metric         | Value           |
| -------------- | --------------- |
| Scan Type      | Full Table Scan |
| Rows Examined  | High            |
| Query Cost     | High            |
| Execution Time | Slower          |

---

# Observations After Partitioning

The execution plan showed:

* Partition pruning was used.
* Only the partition containing 2025 records was scanned.
* Fewer rows were examined.
* Lower query cost.
* Faster execution time.

Example observations:

| Metric         | Value          |
| -------------- | -------------- |
| Scan Type      | Partition Scan |
| Rows Examined  | Reduced        |
| Query Cost     | Lower          |
| Execution Time | Faster         |

---

# Benefits of Partitioning

1. Reduced I/O operations because only relevant partitions are scanned.
2. Faster date-range queries.
3. Better scalability as booking records increase.
4. Improved maintenance since old partitions can be archived or removed independently.
5. Better overall performance when combined with indexing.

---

# Conclusion

Partitioning the Booking table by `start_date` significantly improved the performance of date-based queries. Instead of scanning the entire Booking table, the database engine was able to prune irrelevant partitions and access only the required data.

The improvement becomes more noticeable as the Booking table grows to millions of records. Combining partitioning with indexes on frequently queried columns provides additional performance gains and makes the database more scalable for production workloads.
