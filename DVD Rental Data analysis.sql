SELECT CONCAT(first_name,' ',last_name),
	   film.title,
	   film.description,
	   film.length
FROM actor
INNER JOIN film_actor
ON actor.actor_id = film_actor.actor_id
INNER JOIN film
ON film.film_id = film_actor.film_id;

---Query 2
/*
Write a query that creates a list of actors and movies where the movie length was more than 60 minutes. How many rows are there in this query result? 
ans : 4900
*/

SELECT actor.first_name||' '||actor.last_name,film.title
FROM actor
INNER JOIN film_actor
ON actor.actor_id = film_actor.actor_id
INNER JOIN film
ON film.film_id = film_actor.film_id
WHERE film.length > 60

---Query 3

/*Write a query that captures the actor id, full name of the actor, and counts the number of movies each actor has made. (HINT: Think about whether you should group by actor id or the full name of the actor.) Identify the actor who has made the maximum number movies.
Gina Degeneres
*/

SELECT a.actor_id AS actor_id,
	   a.first_name||' '||a.last_name AS actor_name,
	   COUNT(*)
FROM actor AS a
INNER JOIN film_actor AS fc
ON a.actor_id = fc.actor_id
GROUP BY 1,2
ORDER BY count(*) DESC;

---Query 4:
/* Write a query that displays a table with 4 columns: actor's full name, film title, length of movie, and a column name "filmlen_groups" that classifies movies based on their length. Filmlen_groups should include 4 categories: 1 hour or less, Between 1-2 hours, Between 2-3 hours, More than 3 hours.
*/

SELECT a.first_name||' '||a.last_name AS full_name,
	   f.title,
	   f.length,
	   CASE 
	   WHEN f.length <= 60 THEN '1 Hour or less'
	   WHEN f.length > 60 AND f.length <= 120 THEN 'Between 1-2 Hours'
	   WHEN f.length > 120 AND f.length <= 180 THEN 'Between 2-3 hours'
	   WHEN f.length > 180 THEN 'More than 3 hours'
	   END AS filmlen_groups
FROM actor AS a
INNER JOIN film_actor AS fc
ON a.actor_id = fc.actor_id
INNER JOIN film AS f
ON fc.film_id = f.film_id;

---Query 4
/*Write a query you to create a count of movies in each of the 4 filmlen_groups: 1 hour or less, Between 1-2 hours, Between 2-3 hours, More than 3 hours.
*/
SELECT CASE 
	   WHEN f.length <= 60 THEN '1 Hour or less'
	   WHEN f.length > 60 AND f.length <= 120 THEN 'Between 1-2 Hours'
	   WHEN f.length > 120 AND f.length <= 180 THEN 'Between 2-3 hours'
	   WHEN f.length > 180 THEN 'More than 3 hours'
	   END AS filmlen_groups,
	   COUNT(f.title) AS CNT
FROM actor AS a
INNER JOIN film_actor AS fc
ON a.actor_id = fc.actor_id
INNER JOIN film AS f
ON fc.film_id = f.film_id
GROUP BY filmlen_groups
ORDER BY CNT;

SELECT *
FROM payment

SELECT *
FROM film

SELECT *
FROM film_category
SELECT *
FROM rental
SELECT *
FROM inventory

SELECT *
FROM category
---Query 5

/* What are the top/least rented(demanded) genres and what are what are their total sales? */

WITH CTE AS (SELECT c.name,
	   		 COUNT(r.rental_id) AS rental_count,
	         SUM(p.amount)
			 FROM category AS c
             INNER JOIN film_category AS fc
             ON c.category_id = fc.category_id
             INNER JOIN inventory AS i
             ON i.film_id = fc.film_id
             INNER JOIN rental AS r
             ON r.inventory_id = i.inventory_id
             INNER JOIN payment AS p
             ON p.rental_id = r.rental_id
             GROUP BY c.name
)
(SELECT *
FROM cte
ORDER BY rental_count DESC
LIMIT 1)
UNION
(SELECT *
FROM cte
ORDER BY rental_count asc
LIMIT 1)

---Query 6

/*Can we know how many distinct users have rented each genre?*/

SELECT c.name AS Genre_Name,COUNT(DISTINCT r.customer_id) AS cnt
FROM category AS c
INNER JOIN film_category AS fc
ON fc.category_id = c.category_id
INNER JOIN inventory AS i
ON(i.film_id = fc.film_id)
INNER JOIN rental AS r
ON r.inventory_id = i.inventory_id
GROUP BY Genre_Name
ORDER BY cnt desc;

---Query 7

/* What is the Average rental rate for each genre?*/

SELECT * 
FROM rental

SELECT *
FROM inventory
SELECT *
FROM film_category
SElECT *
FROM category
SELECT *
FROM payment

SELECT c.name AS genre ,AVG(p.amount) AS avg_rental
FROM category as c
INNER JOIN film_category AS fc
ON c.category_id = fc.category_id
INNER JOIN inventory AS i
ON fc.film_id = i.film_id
INNER JOIN rental AS r
ON r.inventory_id = i.inventory_id
INNER JOIN payment as p
ON p.rental_id = r.rental_id
GROUP BY genre
ORDER BY avg_rental desc;

---Query 8

/* How many rented films were returned early,ontime,late? */

SELECT *
FROM rental;
SELECT *
FROM payment;
SELECT *
FROM store;
SELECT *
FROM film;
SELECT *
FROM inventory;

WITH cte1 AS(
	SELECT DATE_PART('day',return_date-rental_date) AS date_diff,f.rental_duration,f.film_id
	FROM film AS f
	INNER JOIN inventory AS i
	ON f.film_id = i.film_id
	INNER JOIN rental AS r
	ON i.inventory_id  = r.inventory_id),
	cte2 AS(
	SELECT CASE
			WHEN date_diff > rental_duration THEN 'Late'
			WHEN date_diff < rental_duration THEN 'Early'
			ELSE 'On time'
			END AS category,film_id AS id
	FROM cte1)
SELECT category,count(id)
FROM cte2
GROUP BY category;

---Query 6

/*Question 5: In which countries does Rent A Film have a presence in and what is the customer base in each country? What are the total sales in each country? (From most to least)*/

SELECT country,
	   COUNT(DISTINCT customer_id) AS id,
	   SUM(amount) AS sales
FROM country
JOIN city 
USING (country_id)
JOIN address
USING (city_id)
JOIN customer
USING (address_id)
JOIN payment
USING (customer_id)
GROUP BY country
ORDER BY sales desc;

---Query 7
/*Who are the top 5 customers per total sales and can we get their detail just in case Rent A Film want to reward them?*/

SELECT c.customer_id,
	   c.first_name||' '||c.last_name AS full_name,
       SUM(amount) AS total_sales
FROM customer AS c
JOIN payment AS p
USING (customer_id)
GROUP BY c.customer_id
ORDER BY total_sales desc
LIMIT 5;

