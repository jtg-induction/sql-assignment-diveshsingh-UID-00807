-- ============================================================================
--  STARLIGHT CINEMAS · DATABASE BOOTSTRAP
--  File: 01_boilerplate.sql
-- ----------------------------------------------------------------------------
--  Welcome aboard, Database Engineer #1.
--
--  HOW TO RUN:
--    1. Create the database once:        CREATE DATABASE starlight;
--    2. Connect to it:                   
--    3. Run this file:                   
--
--  This file is safe to run top-to-bottom. It contains:
--    SECTION 1 — Tables Nadia's previous contractor already built  (given)
--    SECTION 2 — Seed data for those given tables                  (given)
--    SECTION 3 — Blueprints (stubs) for the tables YOU must build in Task 1
--
--  Do NOT modify Sections 1 and 2. Section 3 is entirely commented out —
--  it is your specification. Write your actual CREATE TABLE statements
--  in your own file: task01.sql
--
--  After you finish Task 1, load the business data with:  02_seed_data.sql
-- ============================================================================


-- ============================================================================
--  SECTION 1 · GIVEN TABLES  (do not modify)
-- ============================================================================

-- ----------------------------------------------------------------------------
-- customers
-- ----------------------------------------------------------------------------
-- The one table the previous contractor finished before quitting.
-- Study it carefully: it is your REFERENCE for what good DDL looks like.
-- Note the primary key, NOT NULL, UNIQUE, and DEFAULT clauses — you will be
-- expected to make the same kinds of decisions in Task 1.
-- ----------------------------------------------------------------------------
CREATE TABLE customers (
    customer_id     SERIAL PRIMARY KEY,                -- unique identity for every record
    full_name       TEXT        NOT NULL,              -- a customer must have a name
    email           TEXT        NOT NULL UNIQUE,       -- used for login + receipts; no duplicates
    phone           TEXT,                              -- optional
    loyalty_points  INT         NOT NULL DEFAULT 0,    -- everyone starts at zero
    joined_on       DATE        NOT NULL DEFAULT CURRENT_DATE
);

-- ----------------------------------------------------------------------------
-- promo_signups
-- ----------------------------------------------------------------------------
-- Marketing ran a kiosk at the Marlowe Creek Mall in July collecting emails
-- for the reopening newsletter. Some of these people are already customers,
-- some are not — and some customers never visited the kiosk.
-- You will reconcile these two lists in Task 4.
-- ----------------------------------------------------------------------------
CREATE TABLE promo_signups (
    signup_id     SERIAL PRIMARY KEY,
    full_name     TEXT NOT NULL,
    email         TEXT NOT NULL UNIQUE,
    signed_up_on  DATE NOT NULL DEFAULT CURRENT_DATE
);

-- ----------------------------------------------------------------------------
-- legacy_bookings
-- ----------------------------------------------------------------------------
-- Frank (the projectionist, 40 years of service) kept every sale from the
-- old single-screen era in ONE spreadsheet. This table reproduces it
-- faithfully — warts and all. It is intentionally, gloriously bad.
--
-- DO NOT "fix" this table. It is a museum piece. In Task 8 you will study
-- its design sins (1NF/2NF/3NF violations) and migrate its data out.
-- ----------------------------------------------------------------------------
CREATE TABLE legacy_bookings (
    ledger_id       SERIAL PRIMARY KEY,
    customer_name   TEXT,           -- repeated on every row, typos included
    customer_email  TEXT,           -- repeated on every row
    movie_title     TEXT,           -- repeated on every row
    movie_genre     TEXT,           -- depends on the movie, not the sale...
    show_date       DATE,
    seats           TEXT,           -- e.g. 'A1,A2,A3'  <-- yes, a comma-separated list
    ticket_price    NUMERIC(6,2)
);


-- ============================================================================
--  SECTION 2 · SEED DATA FOR GIVEN TABLES  (do not modify)
-- ============================================================================

INSERT INTO customers (full_name, email, phone, loyalty_points, joined_on) VALUES
    ('Ava Thompson',    'ava.thompson@example.com',    '555-0101', 120, '2025-11-02'),
    ('Ben Okafor',      'ben.okafor@example.com',      '555-0102',  45, '2025-11-15'),
    ('Chloe Nguyen',    'chloe.nguyen@example.com',    NULL,        80, '2025-12-01'),
    ('Daniel Rossi',    'daniel.rossi@example.com',    '555-0104',  15, '2026-01-09'),
    ('Elena Petrova',   'elena.petrova@example.com',   '555-0105', 200, '2026-01-20'),
    ('Farhan Ali',      'farhan.ali@example.com',      NULL,        60, '2026-02-14'),
    ('Grace Kim',       'grace.kim@example.com',       '555-0107',  95, '2026-03-03'),
    ('Henry Walker',    'henry.walker@example.com',    '555-0108',   0, '2026-03-28'),
    ('Isabella Moreau', 'isabella.moreau@example.com', NULL,        10, '2026-04-17'),
    ('Jamal Carter',    'jamal.carter@example.com',    '555-0110',  35, '2026-05-06'),
    ('Kira Sato',       'kira.sato@example.com',       '555-0111', 150, '2026-06-11'),
    ('Liam O''Brien',   'liam.obrien@example.com',     '555-0112',  25, '2026-07-19');

