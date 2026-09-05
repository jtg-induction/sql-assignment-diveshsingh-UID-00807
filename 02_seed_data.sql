-- ============================================================================
--  STARLIGHT CINEMAS · OPENING-WEEK DATA LOAD
--  File: 02_seed_data.sql
-- ----------------------------------------------------------------------------
--  !!!RUN THIS ONLY AFTER COMPLETING TASK 1.!!!
--  It inserts into the four tables YOU created (movies, screens, showtimes,
--  bookings). If your table or column names differ from the blueprints in
--  01_boilerplate.sql, this file will fail.
--
--
--  NOTE: rows are inserted with explicit primary-key values so that the
--  foreign-key references below always line up, then each SERIAL sequence
--  is re-synchronised at the bottom. If you ever need a clean re-load,
--  uncomment the RESET block first.
-- ============================================================================

-- ---------------------------------------------------------------------------
-- OPTIONAL RESET (uncomment only if re-running this file from scratch)
-- ---------------------------------------------------------------------------
-- TRUNCATE bookings, showtimes, movies, screens RESTART IDENTITY CASCADE;

-- ---------------------------------------------------------------------------
-- movies · the reopening slate
-- ---------------------------------------------------------------------------
INSERT INTO movies (movie_id, title, genre, rating, duration_minutes, release_year) VALUES
    ( 1, 'The Last Ledger',     'Drama',    'PG-13', 124, 2024),
    ( 2, 'Midnight at Marlowe', 'Thriller', 'R',     108, 2025),
    ( 3, 'Paper Moon Rising',   'Drama',    'PG',    116, 2023),
    ( 4, 'Quantum Alley',       'Sci-Fi',   'PG-13', 132, 2025),
    ( 5, 'The Comet Kidz',      'Family',   'G',      95, 2024),  
    ( 6, 'Static',              'Thriller', 'R',     101, 2026),
    ( 7, 'Garden of Glass',     'Romance',  'PG-13', 118, 2025),
    ( 8, 'Hollow Peak',         'Horror',   'R',      97, 2025),
    ( 9, 'The Sunday Painter',  'Drama',    'PG',    105, 2026),
    (10, 'Robo-Rascals 2',      'Family',   'PG',     89, 2026);

-- ---------------------------------------------------------------------------
-- screens · the renovated house
-- ---------------------------------------------------------------------------
INSERT INTO screens (screen_id, screen_name, capacity) VALUES
    (1, 'The Grand', 120),
    (2, 'The Loft',   60),
    (3, 'The Vault',  40);

-- ---------------------------------------------------------------------------
-- showtimes · opening week, Mon 2026-08-10 → Sun 2026-08-16
-- ---------------------------------------------------------------------------
INSERT INTO showtimes (showtime_id, movie_id, screen_id, show_date, start_time, ticket_price) VALUES
    ( 1,  1, 1, '2026-08-10', '19:00', 12.50),
    ( 2,  2, 3, '2026-08-10', '21:30', 11.00),
    ( 3,  5, 1, '2026-08-11', '16:00',  9.50),
    ( 4,  4, 1, '2026-08-11', '20:00', 13.00),
    ( 5,  7, 2, '2026-08-11', '18:30', 10.50),
    ( 6,  3, 2, '2026-08-12', '17:00',  9.50),
    ( 7,  6, 3, '2026-08-12', '21:00', 11.00),
    ( 8,  1, 1, '2026-08-13', '19:00', 12.50),
    ( 9,  8, 3, '2026-08-13', '23:00', 10.00),
    (10,  9, 2, '2026-08-14', '18:00', 10.50),
    (11,  4, 1, '2026-08-14', '20:30', 14.00),
    (12, 10, 1, '2026-08-15', '14:00',  9.50),
    (13,  2, 2, '2026-08-15', '20:00', 12.00),
    (14,  7, 3, '2026-08-15', '17:30', 10.50),
    (15,  6, 2, '2026-08-16', '21:00', 11.50),
    (16,  5, 1, '2026-08-16', '15:00',  9.50),
    (17,  8, 3, '2026-08-16', '22:30', 10.00),
    (18,  8, 3, '2026-08-16', '22:30', 10.00);

