-- 2.1
INSERT INTO movies (title,genre,rating,duration_minutes,release_year)
 VALUES ('The Marlowe Reel','Documentary','PG',88,'2026')

-- 2.2
INSERT INTO customers (full_name,email,phone) 
VALUES ('Divesh Singh','divesh.singh@joshtechnologygroup.com','8081099408')

-- 2.3
INSERT INTO showtimes (movie_id,screen_id,show_date,start_time,ticket_price)
 VALUES (11,3,'2026-08-16','18:00',8.00)

INSERT INTO bookings ( customer_id, showtime_id ,seats_booked)
VALUES (13,19,1)

-- 2.4
UPDATE  movies 
SET title='The Comet Kids' 
 WHERE movie_id = 5


-- 2.5
UPDATE showtimes 
SET ticket_price=ticket_price+2.00 
 WHERE show_date='2026-08-14' 
AND start_time>='18:00'

-- 2.6
UPDATE customers
 SET loyalty_points=loyalty_points+25
 WHERE email='elena.petrova@example.com';

-- 2.7
DELETE FROM showtimes
 WHERE showtime_id=18
