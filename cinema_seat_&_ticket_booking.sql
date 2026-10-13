
-- ============================================================
-- PROJECT: CINEMA SEAT & TICKET BOOKING SYSTEM
-- DATABASE: cinema_booking
-- DESCRIPTION: A MySQL database for movies, shows, seats,
--              customers, bookings, and ticket management.
-- ============================================================
-- WARNING: The database reset command below is destructive.
-- Do not execute the complete script on an existing database.
-- ============================================================

DROP DATABASE IF EXISTS cinema_booking;
CREATE DATABASE cinema_booking;
USE cinema_booking;


-- ============================================================
-- SECTION 01: TABLE CREATION
-- Creates the seven tables and their constraints,
-- primary keys, foreign keys, and validation rules.
-- ============================================================


CREATE TABLE movies (
    movie_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    genre VARCHAR(50) NOT NULL,
    language VARCHAR(30) NOT NULL,
    duration_minutes INT NOT NULL,
    release_date DATE,
    rating DECIMAL(3,1),
    CONSTRAINT chk_movie_duration CHECK (duration_minutes > 0),
    CONSTRAINT chk_movie_rating CHECK (rating IS NULL OR rating BETWEEN 0 AND 10)
);

CREATE TABLE screens (
    screen_id INT AUTO_INCREMENT PRIMARY KEY,
    screen_name VARCHAR(50) NOT NULL UNIQUE,
    screen_type VARCHAR(30) NOT NULL,
    total_seats INT NOT NULL,
    CONSTRAINT chk_screen_seats CHECK (total_seats > 0)
);

CREATE TABLE seats (
    seat_id INT AUTO_INCREMENT PRIMARY KEY,
    screen_id INT NOT NULL,
    seat_number VARCHAR(10) NOT NULL,
    row_name VARCHAR(5) NOT NULL,
    seat_type VARCHAR(20) NOT NULL,
    CONSTRAINT fk_seat_screen
        FOREIGN KEY (screen_id) REFERENCES screens(screen_id),
    CONSTRAINT uq_screen_seat UNIQUE (screen_id, seat_number)
);

CREATE TABLE shows (
    show_id INT AUTO_INCREMENT PRIMARY KEY,
    movie_id INT NOT NULL,
    screen_id INT NOT NULL,
    show_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    ticket_price DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_show_movie
        FOREIGN KEY (movie_id) REFERENCES movies(movie_id),
    CONSTRAINT fk_show_screen
        FOREIGN KEY (screen_id) REFERENCES screens(screen_id),
    CONSTRAINT uq_screen_show UNIQUE (screen_id, show_date, start_time),
    CONSTRAINT chk_show_time CHECK (end_time > start_time),
    CONSTRAINT chk_ticket_price CHECK (ticket_price > 0)
);

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15) NOT NULL UNIQUE,
    city VARCHAR(50),
    registration_date DATE NOT NULL DEFAULT (CURRENT_DATE)
);

CREATE TABLE bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    show_id INT NOT NULL,
    booking_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    booking_status ENUM('CONFIRMED','CANCELLED','PENDING') NOT NULL DEFAULT 'CONFIRMED',
    payment_method ENUM('UPI','CARD','CASH','WALLET') NOT NULL,
    payment_status ENUM('SUCCESS','FAILED','PENDING') NOT NULL DEFAULT 'SUCCESS',
    CONSTRAINT fk_booking_customer
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    CONSTRAINT fk_booking_show
        FOREIGN KEY (show_id) REFERENCES shows(show_id),
    CONSTRAINT chk_booking_amount CHECK (total_amount >= 0)
);

CREATE TABLE booking_seats (
    booking_seat_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    show_id INT NOT NULL,
    seat_id INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_bs_booking
        FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    CONSTRAINT fk_bs_show
        FOREIGN KEY (show_id) REFERENCES shows(show_id),
    CONSTRAINT fk_bs_seat
        FOREIGN KEY (seat_id) REFERENCES seats(seat_id),
    CONSTRAINT uq_show_seat UNIQUE (show_id, seat_id),
    CONSTRAINT uq_booking_seat UNIQUE (booking_id, seat_id),
    CONSTRAINT chk_bs_price CHECK (price > 0)
);