-- ---------------------------------------------------------------------------
-- bookings · presales for opening week
-- ---------------------------------------------------------------------------
INSERT INTO bookings (booking_id, customer_id, showtime_id, seats_booked, booked_at, status) VALUES
    ( 1,  1,  1, 2, '2026-08-08 10:15', 'confirmed'),
    ( 2,  2,  1, 4, '2026-08-08 11:02', 'confirmed'),
    ( 3,  3,  2, 1, '2026-08-08 12:40', 'confirmed'),
    ( 4,  4,  2, 2, '2026-08-09 09:12', 'confirmed'),
    ( 5,  1,  4, 3, '2026-08-09 10:05', 'confirmed'),
    ( 6,  5,  3, 5, '2026-08-09 10:44', 'confirmed'),
    ( 7,  6,  5, 2, '2026-08-09 13:37', 'confirmed'),
    ( 8,  7,  4, 2, '2026-08-09 15:20', 'cancelled'),
    ( 9, 10,  6, 1, '2026-08-10 08:30', 'confirmed'),
    (10, 11,  7, 2, '2026-08-10 09:14', 'confirmed'),
    (11, 12,  8, 4, '2026-08-10 09:55', 'confirmed'),
    (12,  2,  9, 2, '2026-08-10 12:21', 'confirmed'),
    (13,  3,  9, 3, '2026-08-10 12:48', 'confirmed'),
    (14,  4, 10, 1, '2026-08-11 14:06', 'confirmed'),
    (15,  5, 11, 2, '2026-08-11 16:29', 'confirmed'),
    (16,  1, 11, 2, '2026-08-11 17:03', 'confirmed'),
    (17,  6, 12, 6, '2026-08-12 10:10', 'confirmed'),
    (18,  7, 13, 2, '2026-08-12 11:45', 'confirmed'),
    (19, 10, 13, 2, '2026-08-12 13:00', 'cancelled'),
    (20, 11, 15, 3, '2026-08-12 18:22', 'confirmed'),
    (21, 12, 16, 2, '2026-08-13 09:41', 'confirmed'),
    (22,  2, 17, 1, '2026-08-13 10:02', 'confirmed'),
    (23,  3,  3, 2, '2026-08-13 10:59', 'confirmed'),
    (24,  4, 12, 4, '2026-08-13 12:17', 'confirmed'),
    (25,  5,  8, 2, '2026-08-13 15:34', 'confirmed'),
    (26,  6,  1, 1, '2026-08-14 08:08', 'confirmed'),
    (27,  7, 10, 2, '2026-08-14 09:26', 'confirmed'),
    (28, 10, 15, 2, '2026-08-14 11:11', 'confirmed'),
    (29, 11,  4, 2, '2026-08-14 12:52', 'confirmed'),
    (30, 12,  2, 2, '2026-08-14 14:31', 'confirmed'),
    (31,  1, 17, 3, '2026-08-15 09:15', 'confirmed'),
    (32,  2, 12, 2, '2026-08-15 10:47', 'confirmed');

-- ---------------------------------------------------------------------------
-- Re-synchronise the SERIAL sequences (we inserted explicit IDs above)
-- ---------------------------------------------------------------------------
SELECT setval(pg_get_serial_sequence('movies',    'movie_id'),    (SELECT MAX(movie_id)    FROM movies));
SELECT setval(pg_get_serial_sequence('screens',   'screen_id'),   (SELECT MAX(screen_id)   FROM screens));
SELECT setval(pg_get_serial_sequence('showtimes', 'showtime_id'), (SELECT MAX(showtime_id) FROM showtimes));
SELECT setval(pg_get_serial_sequence('bookings',  'booking_id'),  (SELECT MAX(booking_id)  FROM bookings));

-- ============================================================================
--  DATA LOADED. Expected row counts:
--    movies 10 · screens 3 · showtimes 18 · bookings 32
--  The box office is open. Proceed to Task 2.
-- ============================================================================
