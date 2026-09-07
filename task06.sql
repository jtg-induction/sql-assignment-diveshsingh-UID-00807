-- 6.1
SELECT show_date,start_time,ticket_price 
FROM showtimes 
WHERE ticket_price > (
    SELECT AVG(ticket_price) 
    FROM showtimes
)

-- 6.2

SELECT full_name FROM customers
 WHERE customer_id IN(
    SELECT b.customer_id FROM bookings AS b 
    INNER JOIN showtimes AS sh ON b.showtime_id=sh.showtime_id 
    INNER JOIN movies AS m ON sh.movie_id=m.movie_id AND m.genre='Thriller'
);


-- 6.3

WITH thriller_showtimes AS (
     SELECT b.customer_id FROM bookings AS b 
    INNER JOIN showtimes AS sh ON b.showtime_id=sh.showtime_id 
    INNER JOIN movies AS m ON sh.movie_id=m.movie_id AND m.genre='Thriller'
)
SELECT full_name 
FROM customers 
WHERE customer_id IN (
    SELECT customer_id
    FROM thriller_showtimes
)

-- 6.4

WITH movie_revenue AS (
SELECT m.movie_id,SUM(b.seats_booked * sh.ticket_price) AS revenue
FROM showtimes AS  sh INNER JOIN bookings AS b ON sh.showtime_id=b.showtime_id AND b.status='confirmed' INNER JOIN 
movies AS m ON m.movie_id=sh.movie_id GROUP BY m.movie_id  ORDER BY revenue DESC 
),
stats AS (
    SELECT AVG(revenue) FROM movie_revenue
)
SELECT movie_id FROM movie_revenue WHERE revenue>(SELECT * from stats)



