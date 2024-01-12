select * from runners;
alter table runners add primary key(runner_id);
select * from customer_order1;
select * from runner_order1;
alter table runner_orders add primary key(order_id);
select * from pizza_names;
select * from pizza_recipes;
select * from pizza_toppings;


select truncate(order_time) from customer_orders;

-- Case Study Questions

-- Each of the following case study questions can be answered using a single SQL statement.
-- Before you start writing your SQL queries however - you might want to investigate the data, 
-- you may want to do something with some of those null values and data types in the customer_orders and runner_orders tables!

-- data cleaning for customer_order and runner_order
create table customer_order1 as select * from customer_orders;
desc customer_order1;
select * from customer_order1;
update customer_order1 set 
exclusions = (case exclusions when null then null else exclusions end);
update customer_order1 set 
extras = case 
	when extras like '' then null else extras end;
-- extras = case when extras = substr(extras, '') then null else extras end;

-- data cleaning for runner_order table
create table runner_order1 as select * from runner_orders;
select * from runner_order1;
update runner_order1 set 
cancellation = case when cancellation like ('') then null else cancellation end;

-- removing string from the numeric values
update runner_order1 set 
distance = case when distance like '%km' then trim('km' from distance) else distance end;

update runner_order1 set 
duration = case when duration like '%minutes' then trim('minutes' from duration) 
				when duration like '%mins' then trim('mins' from duration) 
                when duration like '%minute' then trim('minute' from duration) else duration end;

-- changing datatypes
-- pickup_time = date
-- distance = int
-- duration = int
desc runner_order1;
alter table runner_order1
modify column pickup_time datetime null,
modify column distance decimal(5,1),
modify column duration int;


-- A. Pizza Metrics
-- 1. How many pizzas were ordered?
select count(pizza_id) as total_order from customer_order1;

-- 2. How many unique customer orders were made?
select count(distinct customer_id) total_cust from customer_orders;

-- 3. How many successful orders were delivered by each runner?
select runner_id,count(runner_id) count from runner_orders
where distance is not null
group by runner_id;

-- 4. How many of each type of pizza was delivered?
select pn.pizza_name,count(co.pizza_id) from customer_order1 co
join pizza_names pn on co.pizza_id = pn.pizza_id
join runner_order1 ro on co.order_id = ro.order_id and ro.cancellation is null
group by pn.pizza_name;

-- 5. How many Vegetarian and Meatlovers were ordered by each customer?
select co.customer_id,pn.pizza_name,count(co.pizza_id) count from customer_order1 co 
join pizza_names pn on co.pizza_id = pn.pizza_id
group by co.customer_id,pn.pizza_name
order by co.customer_id;

-- 6. What was the maximum number of pizzas delivered in a single order?
select max(count) max from 
(select count(order_id) count from customer_order1 group by order_id) a;

-- 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?


-- 8. How many pizzas were delivered that had both exclusions and extras?
select count(pizza_id) count from customer_order1
where exclusions and extras is not null;

-- 9. What was the total volume of pizzas ordered for each hour of the day?


-- 10. What was the volume of orders for each day of the week?
select extract(day from order_time),count(pizza_id) from customer_order1
group by extract(day from order_time);

select date(order_time) day, count(pizza_id) count from customer_order1
group by date(order_time);

-- B. Runner and Customer Experience
-- 11. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)


-- 12. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
select runner_id, round(avg(duration),1) avg_time from runner_order1
group by runner_id;

-- 13. Is there any relationship between the number of pizzas and how long the order takes to prepare?


-- 14. What was the average distance travelled for each customer?
select co.customer_id,round(avg(ro.distance),1) average from customer_order1 co
join runner_order1 ro on co.order_id = ro.order_id
group by co.customer_id;

-- 15. What was the difference between the longest and shortest delivery times for all orders?


-- 16. What was the average speed for each runner for each delivery and do you notice any trend for these values?
select runner_id, round(sum(distance)/sum(duration*1.0/60),2) 'avg_speed(km/h)' from runner_order1
where duration is not null
group by runner_id;
group by runner_id;

-- 17. What is the successful delivery percentage for each runner?


-- C. Ingredient Optimisation
-- 18. What are the standard ingredients for each pizza?


-- 19. What was the most commonly added extra?


-- What was the most common exclusion?
-- Generate an order item for each record in the customers_orders table in the format of one of the following:
-- Meat Lovers
-- Meat Lovers - Exclude Beef
-- Meat Lovers - Extra Bacon
-- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
-- Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
-- For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"
-- What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

-- D. Pricing and Ratings
-- If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
-- What if there was an additional $1 charge for any pizza extras?
-- Add cheese is $1 extra
-- The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
-- Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
-- customer_id
-- order_id
-- runner_id
-- rating
-- order_time
-- pickup_time
-- Time between order and pickup
-- Delivery duration
-- Average speed
-- Total number of pizzas
-- If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?

-- E. Bonus Questions
-- If Danny wants to expand his range of pizzas - how would this impact the existing data design? Write an INSERT statement to demonstrate what would happen if a new Supreme pizza with all the toppings was added to the Pizza Runner menu?