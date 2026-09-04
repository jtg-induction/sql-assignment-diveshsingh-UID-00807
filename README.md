# 🎬 Starlight Cinemas — A PostgreSQL Story Assignment

> *"The projector still works. The database is a shoebox. Fix the second thing."*
> — Nadia Rahman, Owner

---

## The Story

**Starlight Cinemas** opened in 1962 as the only movie theatre in the small town of Marlowe Creek. For sixty years it had one screen, one projectionist (Frank, who never took a sick day), and one "database": Frank's spreadsheet, lovingly maintained, structurally horrifying.

Last year, Nadia Rahman bought the place and renovated it into a three-screen indie cinema — **The Grand** (120 seats), **The Loft** (60), and **The Vault** (40, in the old bank vault next door). Reopening week is **August 10–16, 2026**, presales are already coming in, an investor wants weekly numbers, and an over-eager summer intern has been "helping" with data entry.

You have been hired as **Database Engineer #1**. Your job, over ten tasks, is to take Starlight from paper to a production-grade PostgreSQL database — designing the schema, loading and repairing data, answering business questions, hardening the system against the intern, rescuing Frank's legacy ledger, and making booking bulletproof for premiere night.

Each task **builds directly on the previous one**. Do them in order.

---

## What You Will Practice

| Task | Story Beat | SQL Topics (from the *Basics of SQL* deck) |
|------|-----------|--------------------------------------------|
| 1 | Build the schema | **DDL** — `CREATE TABLE`, PK, FK, `NOT NULL`, `DEFAULT` |
| 2 | Opening-week chaos | **DML** — `INSERT`, `UPDATE`, `DELETE` |
| 3 | Nadia's first questions | **DQL** — `SELECT`, `WHERE`, `ORDER BY`, `LIMIT`, logical execution order |
| 4 | Connecting the dots | **Joins** — `INNER`, `LEFT`, `FULL OUTER` |
| 5 | The investor report, part 1 | **Aggregation** — `GROUP BY`, `HAVING`, `SUM`, `AVG`, `COUNT` |
| 6 | Cleaner questions | **Subqueries vs. CTEs** |
| 7 | Intern-proofing | **Constraints** — `CHECK`, `UNIQUE`, `ALTER TABLE` |
| 8 | Frank's shoebox ledger | **Normalization** — 1NF / 2NF / 3NF, data migration |
| 9 | The investor report, part 2 | **Window functions** — `RANK() OVER`, `PARTITION BY`, running totals |
| 10 | Premiere night | **Transactions** — `BEGIN`, `COMMIT`, `ROLLBACK`, ACID |
| ★ Bonus | Hiring help & tuning | **DCL** (`GRANT`/`REVOKE`), best practices, indexes, `EXPLAIN` |

---

## Files in This Assignment

| File | What it is |
|------|-----------|
| `README.md` | This document — story, tasks, checkpoints. |
| `01_boilerplate.sql` | Run **first**. Creates the given tables (`customers`, `promo_signups`, `legacy_bookings`), loads their data, and contains the commented **blueprints** for the tables *you* must build in Task 1. |
| `02_seed_data.sql` | Run **only after Task 1**. Loads opening-week movies, screens, showtimes, and presale bookings into the tables you created. |

### What You Submit

Create one file per task — `task01.sql`, `task02.sql`, … `task10.sql` (and `task11.sql` if you attempt the bonus) — containing your statements **in order, commented with the sub-task number** (e.g. `-- 3.2`). Written answers (asked in Tasks 3, 7, 8, 10) go in a single `ANSWERS.md`.

---

## Setup (Task 0)

1. Install PostgreSQL 14+ and open `psql`.
2. Create and connect to the database:
   ```sql
   CREATE DATABASE starlight;
   \c starlight
   ```
3. Load the boilerplate:
   ```sql
   01_boilerplate.sql
   ```
4. **Checkpoint 0:** `\dt` shows exactly 3 tables, and:
   ```sql
   SELECT COUNT(*) FROM customers;        -- 12
   SELECT COUNT(*) FROM promo_signups;    --  8
   SELECT COUNT(*) FROM legacy_bookings;  -- 12
   ```

---

## Ground Rules

