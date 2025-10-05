create database Pizzamania; 

use Pizzamania;

create table orders (
order_id int not null,
order_date date not null,
order_time time not null,
primary key(order_id));
select * from Pizzamania.order_details;

create table order_details (
order_details_id int not null,
order_id int not null,
pizza_id text not null,
quantity int not null,
primary key(order_details_));

select count(order_id) as total_orders from orders;

SELECT 
    ROUND(SUM(order_details.quantity * pizzas.price),
            2) AS total_sales
FROM
    order_details
        JOIN
    pizzas ON pizzas.pizza_id = order_details.pizza_id;

select pizza_types.name, pizzas.price
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by pizzas.price desc limit 1 ;

select quantity , count(order_details_id)
from order_details group by quantity;

select pizzas.size,count(order_details.order_details_id) as order_count
from pizzas join order_details
on pizzas.pizza_id = order_details.pizza_id
group by pizzas.size order by order_count desc;

select pizza_types.name,
sum(order_details.quantity) as quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id =pizzas.pizza_id 
group by pizza_types.name order by quantity desc limit 5 ;

select pizza_types.category,
sum(order_details.quantity) as quantity 
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by  pizza_types.category order by quantity desc;

select hour(order_time) as hours,count(order_id) from orders as order_count
group by hour(order_time);


select category,count(name) from pizza_types
group by category; 


select round(avg(quantity),0) as avg_pizza from
(select orders.order_date, sum(order_details.quantity) as quantity
from orders join order_details
on orders.order_id = order_details.order_id
group by orders.order_date) as order_quantity;

select pizza_types.name,
sum(order_details.quantity * pizzas.price) as revenue
from pizza_types join pizzas
on pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details
on order_details.pizza_id =  pizzas.pizza_id
group by pizza_types.name order by revenue desc limit 3;


select pizza_types.category,
round(sum(order_details.quantity*pizzas.price) / (select 
round(sum(order_details.quantity * pizzas.price),
2) as total_sales
from order_details join pizzas on pizzas.pizza_id = order_details.pizza_id) *100,2) as revenue
from  pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category order by revenue desc;



select order_date,
sum(revenue) over(order by order_date) as cum_revenue
from
(select orders.order_date,
sum(order_details.quantity * pizzas.price) as revenue
from order_details join pizzas
on order_details.pizza_id= pizzas.pizza_id
join orders
on orders.order_id = order_details.order_id
group by orders.order_date) as sales;




(select name,revenue from

(select category,name,revenue,
rank() over(partition by category order by revenue desc) as rn
from
(select pizza_types.category,pizza_types.name,
sum((order_details.quantity) * pizzas.price) as revenue
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category,pizza_types.name) as a) as  b
where rn <=3);
;
