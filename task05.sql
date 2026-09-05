-- 5.1
SELECT m.movie_id,SUM(b.seats_booked * sh.ticket_price) AS revenue
FROM showtimes AS  sh 
INNER JOIN bookings AS b 
ON sh.showtime_id=b.showtime_id 
INNER JOIN movies AS m 
ON m.movie_id=sh.movie_id 
GROUP BY m.movie_id  
ORDER BY revenue DESC 

-- 5.2
SELECT m.genre,SUM(b.seats_booked) AS booked
FROM showtimes AS  sh 
INNER JOIN bookings AS b 
ON sh.showtime_id=b.showtime_id 
INNER JOIN movies AS m 
ON m.movie_id=sh.movie_id 
WHERE b.status='confirmed' 
GROUP BY m.genre 
ORDER BY booked DESC

-- 5.3
SELECT sh.screen_id,ROUND(AVG(sh.ticket_price))
FROM screens AS  s 
INNER JOIN showtimes AS sh 
ON sh.screen_id=s.screen_id 
GROUP BY sh.screen_id

-- 5.4
SELECT m.genre,SUM(b.seats_booked) AS booked
FROM showtimes AS  sh 
INNER JOIN bookings AS b 
ON sh.showtime_id=b.showtime_id 
INNER JOIN movies AS m 
ON m.movie_id=sh.movie_id 
WHERE b.status='confirmed'
GROUP BY m.genre 
HAVING SUM(b.seats_booked) >10


-- 5.5
SELECT sh.showtime_id,m.title,s.screen_name,s.capacity,SUM(b.seats_booked) AS confirmed_seats_sold, (SUM(b.seats_booked)*100/s.capacity) AS percent_full
FROM showtimes AS  sh 
LEFT JOIN bookings AS b 
ON sh.showtime_id=b.showtime_id 
INNER JOIN movies AS m 
ON m.movie_id=sh.movie_id 
INNER JOIN screens AS s 
ON sh.screen_id=s.screen_id 
WHERE b.status='confirmed' 
GROUP BY sh.showtime_id,m.title,s.screen_name,s.capacity