These come straight from the **SQL Best Practices** slide, and you follow them from day one:

1. **No `SELECT *`** in any graded query — always list your columns explicitly.
2. **UPPER-CASE keywords**, lower-case identifiers, indent multi-line queries.
3. Use **meaningful aliases** (`c` for customers, `m` for movies, `b` for bookings, `st` for showtimes, `s` for screens).
4. Do **not** modify the three given tables (`customers` schema, `promo_signups`, `legacy_bookings` structure) unless a task explicitly says so.
5. If you wreck your database, drop it and replay: boilerplate → your `task01.sql` → seed → `task02.sql` → … That replayability is *the whole point* of keeping your work in scripts.

---

## The Target Schema

```
customers ──────┐                       ┌────── movies
  customer_id   │                       │        movie_id
  full_name     │                       │        title
  email (UQ)    │       bookings        │        genre
  loyalty_points├──<  booking_id        │        rating
  joined_on     │     customer_id (FK)  │        duration_minutes
                │     showtime_id (FK) >├──┐     release_year
promo_signups   │     seats_booked      │  │
  signup_id     │     booked_at         │  │    screens
  full_name     │     status            │  │     screen_id
  email (UQ)    │                       │  │     screen_name (UQ)
  signed_up_on  │      showtimes  <─────┘  │     capacity
                │       showtime_id        │
legacy_bookings │       movie_id (FK) ─────┘
  (the shoebox — quarantined, migrated in Task 8)
  ledger_id ...        screen_id (FK) ──> screens
                       show_date · start_time · ticket_price
```

---

## Task 1 — Blueprints Into Buildings *(DDL)*

> Nadia hands you a napkin with four table sketches. "The last contractor finished `customers` and vanished. Make the rest real. And make them *strict* — I've met the intern."

Open `01_boilerplate.sql`, **Section 3**. In `task01.sql`:

1. **1.1** Finish the `movies` blueprint: `title` must never be `NULL`, and `duration_minutes`, when present, must be greater than 0 (a `CHECK`). Leave `rating`, `genre`, `release_year` nullable — Frank's ledger is missing them, and you'll thank yourself in Task 8.
2. **1.2** Create `screens` exactly per the blueprint (auto-increment PK, required unique name, capacity > 0).
3. **1.3** Create `showtimes` per the blueprint — both foreign keys are required.
4. **1.4** Create `bookings` per the blueprint — both foreign keys required, `booked_at` defaults to `NOW()`, `status` defaults to `'confirmed'`.
5. **1.5** Now load the business data:
   ```sql
   02_seed_data.sql
   ```