-- ============================================================
-- SECTION 02: TABLE STRUCTURE VERIFICATION
-- Displays the created tables and describes their columns.
-- ============================================================

SHOW TABLES;
DESCRIBE movies;
DESCRIBE screens;
DESCRIBE seats;
DESCRIBE shows;
DESCRIBE customers;
DESCRIBE bookings;
DESCRIBE booking_seats;


-- ============================================================
-- SECTION 03: SAMPLE DATA INSERTION
-- Inserts demonstration records into all seven tables.
-- Insert order follows the foreign-key dependencies.
-- ============================================================

INSERT INTO movies (title, genre, language, duration_minutes, release_date, rating) VALUES
('Interstellar', 'Sci-Fi', 'English', 169, '2014-11-07', 8.7),
('Inception', 'Sci-Fi', 'English', 148, '2010-07-16', 8.8),
('RRR', 'Action', 'Telugu', 187, '2022-03-25', 8.0),
('Pushpa 2', 'Action', 'Telugu', 200, '2024-12-05', 6.1),
('Kalki 2898 AD', 'Sci-Fi', 'Telugu', 180, '2024-06-27', 7.0),
('The Dark Knight', 'Action', 'English', 152, '2008-07-18', 9.0),
('3 Idiots', 'Comedy', 'Hindi', 170, '2009-12-25', 8.4),
('Jawan', 'Action', 'Hindi', 169, '2023-09-07', 7.0),
('Dune: Part Two', 'Sci-Fi', 'English', 166, '2024-03-01', 8.5),
('Leo', 'Action', 'Tamil', 164, '2023-10-19', 7.2);

INSERT INTO screens (screen_name, screen_type, total_seats) VALUES
('Screen 1', 'IMAX', 12),
('Screen 2', '4DX', 10),
('Screen 3', 'Standard', 12),
('Screen 4', 'Standard', 10);

-- Insert seats after screens. Seat IDs are generated in screen order.
INSERT INTO seats (screen_id, seat_number, row_name, seat_type) VALUES
(1,'A1','A','Premium'), (1,'A2','A','Premium'), (1,'A3','A','Premium'), (1,'A4','A','Premium'),
(1,'B1','B','Regular'), (1,'B2','B','Regular'), (1,'B3','B','Regular'), (1,'B4','B','Regular'),
(1,'C1','C','Regular'), (1,'C2','C','Regular'), (1,'C3','C','Regular'), (1,'C4','C','Regular'),
(2,'A1','A','Premium'), (2,'A2','A','Premium'), (2,'A3','A','Premium'), (2,'A4','A','Premium'),
(2,'B1','B','Regular'), (2,'B2','B','Regular'), (2,'B3','B','Regular'),
(2,'C1','C','Regular'), (2,'C2','C','Regular'), (2,'C3','C','Regular'),
(3,'A1','A','Premium'), (3,'A2','A','Premium'), (3,'A3','A','Premium'), (3,'A4','A','Premium'),
(3,'B1','B','Regular'), (3,'B2','B','Regular'), (3,'B3','B','Regular'), (3,'B4','B','Regular'),
(3,'C1','C','Regular'), (3,'C2','C','Regular'), (3,'C3','C','Regular'), (3,'C4','C','Regular'),
(4,'A1','A','Premium'), (4,'A2','A','Premium'), (4,'A3','A','Premium'), (4,'A4','A','Premium'),
(4,'B1','B','Regular'), (4,'B2','B','Regular'), (4,'B3','B','Regular'),
(4,'C1','C','Regular'), (4,'C2','C','Regular'), (4,'C3','C','Regular');

