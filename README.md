# Cinema Seat & Ticket Booking System Using MySQL

A relational database project that models core cinema operations: movies, screens, seats, show schedules, customers, bookings, and ticket-seat assignments. It demonstrates schema design and commonly used MySQL features, including constraints, indexes, views, stored procedures, triggers, functions, joins, aggregation, and subqueries.

> **Project scope:** This repository contains the MySQL database implementation and sample SQL queries. It is not a deployed web application. A booking website, real-time seat reservation, and online payment integration are future enhancements.

## Table of Contents

- [Project Overview](#project-overview)
- [Features](#features)
- [Technology Stack](#technology-stack)
- [Database Schema](#database-schema)
- [Sample Data](#sample-data)
- [Getting Started](#getting-started)
- [Database Objects](#database-objects)
- [Example Queries](#example-queries)
- [Validation and Limitations](#validation-and-limitations)
- [Repository Contents](#repository-contents)
- [Team Contributions](#team-contributions)
- [Future Enhancements](#future-enhancements)

## Project Overview

The system stores cinema information in related relational tables. Primary keys identify records, foreign keys connect related entities, and constraints help protect data integrity. SQL queries provide reports such as movie schedules, customer booking history, and confirmed revenue grouped by payment method.

## Features

- Seven relational tables connected through primary and foreign keys
- Unique and check constraints for selected data rules
- Representative sample data for testing and demonstration
- Four additional indexes for common filtering and lookup patterns
- Four views for schedules, booking details, occupancy, and customer summaries
- Four stored procedures for booking and reporting operations
- Four triggers for selected consistency checks and automatic actions
- Three user-defined functions
- Fifteen easy-to-medium SQL queries using filtering, sorting, joins, grouping, aggregation, `HAVING`, subqueries, and `NOT EXISTS`
- Data-integrity queries for booking/show and seat/screen consistency

## Technology Stack

- **Database:** MySQL (MySQL 8.x recommended)
- **SQL editor:** MySQL Workbench
- **Language:** SQL
- **Repository hosting:** GitHub

The script uses MySQL features such as `DELIMITER`, stored procedures, triggers, functions, `SIGNAL`, check constraints, and `CREATE OR REPLACE VIEW`. Exact feature support can vary with MySQL version and server configuration.

## Database Schema

The project has seven tables:

| Table | Purpose |
|---|---|
| `movies` | Movie title, genre, language, duration, release date, and rating |
| `screens` | Screen name, type, and configured seat capacity |
| `seats` | Seat number, row, seat type, and assigned screen |
| `shows` | Movie, screen, date, start/end times, and ticket price |
| `customers` | Customer contact details, city, and registration date |
| `bookings` | Customer/show references, booking date, total amount, booking status, payment method, and payment status |
| `booking_seats` | A booking's seat assignment, show, seat, and recorded price |

### Main relationships

- One movie can have many shows.
- One screen can have many seats and many shows.
- One customer can have many bookings.
- One show can be referenced by many bookings.
- One booking can contain many `booking_seats` rows.
- Each `booking_seats` row references a booking, show, and seat.

Unique constraints prevent duplicate seat numbers within the same screen and duplicate assignments of the same seat to the same show.

## Sample Data

The included insert statements are intended to populate these sample counts:

| Entity | Expected rows |
|---|---:|
| Movies | 10 |
| Screens | 4 |
| Seats | 44 |
| Shows | 15 |
| Customers | 12 |
| Bookings | 21 |
| Booking-seat records | 33 |

These are the counts specified by the sample script. Re-run the count query after setup to confirm the state of your own database.

## Getting Started

### Prerequisites

1. MySQL Server and MySQL Workbench (or another compatible MySQL client).
2. A MySQL version compatible with the SQL features used in the script; MySQL 8.x is recommended.
3. The SQL script in this repository.

### 1. Clone or download the repository

```bash
git clone https://github.com/Sanju-NS-0307/Cinema_seat-and-Ticket_booking.git
cd Cinema_seat-and-Ticket_booking
```

Alternatively, open the repository on GitHub and select **Code → Download ZIP**.

### 2. Open the SQL file

Open `cinema_seat_&_ticket_booking.sql` in MySQL Workbench and connect to your MySQL Server.

### 3. Important database reset warning

The script begins with:

```sql
DROP DATABASE IF EXISTS cinema_booking;
CREATE DATABASE cinema_booking;
USE cinema_booking;
```

**Warning:** `DROP DATABASE IF EXISTS cinema_booking` permanently deletes an existing database with that name, including its tables and records. Only execute the complete script when you intentionally want a fresh setup and have backed up anything important. If you already have a populated `cinema_booking` database, do not run the script from the beginning; execute only the required sections after reviewing them.

### 4. Execute the script

For a fresh setup, execute the SQL script in MySQL Workbench. It creates the schema and tables, inserts sample data, adds indexes and views, defines stored procedures/triggers/functions, and includes verification and demonstration queries.

If an error occurs, check the first relevant message in Workbench's **Action Output** panel before executing later sections. When executing stored-program definitions separately, include the corresponding `DELIMITER` statements.

### 5. Verify table creation

```sql
USE cinema_booking;
SHOW TABLES;
```

Expected tables: `movies`, `screens`, `seats`, `shows`, `customers`, `bookings`, and `booking_seats`.

### 6. Verify sample row counts

```sql
SELECT 'movies' AS table_name, COUNT(*) AS total_rows FROM movies
UNION ALL SELECT 'screens', COUNT(*) FROM screens
UNION ALL SELECT 'seats', COUNT(*) FROM seats
UNION ALL SELECT 'shows', COUNT(*) FROM shows
UNION ALL SELECT 'customers', COUNT(*) FROM customers
UNION ALL SELECT 'bookings', COUNT(*) FROM bookings
UNION ALL SELECT 'booking_seats', COUNT(*) FROM booking_seats;
```

## Database Objects

### Indexes

| Index | Columns |
|---|---|
| `idx_shows_date_time` | `shows(show_date, start_time)` |
| `idx_shows_movie_date` | `shows(movie_id, show_date)` |
| `idx_bookings_customer_status` | `bookings(customer_id, booking_status)` |
| `idx_bookings_date` | `bookings(booking_date)` |

Indexes can assist queries that match their indexed columns and ordering. Actual performance depends on the query, dataset size, and execution plan; this project does not claim benchmarked performance gains.

### Views

| View | Purpose |
|---|---|
| `view_show_schedule` | Joins movies and screens to present show schedules |
| `view_booking_details` | Presents booking, customer, movie, and payment details |
| `view_show_occupancy` | Summarizes recorded seat assignments and an occupancy percentage |
| `view_customer_booking_summary` | Summarizes confirmed bookings and amounts by customer |

### Stored procedures

| Procedure | Purpose |
|---|---|
| `sp_get_customer_bookings(p_customer_id)` | Retrieves a customer's bookings |
| `sp_revenue_by_payment()` | Groups confirmed, successfully paid bookings by payment method |
| `sp_get_shows_by_date(p_show_date)` | Lists shows scheduled for a selected date |
| `sp_get_available_seats(p_show_id)` | Lists seats not linked to a non-cancelled booking for a show |

Example calls:

```sql
CALL sp_get_customer_bookings(1);
CALL sp_revenue_by_payment();
CALL sp_get_shows_by_date('2026-10-10');
CALL sp_get_available_seats(1);
```

### Triggers

| Trigger | Purpose |
|---|---|
| `trg_validate_booking_show_insert` | Checks that the booking and booking-seat rows refer to the same show |
| `trg_validate_seat_screen_insert` | Checks that the selected seat belongs to the show's screen |
| `trg_update_booking_total_insert` | Recalculates a booking total after a seat row is inserted |
| `trg_block_movie_delete` | Blocks deletion of a movie while shows reference it |

### Functions

| Function | Purpose |
|---|---|
| `fn_booking_seat_total(p_booking_id)` | Sums recorded seat prices for a booking |
| `fn_customer_spending(p_customer_id)` | Sums amounts from confirmed, successfully paid bookings for a customer |
| `fn_available_seats(p_show_id)` | Estimates remaining seats using configured screen capacity and recorded seat assignments |

Example calls:

```sql
SELECT fn_booking_seat_total(1) AS booking_seat_total;
SELECT fn_customer_spending(1) AS customer_spending;
SELECT fn_available_seats(1) AS available_seats;
```

## Example Queries

### 1. Show schedule with movie and screen information

```sql
SELECT
    m.title AS movie_title,
    sh.show_date,
    sh.start_time,
    sc.screen_name,
    sh.ticket_price
FROM shows sh
JOIN movies m ON sh.movie_id = m.movie_id
JOIN screens sc ON sh.screen_id = sc.screen_id
ORDER BY sh.show_date, sh.start_time;
```

### 2. Confirmed and successfully paid revenue by payment method

```sql
SELECT
    payment_method,
    COUNT(*) AS total_bookings,
    SUM(total_amount) AS total_revenue
FROM bookings
WHERE booking_status = 'CONFIRMED'
  AND payment_status = 'SUCCESS'
GROUP BY payment_method
ORDER BY total_revenue DESC;
```

### 3. Find customers who have never made a booking

```sql
SELECT c.customer_id, c.name, c.email
FROM customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM bookings b
    WHERE b.customer_id = c.customer_id
);
```

The full script includes fifteen numbered SQL queries covering basic selections, conditions, joins, aggregation, `HAVING`, subqueries, and `NOT EXISTS`.

## Validation and Limitations

The script includes queries to check two consistency rules:

1. Each booking-seat row's show should match the show referenced by its booking.
2. Each assigned seat should belong to the screen scheduled for the show.

Run these checks and inspect the results in MySQL Workbench; the expected result for consistent sample data is zero inconsistent rows.

Known limitations:

- The script starts with a destructive database reset command. Review the warning above before execution.
- The occupancy view counts all recorded `booking_seats` rows, including rows related to cancelled bookings.
- `fn_available_seats` also counts recorded seat rows for cancelled bookings and uses configured screen capacity rather than counting actual seat records.
- The available-seat procedure treats pending bookings as occupied because it excludes only cancelled bookings.
- The booking-total trigger handles seat insertion, but does not recalculate totals after a booking-seat row is deleted or its price is updated.
- The project does not contain a user-facing application, live payment processing, or a fully production-ready reservation workflow.

## Repository Contents

```text
Cinema_seat-and-Ticket_booking/
├── README.md
└── cinema_seat_&_ticket_booking.sql
```

## Team Contributions

Replace the placeholders below with the actual names and contributions before final submission.

- **[Member 1]:** [Actual contribution]
- **[Member 2]:** [Actual contribution]
- **[Member 3]:** [Actual contribution]

If the project was completed individually, replace this list with a truthful summary of your own work. Do not leave placeholders in the submitted README.

## Future Enhancements

- Build a web or desktop interface for movie discovery and seat selection.
- Implement cancellation workflows that release seats and maintain accurate totals.
- Exclude cancelled bookings from occupancy and availability calculations.
- Integrate a payment provider using a secure application layer.
- Add automated tests and query-plan analysis against larger datasets.

## Repository

[Sanju-NS-0307/Cinema_seat-and-Ticket_booking](https://github.com/Sanju-NS-0307/Cinema_seat-and-Ticket_booking)

---

Created as an educational project to demonstrate relational database design and SQL programming using MySQL.
