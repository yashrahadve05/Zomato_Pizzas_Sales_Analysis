CREATE DATABASE PizzaSales;
USE PizzaSales;

SELECT * FROM order_details;
SELECT * FROM orders;
SELECT * FROM pizza_types;
SELECT * FROM pizzas;

--Que. Retrieve the total number of orders placed.
SELECT COUNT(order_id) as Total_Orders FROM orders;
-- Total No. of Orders is 21350 orders

--Que. Calculate the total revenue generated from pizza sales.
SELECT SUM(order_details.quantity * pizzas.price) as Total_revenue
FROM order_details JOIN pizzas
ON order_details.pizza_id = pizzas.pizza_id;
-- Total revanue is 817869.05

--Que. Identify the highest-priced pizza.
SELECT TOP(1) pizza_types.name, ROUND(pizzas.price, 2)
FROM pizza_types JOIN pizzas
ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC;
-- Highest Priced Pizza is 35.95

-- Que. Identify the most common pizza size ordered.
SELECT TOP(1) pizzas.size, COUNT(order_details.order_details_id)
as No_of_Pizzas_Ordered
FROM pizzas JOIN order_details
ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size
ORDER BY No_of_Pizzas_Ordered DESC;
-- Common Pizza size ordered is L and no. of orders is 18526

--Que. List the top 5 most ordered pizza types along with their quantities.
SELECT TOP(5) pizza_types.name, SUM(order_details.quantity)
AS Quantity
FROM (pizza_types JOIN pizzas
ON pizza_types.pizza_type_id = pizzas.pizza_type_id) JOIN order_details
ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY Quantity DESC ;




-- Que. Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT pizza_types.category, SUM(order_details.quantity)
AS Total_Quantity
FROM (pizza_types JOIN pizzas
ON pizza_types.pizza_type_id = pizzas.pizza_type_id)
JOIN order_details
ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.category;

-- Que. Determine the distribution of orders by hour of the day.
SELECT DAY(date) as Date, COUNT(order_id) AS Order_Count
FROM orders
GROUP BY DAY(date)
ORder by DAY(date);
--This question is drop because of not getting hours

-- Que. Join relevant tables to find the category-wise distribution of pizzas.
SELECT category AS Category, COUNT(name) as Pizza_Name
FROM pizza_types
GROUP BY category;

-- Que. Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT AVG(Quantity) as Avg_Pizzas_Ordered_per_Day FROM
(SELECT orders.date AS Date_of_Order,
SUM(order_details.quantity)  AS Quantity
FROM orders JOIN order_details
ON orders.order_id = order_details.order_id
GROUP BY orders.date) AS Orders_Quantity;

--Que. Determine the top 3 most ordered pizza types based on revenue.
SELECT TOP(3) pizza_types.name AS Pizza_Name,
SUM(order_details.quantity * pizzas.price) AS Revanue
FROM (pizza_types JOIN pizzas
ON pizza_types.pizza_type_id = pizzas.pizza_type_id)
JOIN order_details
ON pizzas.pizza_id = order_details.pizza_id
GROUP BY  pizza_types.name
ORDER BY Revanue DESC;




--Que. Calculate the percentage contribution of each pizza type to total revenue.
SELECT pizza_types.category AS Category,
ROUND((ROUND(SUM(order_details.quantity * pizzas.price), 2) / (SELECT SUM(order_details.quantity * pizzas.price)
FROM order_details JOIN pizzas
ON order_details.pizza_id = pizzas.pizza_id)) * 100 ,2) AS Revanue_in_Percentage
FROM (pizzas JOIN order_details
ON pizzas.pizza_id = order_details.pizza_id)
JOIN pizza_types
ON pizza_types.pizza_type_id = pizzas.pizza_type_id
GROUP BY pizza_types.category;

-- Que. Analyze the cumulative revenue generated over time.
SELECT date AS Date,
SUM(Revanue) over (order by date) AS Cumulative_Price
FROM
(SELECT orders.date, ROUND( SUM(order_details.quantity * pizzas.price),2) AS Revanue
FROM (orders JOIN order_details
ON orders.order_id = order_details.order_id)
JOIN pizzas
ON pizzas.pizza_id = order_details.pizza_id
GROUP BY orders.date) AS Sales;

--Que. Determine the top 3 most ordered pizza types based on revenue for each pizza category.
SELECT TOP(3) pizza_types.name, pizza_types.category,
SUM(order_details.quantity * pizzas.price) AS Revanue
FROM (order_details JOIN pizzas
ON order_details.pizza_id = pizzas.pizza_id)
JOIN pizza_types
ON pizzas.pizza_type_id = pizza_types.pizza_type_id
GROUP BY pizza_types.category, pizza_types.name
ORDER BY Revanue DESC;