-- Insert shows after movies and screens. Show IDs are generated from this order.
INSERT INTO shows (movie_id, screen_id, show_date, start_time, end_time, ticket_price) VALUES
(1,1,'2026-10-10','10:00:00','12:49:00',300.00),
(1,1,'2026-10-10','18:00:00','20:49:00',350.00),
(2,2,'2026-10-10','11:00:00','13:28:00',280.00),
(2,2,'2026-10-10','19:00:00','21:28:00',320.00),
(3,3,'2026-10-11','10:30:00','13:37:00',220.00),
(3,3,'2026-10-11','18:30:00','21:37:00',280.00),
(4,4,'2026-10-11','12:00:00','15:20:00',250.00),
(4,4,'2026-10-11','20:00:00','23:20:00',300.00),
(5,1,'2026-10-12','11:00:00','14:00:00',300.00),
(5,1,'2026-10-12','19:00:00','22:00:00',350.00),
(6,2,'2026-10-12','10:00:00','12:32:00',250.00),
(7,3,'2026-10-12','17:30:00','20:20:00',200.00),
(8,4,'2026-10-13','11:30:00','14:19:00',220.00),
(9,1,'2026-10-13','18:00:00','20:46:00',320.00),
(10,2,'2026-10-13','20:00:00','22:44:00',280.00);

INSERT INTO customers (name, email, phone, city, registration_date) VALUES
('Rahul Sharma','rahul@gmail.com','9876500001','Visakhapatnam','2026-09-01'),
('Priya Reddy','priya@gmail.com','9876500002','Hyderabad','2026-09-03'),
('Arjun Kumar','arjun@gmail.com','9876500003','Visakhapatnam','2026-09-05'),
('Sneha Rao','sneha@gmail.com','9876500004','Vijayawada','2026-09-08'),
('Vikram Singh','vikram@gmail.com','9876500005','Hyderabad','2026-09-10'),
('Ananya Das','ananya@gmail.com','9876500006','Visakhapatnam','2026-09-12'),
('Kiran Reddy','kiran@gmail.com','9876500007','Guntur','2026-09-15'),
('Meena Patel','meena@gmail.com','9876500008','Visakhapatnam','2026-09-18'),
('Rohit Verma','rohit@gmail.com','9876500009','Hyderabad','2026-09-20'),
('Divya Nair','divya@gmail.com','9876500010','Vijayawada','2026-09-22'),
('Manoj Rao','manoj@gmail.com','9876500011','Guntur','2026-09-24'),
('Pooja Singh','pooja@gmail.com','9876500012','Visakhapatnam','2026-09-25');

-- Insert bookings after customers and shows.
-- booking IDs 1-21 are generated in this exact order.
INSERT INTO bookings (customer_id, show_id, booking_date, total_amount, booking_status, payment_method, payment_status) VALUES
(1,1,'2026-10-08 10:00:00',600.00,'CONFIRMED','UPI','SUCCESS'),
(2,1,'2026-10-08 10:15:00',300.00,'CONFIRMED','CARD','SUCCESS'),
(3,2,'2026-10-08 11:00:00',700.00,'CONFIRMED','UPI','SUCCESS'),
(4,3,'2026-10-08 11:20:00',560.00,'CONFIRMED','CARD','SUCCESS'),
(5,4,'2026-10-08 12:00:00',320.00,'CONFIRMED','UPI','SUCCESS'),
(6,5,'2026-10-08 12:30:00',440.00,'CONFIRMED','CASH','SUCCESS'),
(7,6,'2026-10-08 13:00:00',560.00,'CONFIRMED','UPI','SUCCESS'),
(8,7,'2026-10-08 14:00:00',250.00,'CONFIRMED','CARD','SUCCESS'),
(9,8,'2026-10-08 14:30:00',600.00,'CONFIRMED','UPI','SUCCESS'),
(10,9,'2026-10-08 15:00:00',600.00,'CONFIRMED','WALLET','SUCCESS'),
(11,10,'2026-10-08 15:20:00',350.00,'CONFIRMED','UPI','SUCCESS'),
(12,11,'2026-10-08 16:00:00',500.00,'CONFIRMED','CARD','SUCCESS'),
(1,12,'2026-10-08 16:30:00',400.00,'CONFIRMED','UPI','SUCCESS'),
(2,13,'2026-10-08 17:00:00',440.00,'CONFIRMED','CARD','SUCCESS'),
(3,14,'2026-10-08 17:30:00',640.00,'CONFIRMED','UPI','SUCCESS'),
(4,15,'2026-10-08 18:00:00',560.00,'CONFIRMED','CARD','SUCCESS'),
(5,1,'2026-10-08 18:15:00',350.00,'CANCELLED','UPI','FAILED'),
(6,3,'2026-10-08 18:30:00',280.00,'PENDING','UPI','PENDING'),
(7,5,'2026-10-08 19:00:00',220.00,'CONFIRMED','CASH','SUCCESS'),
(8,9,'2026-10-08 19:30:00',300.00,'CONFIRMED','UPI','SUCCESS'),
(9,9,'2026-10-08 19:45:00',300.00,'CONFIRMED','CARD','SUCCESS');

