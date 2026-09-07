-- 9.1
SELECT m.movie_id,SUM(b.seats_booked * sh.ticket_price) AS revenue,RANK() OVER (ORDER BY SUM(b.seats_booked * sh.ticket_price) DESC)
FROM showtimes AS  sh 
INNER JOIN bookings AS b 
ON sh.showtime_id=b.showtime_id  AND b.status='confirmed'
INNER JOIN movies AS m 
ON m.movie_id=sh.movie_id 
GROUP BY m.movie_id  
ORDER BY revenue DESC 

-- 9.2
SELECT m.title,SUM(b.seats_booked * sh.ticket_price) AS revenue,RANK() OVER (PARTITION BY m.genre ORDER BY SUM(b.seats_booked * sh.ticket_price) DESC)
FROM showtimes AS  sh 
INNER JOIN bookings AS b 
ON sh.showtime_id=b.showtime_id AND b.status='confirmed'
INNER JOIN movies AS m 
ON m.movie_id=sh.movie_id 
GROUP BY m.title,m.genre 
ORDER BY revenue DESC 


-- 9.3
SELECT sh.show_date,SUM(b.seats_booked * sh.ticket_price) AS revenue,SUM(SUM(b.seats_booked * sh.ticket_price)) OVER (ORDER BY sh.show_date )
FROM showtimes AS  sh 
INNER JOIN bookings AS b 
ON sh.showtime_id=b.showtime_id 
WHERE b.status='confirmed'
GROUP BY sh.show_date  
ORDER BY revenue DESC 


-- 9.4
SELECT sh.show_date,sh.ticket_price, AVG(sh.ticket_price) OVER (PARTITION BY m.movie_id),sh.ticket_price-AVG(ticket_price) OVER (PARTITION BY m.movie_id) AS dff 
FROM showtimes as sh 
INNER JOIN movies AS m 
ON sh.movie_id=m.movie_id

