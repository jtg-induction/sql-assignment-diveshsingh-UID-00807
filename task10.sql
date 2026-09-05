-- 10.1
BEGIN;
INSERT INTO bookings (customer_id,showtime_id,seats_booked) VALUES (5,13,2);
UPDATE  customers SET loyalty_points=loyalty_points+10 WHERE customer_id=5 ;
END;




-- 10.2
BEGIN;
DELETE FROM bookings;
SELECT COUNT(*) FROM bookings;
ROLLBACK;
SELECT COUNT(*) FROM bookings;
END

-- 10.3
BEGIN;
INSERT INTO bookings (customer_id,showtime_id,seats_booked) VALUES (5,13,2);
SAVEPOINT ss;
UPDATE  customers SET status='oops' WHERE customer_id=111 ;
ROLLBACK TO ss;
END;