-- Each booking_seats row uses an existing booking, the same show as that
-- booking, and a seat from the screen assigned to that show.
-- The unique(show_id, seat_id) constraint prevents double-booking a seat.
INSERT INTO booking_seats (booking_id, show_id, seat_id, price) VALUES
(1,1,1,300.00),(1,1,2,300.00),
(2,1,3,300.00),
(3,2,4,350.00),(3,2,5,350.00),
(4,3,13,280.00),(4,3,14,280.00),
(5,4,15,320.00),
(6,5,23,220.00),(6,5,24,220.00),
(7,6,25,280.00),(7,6,26,280.00),
(8,7,35,250.00),
(9,8,36,300.00),(9,8,37,300.00),
(10,9,6,300.00),(10,9,7,300.00),
(11,10,8,350.00),
(12,11,17,250.00),(12,11,18,250.00),
(13,12,27,200.00),(13,12,28,200.00),
(14,13,38,220.00),(14,13,39,220.00),
(15,14,9,320.00),(15,14,10,320.00),
(16,15,19,280.00),(16,15,20,280.00),
(17,1,11,350.00),
(18,3,16,280.00),
(19,5,29,220.00),
(20,9,12,300.00),
(21,9,1,300.00);


-- ============================================================
-- SECTION 04: INITIAL DATA VERIFICATION
-- Checks record counts and displays inserted sample data.
-- ============================================================

SELECT COUNT(*) AS movie_count FROM movies;
SELECT COUNT(*) AS screen_count FROM screens;
SELECT COUNT(*) AS seat_count FROM seats;
SELECT COUNT(*) AS show_count FROM shows;
SELECT COUNT(*) AS customer_count FROM customers;
SELECT COUNT(*) AS booking_count FROM bookings;
SELECT COUNT(*) AS booking_seat_count FROM booking_seats;

SELECT * FROM movies;
SELECT * FROM screens;
SELECT * FROM seats;
SELECT * FROM shows;
SELECT * FROM customers;
SELECT * FROM bookings;
SELECT * FROM booking_seats;


-- ============================================================
-- SECTION 05: INDEX CREATION
-- Adds indexes to support common filtering and lookup queries.
-- ============================================================
CREATE INDEX idx_shows_date_time ON shows(show_date, start_time);
CREATE INDEX idx_shows_movie_date ON shows(movie_id, show_date);
CREATE INDEX idx_bookings_customer_status ON bookings(customer_id, booking_status);
CREATE INDEX idx_bookings_date ON bookings(booking_date);

SHOW INDEX FROM shows;
SHOW INDEX FROM bookings;


-- ============================================================
-- SECTION 06: VIEW CREATION
-- Creates reusable views for schedules, booking details,
-- show occupancy, and customer booking summaries.
-- ============================================================
CREATE OR REPLACE VIEW view_show_schedule AS
SELECT sh.show_id, m.title AS movie_title, m.language,
       sc.screen_name, sc.screen_type, sh.show_date,
       sh.start_time, sh.end_time, sh.ticket_price