INSERT INTO promo_signups (full_name, email, signed_up_on) VALUES
    ('Ava Thompson',  'ava.thompson@example.com',  '2026-07-01'),
    ('Daniel Rossi',  'daniel.rossi@example.com',  '2026-07-01'),
    ('Maya Brooks',   'maya.brooks@example.com',   '2026-07-02'),
    ('Oliver Grant',  'oliver.grant@example.com',  '2026-07-02'),
    ('Grace Kim',     'grace.kim@example.com',     '2026-07-03'),
    ('Priya Raman',   'priya.raman@example.com',   '2026-07-03'),
    ('Walter Finch',  'walter.finch@example.com',  '2026-07-04'),
    ('Kira Sato',     'kira.sato@example.com',     '2026-07-05');

INSERT INTO legacy_bookings
    (customer_name, customer_email, movie_title, movie_genre, show_date, seats, ticket_price) VALUES
    ('Ava Thompson',            'ava.thompson@example.com',   'The Last Ledger',   'Drama', '2026-03-14', 'A1,A2',             10.00),
    ('Walter Finch',            'walter.finch@example.com',   'The Velvet Hour',   'Drama', '2026-03-14', 'B4',                10.00),
    ('Ava Thompson',            'ava.thompson@example.com',   'The Velvet Hour',   'Drama', '2026-03-21', 'A1,A2,A3',          10.00),
    ('Rosa Delgado',            'rosa.delgado@example.com',   'Paper Moon Rising', 'Drama', '2026-03-21', 'C2,C3',              9.00),
    ('Ben Okafor',              'ben.okafor@example.com',     'The Velvet Hour',   'Drama', '2026-03-28', 'D1',                10.00),
    ('Walter Finch',            'walter.finch@example.com',   'Paper Moon Rising', 'Drama', '2026-04-04', 'B4,B5',              9.00),
    ('Ava Thomson',             'ava.thompson@example.com',   'Paper Moon Rising', 'Drama', '2026-04-04', 'A1',                 9.00),  -- note the name typo
    ('Rosa Delgado',            'rosa.delgado@example.com',   'The Last Ledger',   'Drama', '2026-04-11', 'C2',                10.00),
    ('Kira Sato',               'kira.sato@example.com',      'The Velvet Hour',   'Drama', '2026-04-11', 'E1,E2',             10.00),
    ('Walter Finch',            'walter.finch@example.com',   'The Last Ledger',   'Drama', '2026-04-18', 'B4',                10.00),
    ('Marlowe Creek Film Club', 'filmclub@marlowecreek.org',  'Paper Moon Rising', 'Drama', '2026-04-25', 'F1,F2,F3,F4,F5,F6',  8.00),
    ('Rosa Delgado',            'rosa.delgado@example.com',   'The Velvet Hour',   'Drama', '2026-05-02', 'C2,C3',             10.00);


-- ============================================================================
--  SECTION 3 · YOUR BLUEPRINTS — TASK 1  (everything below stays commented)
-- ============================================================================
-- Nadia sketched these on a napkin during the renovation. Turn the napkin
-- into real DDL. Write your CREATE TABLE statements in task01.sql.
--
-- IMPORTANT: use EXACTLY these table and column names, or the seed file
-- (02_seed_data.sql) will not load.
--
-- Some constraints are deliberately left for Task 7 ("hardening"), so do not
-- add more than each blueprint asks for — you'll appreciate why later.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 3a. movies  — partially drafted by the contractor. Finish it.
-- ----------------------------------------------------------------------------
-- CREATE TABLE movies (
--     movie_id          SERIAL PRIMARY KEY,
--     title             TEXT,          -- TODO: a movie must always have a title
--     genre             TEXT,          -- e.g. 'Drama', 'Thriller', 'Family'
--     rating            TEXT,          -- 'G' | 'PG' | 'PG-13' | 'R'   (leave unchecked for now — Task 7)
--     duration_minutes  INT,           -- TODO: when present, must be greater than 0
--     release_year      INT            -- optional (Frank's ledger doesn't have it)
-- );

-- ----------------------------------------------------------------------------
-- 3b. screens  — build from scratch.
-- ----------------------------------------------------------------------------
--   screen_id     auto-incrementing primary key
--   screen_name   text, required, no two screens may share a name
--                 (they are: 'The Grand', 'The Loft', 'The Vault')
--   capacity      integer, required, must be greater than 0

-- ----------------------------------------------------------------------------
-- 3c. showtimes  — build from scratch.
-- ----------------------------------------------------------------------------
--   showtime_id   auto-incrementing primary key
--   movie_id      required; FOREIGN KEY -> movies(movie_id)
--   screen_id     required; FOREIGN KEY -> screens(screen_id)
--   show_date     DATE, required
--   start_time    TIME, required
--   ticket_price  NUMERIC(6,2), required   (price sanity check comes in Task 7)

-- ----------------------------------------------------------------------------
-- 3d. bookings  — build from scratch.
-- ----------------------------------------------------------------------------
--   booking_id    auto-incrementing primary key
--   customer_id   required; FOREIGN KEY -> customers(customer_id)
--   showtime_id   required; FOREIGN KEY -> showtimes(showtime_id)
--   seats_booked  integer, required        (range check comes in Task 7)
--   booked_at     TIMESTAMP, required, defaults to NOW()
--   status        TEXT, required, defaults to 'confirmed'
--                 (allowed values 'confirmed' / 'cancelled' — enforced in Task 7)

-- ============================================================================
--  END OF BOILERPLATE — good luck. Frank is watching.
-- ============================================================================
