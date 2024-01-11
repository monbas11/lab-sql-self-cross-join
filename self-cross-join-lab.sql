-- Get all pairs of actors that worked together

select distinct d1.actor_id, d2.actor_id
from sakila.film_actor d1
join sakila.film_actor d2 
on d1.film_id = d2.film_id
and d1.actor_id < d2.actor_id;

-- Get all pairs of customers that have rented the same film more than 3 times

create temporary table sakila.rental_and_inventory
select re.*, i.film_id, i.store_id
from rental re
join inventory i on re.inventory_id = i.inventory_id;

with rental_inventory as (
    select re.*, i.film_id, i.store_id
    from rental re
    join inventory i on re.inventory_id = i.inventory_id
)
select 
    r1.customer_id as customer1_id,
    r2.customer_id as customer2_id,
    r1.film_id
from  rental_inventory r1
join rental_inventory r2 on r1.film_id = r2.film_id
where r1.customer_id < r2.customer_id
group by r1.customer_id, r2.customer_id,r1.film_id
having  count(*) > 3;

-- Get all possible pairs of actors and films.
 
create temporary table actor_name as
select distinct actor_id
from sakila.actor;

create temporary table film_actor_id as
select distinct film_id
from sakila.film_actor;

select 
    a.first_name,
    a.last_name,
    f.title
from 
    actor_name an
cross join 
    film_actor_id fi
join 
    sakila.actor a on an.actor_id = a.actor_id
join 
    sakila.film f on fi.film_id = f.film_id; 