FROM shows sh
JOIN movies m ON sh.movie_id = m.movie_id
JOIN screens sc ON sh.screen_id = sc.screen_id;

CREATE OR REPLACE VIEW view_booking_details AS
SELECT b.booking_id, c.name AS customer_name, c.city,
       m.title AS movie_title, sh.show_date, sh.start_time,
       b.total_amount, b.booking_status, b.payment_method, b.payment_status
FROM bookings b
JOIN customers c ON b.customer_id = c.customer_id
JOIN shows sh ON b.show_id = sh.show_id
JOIN movies m ON sh.movie_id = m.movie_id;

CREATE OR REPLACE VIEW view_show_occupancy AS
SELECT sh.show_id, m.title AS movie_title, sc.screen_name,
       sc.total_seats, COUNT(bs.booking_seat_id) AS booked_seats,
       ROUND(COUNT(bs.booking_seat_id) * 100.0 / sc.total_seats, 2) AS occupancy_percentage
FROM shows sh
JOIN movies m ON sh.movie_id = m.movie_id
JOIN screens sc ON sh.screen_id = sc.screen_id
LEFT JOIN booking_seats bs ON sh.show_id = bs.show_id
GROUP BY sh.show_id, m.title, sc.screen_name, sc.total_seats;

CREATE OR REPLACE VIEW view_customer_booking_summary AS
SELECT c.customer_id, c.name, c.email, c.city,
       COUNT(CASE WHEN b.booking_status = 'CONFIRMED' THEN b.booking_id END) AS confirmed_bookings,
       COALESCE(SUM(CASE WHEN b.booking_status = 'CONFIRMED' THEN b.total_amount ELSE 0 END), 0) AS confirmed_spending
FROM customers c
LEFT JOIN bookings b ON c.customer_id = b.customer_id
GROUP BY c.customer_id, c.name, c.email, c.city;

SELECT * FROM view_show_schedule;
SELECT * FROM view_booking_details;
SELECT * FROM view_show_occupancy;
SELECT * FROM view_customer_booking_summary;


-- ============================================================
-- SECTION 07: STORED PROCEDURES
-- Creates reusable procedures for customer bookings,
-- revenue reports, show schedules, and available seats.
-- ============================================================
DROP PROCEDURE IF EXISTS sp_get_customer_bookings;
DROP PROCEDURE IF EXISTS sp_revenue_by_payment;
DROP PROCEDURE IF EXISTS sp_get_shows_by_date;
DROP PROCEDURE IF EXISTS sp_get_available_seats;

DELIMITER $$

CREATE PROCEDURE sp_get_customer_bookings(IN p_customer_id INT)
BEGIN
    SELECT b.booking_id, m.title AS movie_title, sh.show_date,
           sh.start_time, b.total_amount, b.booking_status
    FROM bookings b
    JOIN shows sh ON b.show_id = sh.show_id
    JOIN movies m ON sh.movie_id = m.movie_id
    WHERE b.customer_id = p_customer_id
    ORDER BY b.booking_date DESC;
END$$

CREATE PROCEDURE sp_revenue_by_payment()
BEGIN
    SELECT payment_method, COUNT(*) AS booking_count,
           SUM(total_amount) AS total_revenue
    FROM bookings
    WHERE booking_status = 'CONFIRMED'
      AND payment_status = 'SUCCESS'
    GROUP BY payment_method
    ORDER BY total_revenue DESC;
END$$

CREATE PROCEDURE sp_get_shows_by_date(IN p_show_date DATE)
BEGIN
    SELECT sh.show_id, m.title AS movie_title, sc.screen_name,
           sh.start_time, sh.end_time, sh.ticket_price
    FROM shows sh
    JOIN movies m ON sh.movie_id = m.movie_id
    JOIN screens sc ON sh.screen_id = sc.screen_id
    WHERE sh.show_date = p_show_date
    ORDER BY sh.start_time;
END$$