⚠️ Use the **exact** table and column names from the blueprints, and resist adding extra constraints — Task 7 depends on some gaps existing. (Study the given `customers` table: it's your reference for good DDL.)

**Checkpoint 1:** `movies` 10 · `screens` 3 · `showtimes` 18 · `bookings` 32.

---

## Task 2 — Opening-Week Chaos *(DML)*

> Monday morning. A local director drops off a documentary and begs for a slot. The intern typo'd a kids' movie, double-entered a showtime, and Friday-night demand is exploding. Also: book yourself a ticket — you work at a cinema now.

In `task02.sql`:

1. **2.1** `INSERT` a new movie: *The Marlowe Reel* — Documentary, PG, 88 min, 2026. *(Do not specify `movie_id` — let `SERIAL` do its job.)*
2. **2.2** `INSERT` yourself as a customer (your name, an email, any phone).
3. **2.3** `INSERT` one showtime for *The Marlowe Reel* — **The Vault**, `2026-08-16` at `18:00`, price `8.00` — then `INSERT` a booking for yourself at that showtime. *(Hint: your new movie is `movie_id` 11, your new showtime 19, and you are `customer_id` 13 — or find the IDs with a subquery if you want style points.)*
4. **2.4** `UPDATE`: fix the typo — *The Comet Kidz* → *The Comet Kids*.
5. **2.5** `UPDATE`: Friday surge pricing — every showtime on `2026-08-14` starting at or after `18:00` goes up by `2.00`. **Exactly 2 rows** should change.
6. **2.6** `UPDATE`: Elena Petrova complained politely about the popcorn machine; add 25 loyalty points *(target her by email, not by ID)*.
7. **2.7** `DELETE`: the intern entered the late *Hollow Peak* showtime on `2026-08-16` **twice**. Find the duplicate pair (same movie, screen, date, and time), then delete **only the higher-ID copy**. *(In Task 7 you'll make this bug impossible.)*

**Checkpoint 2:**
```sql
SELECT ticket_price FROM showtimes WHERE show_date = '2026-08-14';  -- 12.50 and 16.00
SELECT COUNT(*) FROM showtimes;                                      -- 18 (added 1, deleted 1)
SELECT title FROM movies WHERE movie_id = 5;                         -- The Comet Kids
```

---

## Task 3 — Nadia's First Questions *(DQL: filtering & sorting)*

> "I don't want dashboards," Nadia says. "I want answers. Tonight."

One `SELECT` per question in `task03.sql`:

1. **3.1** Title, rating, and duration of every **R-rated** movie.
2. **3.2** Title and duration of movies shorter than **100 minutes**, shortest first. *(Expect 4 rows.)*
3. **3.3** The **5 most expensive showtimes**: date, start time, price — priciest first.
4. **3.4** Full name and points of customers who joined **in 2026** *and* have **at least 50 loyalty points**. *(Expect 4 rows.)*
5. **3.5** Movies whose title contains the word `the`, case-insensitive.
6. **3.6** Booking ID, customer ID, and seats of every **cancelled** booking.

📝 **In `ANSWERS.md`:** the deck says the logical execution order is `FROM → WHERE → SELECT`. Use that fact to explain, in 2–3 sentences, why `SELECT ticket_price * 0.9 AS sale_price ... WHERE sale_price < 10` fails in Postgres.

---

## Task 4 — Connecting the Dots *(Joins)*

> The data lives in five tables now. Nadia's questions live across all of them.

In `task04.sql`:

1. **4.1** **Receipts** *(INNER JOINs across 4 tables)*: for every booking — customer name, movie title, show date, start time, seats, status. Order by `booked_at`.
2. **4.2** **The no-shows** *(LEFT JOIN)*: customers who have **never booked anything**. *(Expect exactly 2 — the deck's "Left set + overlap" picture: you want the left rows with no overlap.)*
3. **4.3** **The empty room** *(LEFT JOIN, other direction)*: any showtime with **zero bookings** — showtime ID, movie title, date. *(Expect exactly 1.)*
4. **4.4** **The kiosk list** *(FULL OUTER JOIN)*: reconcile `customers` and `promo_signups` on `email`. Output one row per person with a `segment` column via `CASE`: `'both'`, `'customer only'`, or `'promo only'`. Then count each segment.

**Checkpoint 4:** segments are **both = 4**, **customer only = 9**, **promo only = 4**. One promo-only name should look familiar if you've peeked at Frank's ledger…

---

## Task 5 — The Investor Report, Part 1 *(Aggregation & Grouping)*

> The investor's email is one line: "Numbers by Friday." Cancelled bookings do **not** count as revenue — filter them out everywhere below.

In `task05.sql` (revenue = `seats_booked * ticket_price`):

1. **5.1** **Total revenue per movie**, highest first.
2. **5.2** **Total seats sold per genre**, most first.
3. **5.3** **Average ticket price per screen** (screen name + rounded average; include all showtimes, booked or not).
4. **5.4** Genres with **more than 10 seats sold** — `GROUP BY` + `HAVING`. *(Expect 3 genres.)*
5. **5.5** **Occupancy report**: per showtime — showtime ID, movie title, screen name, capacity, confirmed seats sold, and percent full, fullest first. *(Careful: a showtime with no bookings should still appear, at 0.)*

**Checkpoint 5:** *The Last Ledger* leads with **162.50**; the top genres by seats are **Family 21, Drama 17, Thriller 14**. *(Your own Task 2 booking appears near the bottom of 5.1 — that's expected.)*

📝 **In `ANSWERS.md`:** one sentence — why must the "cancelled" filter live in `WHERE` here rather than `HAVING`?

---

## Task 6 — Cleaner Questions *(Subqueries vs. CTEs)*

> Your queries work, but Nadia squints at the nesting. "Frank could read his spreadsheet. I want to be able to read this."

In `task06.sql`:

1. **6.1** *(scalar subquery)* Showtimes priced **above the average ticket price** — date, time, price. *(Expect 7 rows; the average is about 11.06.)*
2. **6.2** *(subquery with `IN`)* Names of customers who have a confirmed booking for any **Thriller**.
3. **6.3** Rewrite 6.2 as a **CTE** (`WITH thriller_showtimes AS (...)`). Same result, more readable.
4. **6.4** *(multi-step CTE — the deck's "modular, documented steps")* Chain two CTEs: `movie_revenue` (confirmed revenue per movie) → `stats` (the average of those revenues) → final query listing movies **above average revenue**.

📝 Add a one-line comment above 6.4: when would you reach for a CTE over a nested subquery?

---

## Task 7 — Intern-Proofing *(Constraints & `ALTER TABLE`)*

> Monday's incident report: the intern sold **0 seats** to someone, priced a matinee at **−4.00**, and nearly double-booked The Grand *again*. "Garbage in" stops today.

In `task07.sql`, add five constraints with `ALTER TABLE ... ADD CONSTRAINT` (name every constraint):

1. **7.1** `bookings.seats_booked` must be between **1 and 10**.
2. **7.2** `bookings.status` must be `'confirmed'` or `'cancelled'`.
3. **7.3** `showtimes.ticket_price` must be **greater than 0**.
4. **7.4** A screen can host only **one showtime per date + start time**: `UNIQUE (screen_id, show_date, start_time)`. *(This is why Task 2.7 mattered — try to explain what would have happened if the duplicate were still there.)*
5. **7.5** `movies.rating` must be one of `'G'`, `'PG'`, `'PG-13'`, `'R'` *(note: `NULL` still passes a `CHECK` — that's deliberate; Frank's films have no rating yet)*.
6. **7.6** **Prove it works**: write three intentionally failing statements — a 0-seat booking, a duplicate screen/date/time showtime, a movie rated `'NC-99'` — run them, and paste each error message into `ANSWERS.md`.

📝 **In `ANSWERS.md`:** map each incident from the story to the constraint that now prevents it, and state which constraint type from the deck (PK / FK / NOT NULL / UNIQUE / CHECK) each one is.

---

## Task 8 — Frank's Shoebox Ledger *(Normalization & Migration)*

> Frank retires Friday. He hands you the spreadsheet — `legacy_bookings` — like it's a family heirloom. It contains customers and even a *movie* your shiny new tables have never heard of. Study its sins, then rescue its data. **Do not alter or delete `legacy_bookings` itself** — it's a museum piece.

In `task08.sql` / `ANSWERS.md`:

1. **8.1** 📝 Using the deck's table (1NF = atomicity, 2NF = partial dependency, 3NF = transitive dependency), identify **one concrete violation of each** in `legacy_bookings`, naming the offending column(s). *(Hint for 1NF: look at `seats`. Hint for 3NF: what does `movie_genre` actually depend on?)*
2. **8.2** *(subquery reuse!)* `SELECT` the **distinct emails** in the ledger that do **not** exist in `customers` — use `NOT EXISTS` or `NOT IN`. *(Expect 3.)*
3. **8.3** Migrate them: `INSERT INTO customers (full_name, email) SELECT DISTINCT ...` using that same `NOT EXISTS` filter. **Run it twice** — the second run must insert 0 rows. Why is that property (idempotence) worth having?
4. **8.4** Same trick for films: insert ledger movies missing from `movies` (title + genre only). *(Expect 1: a certain lost drama. Its rating and duration will be `NULL` — which your Task 1 and Task 7 decisions deliberately allow.)*
5. **8.5** *(bonus, Postgres-flavored)* How many **individual seats** did the old cinema sell in the ledger? Split the comma lists with `string_to_array` + `unnest`. *(Expect 24.)*

📝 **In `ANSWERS.md`:** row 7 of the ledger says *"Ava Thomson"* while every other row says *"Ava Thompson"*. In one paragraph: which normalization principle makes this class of bug **structurally impossible** in your new schema, and why?

**Checkpoint 8:** `SELECT COUNT(*) FROM customers;` → **16**.

---

## Task 9 — The Investor Report, Part 2 *(Window Functions)*

> The investor liked the totals. Now she wants *rankings* and *trends* — "and don't collapse the rows, I want the detail *and* the context." That sentence is basically the definition of a window function.

In `task09.sql` (confirmed bookings only; CTEs from Task 6 will serve you well):

1. **9.1** **Overall leaderboard**: every movie with its total revenue and `RANK() OVER (ORDER BY revenue DESC)`.
2. **9.2** **Genre leaderboards**: same, but ranked **within genre** — `PARTITION BY genre`. *(Sanity check: The Last Ledger, Robo-Rascals 2, and Hollow Peak should each be #1 somewhere.)*
3. **9.3** **Momentum**: revenue per `show_date` plus a **running total** across the week — `SUM(...) OVER (ORDER BY show_date)`. *(The final running total lands at **823.50**, before your Task 2 self-booking is counted — with it, slightly higher.)*
4. **9.4** *(the deck's own example, on real data)* For every showtime: date, price, the **average price for that movie** via `AVG(ticket_price) OVER (PARTITION BY movie_id)`, and the difference from that average.

📝 One sentence in `ANSWERS.md`: why couldn't 9.4 be done with plain `GROUP BY` in a single query?

---

## Task 10 — Premiere Night *(Transactions & ACID)*

> Saturday. *Quantum Alley* premiere. If a booking half-succeeds — seats reserved but loyalty points lost, or worse — you'll hear about it forever. Money and seats move together or not at all.

In `task10.sql`:

1. **10.1** **The atomic booking**: in one transaction (`BEGIN; ... COMMIT;`) — insert a booking (Elena Petrova, showtime 13, 2 seats) **and** add `10` loyalty points to her account. Verify both effects landed.
2. **10.2** **The disaster drill**: `BEGIN;` → `DELETE FROM bookings;` (yes, all of them) → `SELECT COUNT(*)` (behold: 0) → `ROLLBACK;` → count again. Everything is back. Note the before/after counts.
3. **10.3** *(optional)* Repeat 10.1 with a `SAVEPOINT` after the `INSERT`; make the `UPDATE` deliberately fail (e.g., set `status = 'oops'` on the new booking — Task 7 will object), `ROLLBACK TO` the savepoint, then `COMMIT` just the booking.
4. **10.4** 📝 **In `ANSWERS.md`:** map this task to **ACID**, one sentence per letter: which step demonstrated **A**tomicity? Where did your Task 7 constraints enforce **C**onsistency? What would **I**solation protect against on a busy premiere night? What does **D**urability promise after `COMMIT`?

---

## ★ Bonus Task 11 — Hiring Help & Tuning *(DCL + Best Practices)*

> A new box-office hire starts Monday. They should *see* the schedule, never touch the money. And the investor asked why queries are fast — time to show your work.

In `task11.sql`:

1. **11.1** *(DCL — the deck's `GRANT` / `REVOKE`)* Create role `box_office_intern` (with `LOGIN`), `GRANT SELECT` on `movies`, `screens`, and `showtimes` — nothing on `customers` or `bookings`. Then, after a "policy change," `REVOKE` their access to `showtimes`.
2. **11.2** **Refactor** this abomination the intern left behind, applying every rule on the Best Practices slide (explicit `JOIN ... ON`, uppercase keywords, aliases, named columns):
   ```sql
   select * from bookings, customers, showtimes, movies where bookings.customer_id=customers.customer_id and bookings.showtime_id=showtimes.showtime_id and showtimes.movie_id=movies.movie_id and status='confirmed';
   ```
3. **11.3** Create an index on `bookings (showtime_id)` and run `EXPLAIN` on a query filtering by `showtime_id` **before and after**. You will likely still see `Seq Scan` — in `ANSWERS.md`, explain why the optimizer (deck: *"calculates the cheapest execution plan"*) ignores your beautiful index on a 30-row table, and when it would change its mind.

---

*Frank left a note taped to the projector: "Take care of the data, kid. I took care of it for forty years with a pencil. You have no excuse."*

**Happy querying! 🍿**
