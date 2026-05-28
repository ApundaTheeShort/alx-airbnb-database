# Optimization Report

## Repository Information

- GitHub repository: `alx-airbnb-database`
- Directory: `database-adv-script`
- SQL file: `perfomance.sql`
- Report file: `optimization_report.md`

---

## Objective

The goal of this task was to retrieve all bookings together with user details, property details, and payment details, then analyze and optimize the query performance.

The query was analyzed using `EXPLAIN` to identify possible inefficiencies such as full table scans, unnecessary column retrieval, and joins that do not use indexes.

---

## Initial Query

The initial query retrieved all records and all columns from the `Booking`, `User`, `Property`, and `Payment` tables.

```sql
SELECT *
FROM Booking b
JOIN User u
    ON b.user_id = u.user_id
JOIN Property p
    ON b.property_id = p.property_id
LEFT JOIN Payment pay
    ON b.booking_id = pay.booking_id;