CREATE PROCEDURE sp_get_available_seats(IN p_show_id INT)
BEGIN
    SELECT s.seat_id, s.seat_number, s.row_name, s.seat_type
    FROM shows sh
    JOIN seats s ON s.screen_id = sh.screen_id
    WHERE sh.show_id = p_show_id
      AND NOT EXISTS (
          SELECT 1
          FROM booking_seats bs
          JOIN bookings b ON b.booking_id = bs.booking_id
          WHERE bs.show_id = p_show_id
            AND bs.seat_id = s.seat_id
            AND b.booking_status <> 'CANCELLED'
      )
    ORDER BY s.row_name, s.seat_number;
END$$

DELIMITER ;

CALL sp_get_customer_bookings(1);
CALL sp_revenue_by_payment();
CALL sp_get_shows_by_date('2026-10-10');
CALL sp_get_available_seats(1);



-- ============================================================
-- SECTION 08: TRIGGERS
-- Validates booking-show and seat-screen relationships,
-- updates booking totals, and protects referenced movies.
-- ============================================================

DROP TRIGGER IF EXISTS trg_validate_booking_show_insert;
DROP TRIGGER IF EXISTS trg_validate_seat_screen_insert;
DROP TRIGGER IF EXISTS trg_update_booking_total_insert;
DROP TRIGGER IF EXISTS trg_block_movie_delete;

DELIMITER $$

-- Trigger 1: A booking-seat row must use the same show as its booking.
CREATE TRIGGER trg_validate_booking_show_insert
BEFORE INSERT ON booking_seats
FOR EACH ROW
BEGIN
    DECLARE v_booking_show INT DEFAULT NULL;

    SELECT show_id INTO v_booking_show
    FROM bookings
    WHERE booking_id = NEW.booking_id;

    IF v_booking_show IS NULL OR v_booking_show <> NEW.show_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Booking show_id must match booking_seats show_id';
    END IF;
END$$

-- Trigger 2: The selected seat must belong to the screen assigned to the show.
CREATE TRIGGER trg_validate_seat_screen_insert
BEFORE INSERT ON booking_seats
FOR EACH ROW
BEGIN
    DECLARE v_show_screen INT DEFAULT NULL;
    DECLARE v_seat_screen INT DEFAULT NULL;

    SELECT screen_id INTO v_show_screen
    FROM shows
    WHERE show_id = NEW.show_id;

    SELECT screen_id INTO v_seat_screen
    FROM seats
    WHERE seat_id = NEW.seat_id;

    IF v_show_screen IS NULL OR v_seat_screen IS NULL OR v_show_screen <> v_seat_screen THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Seat must belong to the screen assigned to the show';
    END IF;
END$$

-- Trigger 3: Recalculate the booking total after adding a seat.
CREATE TRIGGER trg_update_booking_total_insert
AFTER INSERT ON booking_seats
FOR EACH ROW
BEGIN
    UPDATE bookings
    SET total_amount = (
        SELECT COALESCE(SUM(price), 0)
        FROM booking_seats
        WHERE booking_id = NEW.booking_id
    )
    WHERE booking_id = NEW.booking_id;
END$$

-- Trigger 4: Do not delete a movie while shows reference it.
CREATE TRIGGER trg_block_movie_delete
BEFORE DELETE ON movies
FOR EACH ROW
BEGIN
    DECLARE v_show_count INT DEFAULT 0;

    SELECT COUNT(*) INTO v_show_count
    FROM shows
    WHERE movie_id = OLD.movie_id;

    IF v_show_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete a movie while shows reference it';
    END IF;
END$$

DELIMITER ;


-- ============================================================
-- SECTION 09: FEATURE AND OBJECT VERIFICATION
-- Checks triggers, tables, views, procedures, and indexes.
-- ============================================================
SHOW TRIGGERS;

SHOW TABLES;

SELECT * FROM view_show_schedule;
SELECT * FROM view_booking_details;
SELECT * FROM view_show_occupancy;
SELECT * FROM view_customer_booking_summary;

