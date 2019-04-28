-- 1a. Display the first and last names of all actors from the table actor
select first_name, last_name from sakila.actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
select concat(upper(first_name),' ',upper(last_name)) as 'Actor Name' from sakila.actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
select actor_id, first_name, last_name from sakila.actor where first_name = 'Joe';

-- 2b. Find all actors whose last name contain the letters GEN:
select * from sakila.actor where last_name like '%GEN%';

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
select * from sakila.actor where last_name like '%LI%' order by last_name, first_name asc;

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
select country_id,country  from sakila.country where country in ('Afghanistan', 'Bangladesh', 'China');

-- 3a
alter table sakila.actor add description blob;

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
alter table sakila.actor drop description;

-- 4a. List the last names of actors, as well as how many actors have that last name.
select last_name, count(*) as count from sakila.actor group by last_name;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
select last_name, count(*) as count from sakila.actor group by last_name having count > 1;

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
update sakila.actor set first_name = 'HARPO' where first_name = 'GROUCHO' and last_name = 'Williams';

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
update sakila.actor set first_name = 'GROUCHO' where first_name = 'HARPO' and last_name = 'Williams';

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
show create table address;

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
select first_name, last_name, address, address2, postal_code from sakila.staff join sakila.address on (staff.address_id = address.address_id);
	
-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
select concat(upper(first_name),' ',upper(last_name)) as staff_member, sum(amount) as total_amount from sakila.staff left join sakila.payment on (staff.staff_id = payment.staff_id) where month(payment_date) = 8 and year(payment_date) = '2005'  group by concat(upper(first_name),' ',upper(last_name));

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
select film.title, count(distinct(actor_id)) as number_of_actors from sakila.film join sakila.film_actor on (film.film_id = film_actor.film_id) group by film.title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
select count(inventory_id) as copies_of_Hunchback_Impossible from sakila.film join sakila.inventory on (sakila.film.film_id = sakila.inventory.film_id) where title = 'HUNCHBACK IMPOSSIBLE';


-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
select sakila.customer.last_name, sakila.customer.first_name, sum(amount) as amount from sakila.customer join sakila.payment on (sakila.customer.customer_id = sakila.payment.customer_id) group by sakila.customer.last_name, sakila.customer.first_name order by last_name asc;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
select * from sakila.film where title in (select title from sakila.film where left(title,1) in ('K','R'));

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
select concat(upper(first_name),' ',upper(last_name)) as actors from sakila.film_actor join sakila.actor on (sakila.film_actor.actor_id = sakila.actor.actor_id) where film_id in (select film_id from sakila.film where title = 'Alone Trip');

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
select concat(upper(first_name),' ',upper(last_name)) as customer_name, email from sakila.customer join sakila.address on (customer.address_id = address.address_id) join sakila.city on (address.city_id = city.city_id) join sakila.country on (city.country_id = country.country_id) where country = 'canada';

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select film.title from sakila.film join sakila.film_category on (film.film_id = film_category.film_id) join sakila.category on (film_category.category_id = category.category_id)  where category.name = 'family';

-- 7e. Display the most frequently rented movies in descending order.
select film.title, count(rental.rental_date) as number_of_rentals from sakila.rental join sakila.inventory on (rental.inventory_id = inventory.inventory_id) join sakila.film on (inventory.film_id = film.film_id) group by film.title order by count(rental.rental_date) desc;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
select store_id,  CONCAT('$', format (sum(amount),2)) as dollars from sakila.payment join sakila.staff on (payment.staff_id = staff.staff_id) group by store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.
select store.store_id, city.city, country.country from sakila.address join sakila.city on (address.city_id = city.city_id) join sakila.country on (city.country_id = country.country_id) join sakila.store on (address.address_id = store.address_id) ;

-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
select category.name as genres, sum(payment.amount) as gross_revenue from sakila.payment join sakila.rental on (payment.rental_id  = rental.rental_id) join sakila.inventory on (rental.inventory_id = inventory.inventory_id) join sakila.film_category on (inventory.film_id = film_category.film_id) join sakila.category on (film_category.category_id = category.category_id) group by category.name order by sum(amount) desc limit 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing= the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
create view top_5_genres_grossmargin as 
select category.name as genres, sum(payment.amount) as gross_revenue from sakila.payment join sakila.rental on (payment.rental_id  = rental.rental_id) join sakila.inventory on (rental.inventory_id = inventory.inventory_id) join sakila.film_category on (inventory.film_id = film_category.film_id) join sakila.category on (film_category.category_id = category.category_id) group by category.name order by sum(amount) desc limit 5;


-- 8b. How would /you display the view that you created in 8a?
select * from sakila.top_5_genres_grossmargin;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
drop view sakila.top_5_genres_grossmargin;