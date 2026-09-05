-- 1.1
CREATE TABLE movies ( 
  movie_id          SERIAL PRIMARY KEY,
   title             TEXT    NOT NULL,
    genre             TEXT,         
    rating            TEXT,          
    duration_minutes  INT     check(duration_minutes>0) ,
    release_year      TEXT           
);

-- 1.2
CREATE TABLE screens( 
   screen_id  SERIAL PRIMARY KEY,
   screen_name TEXT NOT NULL UNIQUE CHECK (screen_name IN ('The Grand', 'The Loft', 'The Vault')),
    capacity  INT NOT NULL check(capacity>0)      
);


-- 1.3
CREATE TABLE showtimes( 
    showtime_id   SERIAL PRIMARY KEY,
    movie_id INT NOT NULL REFERENCES  movies(movie_id),
     screen_id INT NOT NULL REFERENCES  screens(screen_id),   
     show_date DATE NOT NULL,
     start_time TIME NOT NULL,
      ticket_price NUMERIC(6,2) NOT NULL  
);

-- 1.4
CREATE TABLE  bookings( 
     booking_id  SERIAL PRIMARY KEY,
     customer_id INT NOT NULL REFERENCES   customers(customer_id),
      showtime_id  INT NOT NULL REFERENCES  showtimes(showtime_id),   
      seats_booked  INT NOT NULL,
      booked_at   TIMESTAMP NOT NULL   DEFAULT NOW(),
       status    TEXT  NOT NULL   DEFAULT 'confirmed' 
);



