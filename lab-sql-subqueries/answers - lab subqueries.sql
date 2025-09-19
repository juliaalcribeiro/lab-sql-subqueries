USE sakila;

#1 Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.

SELECT COUNT(i.film_id)
FROM inventory AS i
JOIN film AS f
ON i.film_id = f.film_id
WHERE f.title LIKE "Hunchback Impossible";

#Checking
SELECT i.film_id, f.title
FROM inventory AS i
JOIN film AS f
ON i.film_id = f.film_id
WHERE f.title LIKE "Hunchback Impossible";


#2 List all films whose length is longer than the average length of all the films in the Sakila database.

SELECT *
FROM film
WHERE length > (
	SELECT AVG(length) 
    FROM film
    );

#3 Use a subquery to display all actors who appear in the film "Alone Trip".

SELECT a.actor_id, a.first_name, a.last_name
FROM actor AS a
JOIN film_actor AS fa 
    ON a.actor_id = fa.actor_id
WHERE fa.film_id = (
    SELECT film_id
    FROM film
    WHERE title = 'Alone Trip'
);

#4 Sales have been lagging among young families, and you want to target family movies for a promotion. 
# Identify all movies categorized as family films.

SELECT f.title, c.name AS category
FROM film AS f
JOIN film_category AS fc
ON f.film_id = fc.film_id
JOIN category AS c
ON c.category_id = fc.category_id
WHERE c.name LIKE 'Family';

#5 Retrieve the name and email of customers from Canada using both subqueries and joins. 
# To use joins, you will need to identify the relevant tables and their primary and foreign keys.

#Using only joins 
SELECT c.first_name, c.last_name, c.email, co.country
FROM customer AS c
JOIN address AS a
ON c.address_id = a.address_id
JOIN city AS ci
ON ci.city_id = a.city_id
JOIN country AS co
ON ci.country_id = co.country_id
WHERE co.country LIKE 'Canada';

#Using joins and a subquery
SELECT c.first_name, c.last_name, c.email, country_info.country
FROM customer AS c
JOIN (
    SELECT a.address_id, co.country
    FROM address AS a
    JOIN city AS ci ON ci.city_id = a.city_id
    JOIN country AS co ON ci.country_id = co.country_id
    WHERE co.country LIKE 'Canada'
) AS country_info
ON c.address_id = country_info.address_id;


#6 Determine which films were starred by the most prolific actor in the Sakila database. 
# A prolific actor is defined as the actor who has acted in the most number of films. 
# First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.

SELECT f.film_id, f.title, fa.actor_id
FROM film AS f
JOIN film_actor AS fa
ON f.film_id = fa.film_id
WHERE fa.actor_id = (
    SELECT actor_id
	FROM film_actor
	GROUP BY actor_id
	ORDER BY COUNT(actor_id) DESC
	LIMIT 1
);

#7 Find the films rented by the most profitable customer in the Sakila database. 
# You can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.

SELECT f.film_id, f.title, r.customer_id
FROM film AS f
JOIN inventory AS i
ON i.film_id = f.film_id
JOIN rental AS r
ON i.inventory_id = r.inventory_id
JOIN payment AS p
ON p.customer_id = r.customer_id 
WHERE r.customer_id = (
	SELECT customer_id
	FROM payment
	GROUP BY customer_id
	ORDER BY SUM(amount)
	LIMIT 1
);

#8 Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. 
# You can use subqueries to accomplish this.

SELECT customer_id, SUM(amount) AS total_amount_spent
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > (
    SELECT AVG(total_amount_spent)
    FROM (
        SELECT SUM(amount) AS total_amount_spent
        FROM payment
        GROUP BY customer_id
    ) AS customer_totals
);