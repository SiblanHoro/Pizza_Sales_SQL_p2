
Use PizzaHut

-------------------BASIC------------------------
---1. Retrieve the total number of orders placed.

SELECT 
    COUNT(*) AS Total_Orders
FROM 
    orders$;

---2. Calculate the total revenue generated from pizza sales.

SELECT 
     ROUND(SUM(pizzas$.price * 
order_details$.quantity), 2) AS Total_revenue
FROM 
    pizzas$
JOIN 
    order_details$ ON pizzas$.pizza_id = 
order_details$.pizza_id;

---3. Identify the highest-priced pizza.

SELECT TOP 1 
    pizza_types$.Name, 
    pizzas$.Price
FROM 
    pizza_types$
JOIN 
    pizzas$
	On pizza_types$.pizza_type_id = 
pizzas$.pizza_type_id
ORDER BY 
    pizzas$.Price DESC;

---4. Identify the most common pizza size ordered.

SELECT 
     pizzas$.size, 
     COUNT(order_details$.Order_details_id) AS 
Order_Count
FROM 
     pizzas$
JOIN 
     order_details$ 
     ON pizzas$.pizza_id = 
order_details$.pizza_id
GROUP BY 
     pizzas$.size
ORDER BY 
     Order_Count DESC;

---------------------------INTERMEDIATE----------------------------------
---5. List the top 5 most ordered pizza types along with their quantities.

SELECT TOP 5 
    pizza_types$.name,  
    SUM(order_details$.quantity) AS Quantity
FROM 
    pizza_types$
JOIN 
    pizzas$ 
    ON pizzas$.pizza_type_id = 
pizza_types$.pizza_type_id
JOIN 
    order_details$
    ON order_details$.pizza_id = 
pizzas$.pizza_id
GROUP BY 
    pizza_types$.name
ORDER BY 
    Quantity DESC;

---6. Join the necessary tables to find the total quantity of each pizza category ordered.

SELECT 
    pizza_types$.category, 
    SUM(order_details$.quantity) AS Total_Quantity
FROM 
    pizza_types$
JOIN 
    pizzas$ 
    ON pizzas$.pizza_type_id = 
pizza_types$.pizza_type_id
JOIN
    order_details$ 
	ON pizzas$.pizza_id = 
order_details$.pizza_id
GROUP BY 
    pizza_types$.category
ORDER BY 
    Total_Quantity DESC;

---7. Determine the distribution of orders by hour of the day.

SELECT 
     DATEPART(HOUR, time) AS Time_in_Hours,
     COUNT(order_id) AS Orders_Count
FROM 
     orders$
GROUP BY 
     DATEPART(HOUR, time)
ORDER BY 
     Time_in_Hours;

---8. Join relevant tables to find the category-wise distribution of pizzas.

SELECT 
    Category, 
    COUNT(Name) AS Pizza_Types 
FROM 
    pizza_types$
GROUP BY 
    Category;

----9. Group the orders by date and calculate the average number of pizzas ordered per day.

SELECT 
    ROUND(AVG(Quantity), 0) AS 
Average_Orders_PerDay
FROM (
    SELECT  
	    orders$.Date,
	    SUM(order_details$.Quantity) AS
Quantity 
	FROM 
	    orders$ 
    JOIN 
	    order_details$ 
		ON orders$.order_id =
order_details$.order_id
    GROUP BY 
	    orders$.Date
) AS Total_Quantity;

---10. Determine the top 3 most ordered pizza types based on revenue.

SELECT TOP 3 
    pizza_types$.Name,
    SUM(order_details$.Quantity * pizzas$.Price) AS Revenue
FROM 
    pizza_types$
JOIN 
    pizzas$ 
	ON pizza_types$.pizza_type_id = 
pizzas$.pizza_type_id
JOIN
    order_details$ 
	ON pizzas$.pizza_id = 
order_details$.pizza_id
GROUP BY 
    pizza_types$.Name
ORDER BY 
    Revenue DESC;
       
-------------------------------------ADVANCED-------------------------------------------

---11. Determine the top 3 most ordered pizza types based on revenue for each pizza category.

SELECT Name, 
       Revenue
FROM (
    SELECT Category, 
	       Name, 
	       revenue,
           RANK() OVER(PARTITION BY Category 
ORDER BY Revenue DESC) AS RANKS 
    FROM (
	    SELECT pizza_types$.Category, 
		       pizza_types$.Name,
               SUM((order_details$.Quantity ) * 
pizzas$.Price) AS  Revenue
        FROM pizza_types$  
        JOIN pizzas$ ON pizza_types$.Pizza_type_id = 
pizzas$.Pizza_type_id
        JOIN order_details$ ON order_details$.pizza_id = 
pizzas$.pizza_id
GROUP BY pizza_types$.Category, 
         pizza_types$.Name
     ) AS A
) as B
WHERE RANKS <= 3;

---12. Analyze the cumulative revenue generated over time.

SELECT Date,
      SUM(Revenue) OVER(ORDER BY Date) AS 
Cum_Revenue
FROM (
    SELECT orders$.Date, 
           SUM(order_details$.Quantity * 
pizzas$.Price) AS Revenue
    FROM order_details$
	JOIN pizzas$ ON order_details$.pizza_id = 
pizzas$.pizza_id
	JOIN orders$ ON order_details$.order_id = 
orders$.order_id
    GROUP BY orders$.Date
) AS Sales;

---13. Calculate the percentage contribution of each pizza type to total revenue.

SELECT 
    pizza_types$.Category,
    ROUND(SUM(pizzas$.price * order_details$.Quantity) / (SELECT 
	ROUND(SUM(pizzas$.price * order_details$.Quantity),
2) AS Total_Sales
FROM 
    order_details$
JOIN
    pizzas$ 
	ON order_details$.pizza_id = 
pizzas$.pizza_id) * 100, 2) AS Revenue
FROM 
    pizza_types$
JOIN
    pizzas$ 
	ON pizza_types$.pizza_type_id = 
pizzas$.pizza_type_id
JOIN 
    order_details$ 
	ON pizzas$.pizza_id = 
order_details$.pizza_id
GROUP BY 
    pizza_types$.Category
ORDER BY 
    Revenue DESC;