CALL sp_get_customer_bookings(1);
CALL sp_revenue_by_payment();
CALL sp_get_shows_by_date('2026-10-10');
CALL sp_get_available_seats(1);

SHOW INDEX FROM shows;
SHOW INDEX FROM bookings;
SHOW TRIGGERS;


-- ============================================================
-- SECTION 10: DATA INTEGRITY VALIDATION
-- Checks that booking-seat records match their bookings
-- and that selected seats belong to the correct screen.
-- Both validation queries should return zero rows.
-- ============================================================

-- Check that every booking-seat row matches its booking's show.
SELECT bs.booking_seat_id, bs.booking_id, bs.show_id AS seat_show_id,
       b.show_id AS booking_show_id
FROM booking_seats bs
JOIN bookings b ON b.booking_id = bs.booking_id
WHERE bs.show_id <> b.show_id;

-- Check that every seat belongs to the screen used by the show.
SELECT bs.booking_seat_id, bs.show_id, bs.seat_id
FROM booking_seats bs
JOIN shows sh ON sh.show_id = bs.show_id
JOIN seats s ON s.seat_id = bs.seat_id
WHERE sh.screen_id <> s.screen_id;

-- Both validation queries above should return zero rows.


-- ============================================================
-- SECTION 11: USER-DEFINED FUNCTIONS
-- Calculates booking seat totals, customer spending,
-- and estimated available seats for a show.
-- ============================================================

DROP FUNCTION IF EXISTS fn_booking_seat_total;
DELIMITER $$

