TASK 3
Because sales_prices does not exist in table which where coomand fails and whole query fail

TASK 5
Because HAVING is used with AGGREGATE functions.


TASK 6
 use of cte when need that same query more than one time

TASK 7
 CHECK
psql:task07.sql:31: ERROR:  new row for relation "bookings" violates check constraint "chk_seat"
DETAIL:  Failing row contains (39, 1, 1, 0, 2026-09-05 01:25:52.028295, confirmed).

UNIQUE
psql:task07.sql:32: ERROR:  duplicate key value violates unique constraint "unq"
DETAIL:  Key (screen_id, show_date, start_time)=(1, 2026-08-10, 19:00:00) already exists.

CHECK
psql:task07.sql:32: ERROR:  new row for relation "movies" violates check constraint "chk_srating"
DETAIL:  Failing row contains (17, The Last Ledger, Drama, NC-99, 124, 2024).

TASK 8
3NF will eliminate the spelling bug while creating customer_id other than full_name,email

TASK 9
if we write group by movie_id but would not run which require group by show_time,start_time which is wrong logically so we use partiton by


TASK 10
atomicity 
  10.1 define the atomicity which either whole transaction commit or nothing will commit(rollback)

consistency
  in task7.1,7.2,7.3,7.4 apply constraint to maintain the consistency

isolation
 isolation protect because a lot of user interact with db so nonone interfare each other while booking

durability
 the data is premantly change in db in case of power cut or server issuse we just re query the log to get updated db
