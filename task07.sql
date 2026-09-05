-- 7.1
ALTER TABLE bookings 
ADD CONSTRAINT chk_seat 
CHECK(seats_booked>=1 AND seats_booked<=10);

-- 7.2
ALTER TABLE bookings 
ADD CONSTRAINT chk_status 
CHECK(status='confirmed' OR status='cancelled');

-- 7.3
ALTER TABLE showtimes 
ADD CONSTRAINT chk_ticket 
CHECK(ticket_price>0);

-- 7.4
ALTER TABLE showtimes 
ADD CONSTRAINT unq 
UNIQUE(screen_id,show_date,start_time)

-- 7.5
ALTER TABLE movies
 ADD CONSTRAINT chk_srating 
 CHECK(rating='G' OR rating='PG' OR rating='PG-13' OR rating='R' OR rating='');

-- 7.6
INSERT INTO bookings (customer_id,showtime_id,seats_booked) 
VALUES (1,1,0)

INSERT INTO showtimes (movie_id,screen_id,show_date,start_time,ticket_price) 
VALUES (1,1, '2026-08-10', '19:00', 12.50)

INSERT INTO movies (title,genre,rating,duration_minutes,release_year)
 VALUES ('The Last Ledger',     'Drama',    'NC-99', 124, 2024)
