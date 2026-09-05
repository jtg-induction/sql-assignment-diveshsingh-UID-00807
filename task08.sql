-- 8.1
-- 1NF: seats because it consider a set of seats which can solve by making different table of seats and legacy_id

-- 2NF: there is no partially dependency.

-- 3NF: movie_title because of movie_title->ticket_price

-- 8.2
SELECT DISTINCT(customer_email) 
FROM legacy_bookings 
WHERE customer_email NOT IN (
    SELECT email 
    FROM customers
)

-- 8.3
INSERT INTO customers (full_name, email)
SELECT DISTINCT customer_name, customer_email
FROM legacy_bookings AS lb
WHERE  NOT EXISTS (
      SELECT email FROM customers AS c WHERE lb.customer_email=c.email 
  );

-- 8.4
INSERT INTO movies (title, genre)
SELECT DISTINCT 
    movie_title, 
    movie_genre
FROM legacy_bookings lb
WHERE NOT EXISTS (
      SELECT title
      FROM movies m 
      WHERE m.title = lb.movie_title
  );

-- 8.5
SELECT count(*) 
FROM (
    SELECT unnest(String_to_array(seats,',')) 
    FROM legacy_bookings
)
