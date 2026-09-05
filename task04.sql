-- 4.1
SELECT c.full_name,m.title,sh.show_date,sh.start_time,seats_booked,status 
FROM bookings AS b 
INNER JOIN customers AS c 
ON b.customer_id=c.customer_id
INNER JOIN showtimes AS sh 
ON b.showtime_id=sh.showtime_id 
INNER JOIN movies AS m 
ON sh.movie_id=m.movie_id 
ORDER BY b.booked_at;

-- 4.2
SELECT c.full_name 
FROM customers AS c 
LEFT JOIN bookings AS b 
ON (c.customer_id=b.customer_id) 
WHERE b.customer_id IS NULL

-- 4.3
SELECT sh.showtime_id,m.title,sh.show_date 
FROM showtimes AS sh  
LEFT JOIN bookings AS b 
ON b.showtime_id=sh.showtime_id 
LEFT JOIN movies AS m 
ON m.movie_id=sh.movie_id 
WHERE b.showtime_id IS NULL

-- 4.4
SELECT COUNT(CASE WHEN c.email IS NOT NULL AND ps.email IS NOT NULL THEN 1 END) AS both,
COUNT(CASE WHEN ps.email IS NULL THEN 1 END) AS customer_only,
COUNT(CASE WHEN c.email IS NULL THEN 1 END) AS promo_signups 
FROM  customers AS c 
FULL  JOIN  promo_signups AS ps 
ON c.email=ps.email