CREATE FUNCTION fn_booking_seat_total(p_booking_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_total DECIMAL(10,2);

    SELECT COALESCE(SUM(price), 0)
    INTO v_total
    FROM booking_seats
    WHERE booking_id = p_booking_id;

    RETURN v_total;
END $$

DELIMITER ;

DROP FUNCTION IF EXISTS fn_customer_spending;
DELIMITER $$

CREATE FUNCTION fn_customer_spending(p_customer_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_spending DECIMAL(10,2);

    SELECT COALESCE(SUM(total_amount), 0)
    INTO v_spending
    FROM bookings
    WHERE customer_id = p_customer_id
      AND booking_status = 'CONFIRMED'
      AND payment_status = 'SUCCESS';

    RETURN v_spending;
END $$

DELIMITER ;

DROP FUNCTION IF EXISTS fn_available_seats;
DELIMITER $$

CREATE FUNCTION fn_available_seats(p_show_id INT)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_capacity INT DEFAULT 0;
    DECLARE v_booked INT DEFAULT 0;

    SELECT sc.total_seats
    INTO v_capacity
    FROM shows sh
    JOIN screens sc ON sh.screen_id = sc.screen_id
    WHERE sh.show_id = p_show_id;

    SELECT COUNT(*)
    INTO v_booked
    FROM booking_seats
    WHERE show_id = p_show_id;

    RETURN GREATEST(v_capacity - v_booked, 0);
END $$

DELIMITER ;


-- ============================================================
-- SECTION 12: FINAL PROJECT TESTS
-- Executes views, stored procedures, and functions to
-- demonstrate that the database features work together.
-- ============================================================

SELECT * FROM view_show_schedule;
SELECT * FROM view_booking_details;
SELECT * FROM view_show_occupancy;

-- Bookings for customer ID 1
CALL sp_get_customer_bookings(1);

-- Confirmed and successfully paid revenue by payment method
CALL sp_revenue_by_payment();

-- Shows scheduled for 10 October 2026
CALL sp_get_shows_by_date('2026-10-10');

-- Total seat price for booking ID 1
SELECT fn_booking_seat_total(1) AS booking_seat_total;

-- Confirmed and successfully paid spending for customer ID 1
SELECT fn_customer_spending(1) AS customer_spending;

-- Estimated available seats for show ID 1
SELECT fn_available_seats(1) AS available_seats;



-- ============================================================
-- SECTION 13: PROJECT SQL QUERIES
-- Cinema Seat & Ticket Booking System
-- Difficulty: Easy to Medium
-- ============================================================

USE cinema_booking;

-- QUERY 01: Display all movies
SELECT *
FROM movies;

-- QUERY 02: Find movies with a rating above 8
SELECT title, genre, rating
FROM movies
WHERE rating > 8
ORDER BY rating DESC;

-- QUERY 03: Find movies in a particular language
SELECT title, language, duration_minutes
FROM movies
WHERE language = 'Telugu';

-- QUERY 04: Find shows scheduled on a specific date
SELECT show_id, show_date, start_time, end_time, ticket_price
FROM shows
WHERE show_date = '2026-10-10'
ORDER BY start_time;

-- QUERY 05: Display movies with their show timings
SELECT m.title, sh.show_date, sh.start_time,
       sh.end_time, sh.ticket_price
FROM movies m
JOIN shows sh ON m.movie_id = sh.movie_id
ORDER BY sh.show_date, sh.start_time;

-- QUERY 06: Display shows with their screen details
SELECT sh.show_id, m.title, sc.screen_name,
       sc.screen_type, sh.show_date, sh.start_time
FROM shows sh
JOIN movies m ON sh.movie_id = m.movie_id
JOIN screens sc ON sh.screen_id = sc.screen_id
ORDER BY sh.show_date, sh.start_time;

-- QUERY 07: Find all bookings made by each customer
SELECT c.name, b.booking_id, b.booking_date,
       b.total_amount, b.booking_status
FROM customers c
JOIN bookings b ON c.customer_id = b.customer_id
ORDER BY c.name, b.booking_date;

-- QUERY 08: Display confirmed bookings with successful payments
SELECT booking_id, customer_id, total_amount,
       payment_method, payment_status
FROM bookings
WHERE booking_status = 'CONFIRMED'
  AND payment_status = 'SUCCESS';

-- QUERY 09: Count the total number of movies by genre
SELECT genre, COUNT(*) AS total_movies
FROM movies
GROUP BY genre
ORDER BY total_movies DESC;

-- QUERY 10: Calculate the average movie rating by language
SELECT language, ROUND(AVG(rating), 2) AS average_rating
FROM movies
WHERE rating IS NOT NULL
GROUP BY language
ORDER BY average_rating DESC;

-- QUERY 11: Calculate successful revenue by payment method
SELECT payment_method,
       COUNT(*) AS total_bookings,
       SUM(total_amount) AS total_revenue
FROM bookings
WHERE booking_status = 'CONFIRMED'
  AND payment_status = 'SUCCESS'
GROUP BY payment_method
ORDER BY total_revenue DESC;

-- QUERY 12: Find customers who have made more than one booking
SELECT c.customer_id, c.name,
       COUNT(b.booking_id) AS total_bookings
FROM customers c
JOIN bookings b ON c.customer_id = b.customer_id
GROUP BY c.customer_id, c.name
HAVING COUNT(b.booking_id) > 1
ORDER BY total_bookings DESC;

-- QUERY 13: Find movies whose ticket price is above
-- the average ticket price of all shows
SELECT m.title, sh.ticket_price
FROM movies m
JOIN shows sh ON m.movie_id = sh.movie_id
WHERE sh.ticket_price > (
    SELECT AVG(ticket_price)
    FROM shows
)
ORDER BY sh.ticket_price DESC;

-- QUERY 14: Find customers who have never made a booking
SELECT c.customer_id, c.name, c.email
FROM customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM bookings b
    WHERE b.customer_id = c.customer_id
);

-- QUERY 15: Display the number of booked seats for each show
SELECT sh.show_id, m.title, sh.show_date,
       sh.start_time,
       COUNT(bs.booking_seat_id) AS booked_seats
FROM shows sh
JOIN movies m ON sh.movie_id = m.movie_id
LEFT JOIN booking_seats bs ON sh.show_id = bs.show_id
GROUP BY sh.show_id, m.title, sh.show_date, sh.start_time
ORDER BY sh.show_date, sh.start_time;


















