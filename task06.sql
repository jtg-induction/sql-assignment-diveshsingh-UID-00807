-- 6.1
SELECT m.movie_id,SUM(b.seats_booked * sh.ticket_price) AS revenue
FROM showtimes AS  sh 
INNER JOIN bookings AS b 
ON sh.showtime_id=b.showtime_id 
INNER JOIN movies AS m 
ON m.movie_id=sh.movie_id 
GROUP BY m.movie_id  
ORDER BY revenue DESC 

-- 6.2
SELECT show_date,start_time,ticket_price 
FROM showtimes 
WHERE ticket_price > (
    SELECT AVG(ticket_price) 
    FROM showtimes
)

-- 6.3
SELECT full_name 
FROM customers 
WHERE customer_id IN (
    SELECT customer_id 
    FROM bookings
     WHERE showtime_id IN (
        SELECT showtime_id
         FROM showtimes 
         where movie_id IN (
            SELECT movie_id  
            FROM movies 
            WHERE movie_id IN (S
            ELECT movie_id  
            FROM showtimes 
            WHERE showtime_id IN(
                SELECT showtime_id 
                FROM bookings 
                WHERE status='confirmed'
                )
                ) 
                AND genre='Thriller'
                )
                )
                )

-- 6.4
WITH thriller_showtimes AS (
    SELECT customer_id 
    FROM bookings 
    WHERE showtime_id IN (
        SELECT showtime_id F
        ROM showtimes 
        WHERE movie_id IN (
            SELECT movie_id 
             FROM movies 
             WHERE movie_id IN (
                SELECT movie_id  
                FROM showtimes 
                WHERE showtime_id IN(
                    SELECT showtime_id 
                    FROM bookings 
                    WHERE status='confirmed')) 
                    AND genre='Thriller')))
SELECT full_name 
FROM customers 
WHERE customer_id IN (
    SELECT customer_id 
    FROM thriller_showtimes
)

-- 6.5
WITH movie_revenue AS (
SELECT m.movie_id,SUM(b.seats_booked * sh.ticket_price) AS revenue
FROM showtimes AS  sh INNER JOIN bookings AS b ON sh.showtime_id=b.showtime_id INNER JOIN 
movies AS m ON m.movie_id=sh.movie_id GROUP BY m.movie_id  ORDER BY revenue DESC 
),
stats AS (
    SELECT AVG(revenue) FROM movie_revenue
)
SELECT movie_id FROM movie_revenue WHERE revenue>(SELECT * from stats)
