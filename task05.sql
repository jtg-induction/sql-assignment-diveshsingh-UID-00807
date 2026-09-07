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

5.3
SELECT s.screen_name,ROUND(AVG(sh.ticket_price),2) AS average_ticket_price
FROM screens AS  s 
INNER JOIN showtimes AS sh 
ON sh.screen_id=s.screen_id 
GROUP BY s.screen_name

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


5.5
SELECT sh.showtime_id,m.title,s.screen_name,s.capacity,COALESCE(sum(b.seats_booked),0) AS confirmed_seats_sold, ROUND((COALESCE(sum(b.seats_booked),0)*100.0/s.capacity),2) AS percent_full
FROM showtimes AS  sh 
LEFT JOIN bookings AS b 
ON sh.showtime_id=b.showtime_id  AND b.status='confirmed'
INNER JOIN movies AS m 
ON m.movie_id=sh.movie_id 
INNER JOIN screens AS s 
ON sh.screen_id=s.screen_id 
GROUP BY sh.showtime_id,m.title,s.screen_name,s.capacity
ORDER BY percent_full DESC