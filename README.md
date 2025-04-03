# PIZZA SALES PERFORMANCE ANALYSIS WITH SQL
**Project Title**: Pizza Sales Analysis  
**Level**: Intermediate  
**Database**: `PizzaHut

In this project, we aim to analyze pizza sales data using SQL to extract valuable insights. By examining sales patterns, identifying customer preferences, and understanding revenue trends, we can provide actionable recommendations to improve business performance. SQL will help us effciently query large datasets, perform cleaning, and generate reports for better decision-making. This analysis can assist in optimizing inventory, tailoring market strategies and customer satisfaction. 
 `
## Objectives

1. Analyze pizza sales data to extract insights.
2. Identify best selling pizzas, peak sales times, and customer preferences.
3. Provide data driven recommendations to optimize sales and inventory.
4. Business Analysis: Use SQL to answer specific business questions and derive insights from the sales data.

## Data Schema
Includes tables like

•	Pizzas (Pizza_Id, Pizza_type_id, Size, Price)

•	Pizza_Types(pizza_type_id, Name, Category, Ingredients)

•	Orders(Order_id, Date, Time)

•	Order_Details(Order_details_id, order_id, pizza_id, Category)

 ## Data Exploration & CleaningData Cleaning 
•	Record Count: Determine the total number of records in the dataset.

•	Customer Count: Find out how many unique customers are in the dataset.

•	Category Count: Identify all unique product categories in the dataset.

•	Null Value Check: Check for any null values in the dataset and delete records with missing data.

Use PizzaHut
```sql
SELECT * FROM pizzas$
SELECT * FROM pizzas_types$
SELECT * FROM orders$
SELECT * FROM Order_Details$
```
```sql
SELECT * FROM pizzas$
WHERE pizza_id IS NULL
   OR 
   pizza_type_id IS NULL
   OR
   size IS NULL
   OR
   price IS NULL

SELECT * FROM pizza_types$
WHERE pizza_type_id IS NULL
   OR
   name IS NULL
   OR
   category IS NULL
   OR
   ingredients IS NULL

SELECT * FROM Order_Details$
WHERE order_details_id IS NULL
   OR 
   order_id IS NULL
   OR
   pizza_id IS NULL
   OR
   quantity IS NULL
```
3. Data Analysis & Findings
The following SQL queries were developed to answer specific business questions:

---1. Retrieve the total number of orders placed.
```sql
SELECT 
    COUNT(*) AS Total_Orders
FROM 
    orders$;
```
---2. Calculate the total revenue generated from pizza sales.

```sql
SELECT 
     ROUND(SUM(pizzas$.price * 
order_details$.quantity), 2) AS Total_revenue
FROM 
    pizzas$
JOIN 
    order_details$ ON pizzas$.pizza_id = 
order_details$.pizza_id;
```
---3. Identify the highest-priced pizza.
```sql
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
```
---4. Identify the most common pizza size ordered.
```sql
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
```
---5. List the top 5 most ordered pizza types along with their quantities.
```sql
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
```
---6. Join the necessary tables to find the total quantity of each pizza category ordered.
```sql
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
```
---7. Determine the distribution of orders by hour of the day.
```sql
SELECT 
     DATEPART(HOUR, time) AS Time_in_Hours,
     COUNT(order_id) AS Orders_Count
FROM 
     orders$
GROUP BY 
     DATEPART(HOUR, time)
ORDER BY 
     Time_in_Hours;
```
---8. Join relevant tables to find the category-wise distribution of pizzas.
```sql
SELECT 
    Category, 
    COUNT(Name) AS Pizza_Types 
FROM 
    pizza_types$
GROUP BY 
    Category;
```
----9. Group the orders by date and calculate the average number of pizzas ordered per day.
```sql
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
```
---10. Determine the top 3 most ordered pizza types based on revenue.
```sql
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
```       
---11. Determine the top 3 most ordered pizza types based on revenue for each pizza category.
```sql
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
```
---12. Analyze the cumulative revenue generated over time.
```sql
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
```
---13. Calculate the percentage contribution of each pizza type to total revenue.

```sql
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
```

## Insights and Recommendation 

•  Sales Insights: From previous analysis, it’s evident that Large(L) pizzas are most ordered this suggests that customers prefer larger sizes possibly for sharing.

•  Order volume by Time of Day: Analyze peak hours of pizza orders. Typically, lunch and dinner hours (1PM-9PM) see most actively.

## Reccomendation: 

•  Promote baverages, sides, and desserts with pizza orders to increase average order value.

•  If specific regions show high sales, run localized ad campaigns or collaborate with nearby business.

## Conclusion 

The pizza sales project provided meaningful insights into customer preferences, sales performance, and revenue trends. By leberaging SQL for data extraction and analysis.
the analysis higlighted the dominance of large and medium-sized pizzas in sales volume, confirming their popularity among customers.
Overall, the project successfully demonstrated the value of data-driven decision-making in the food and beverage industry.
This project not only enhances analytical skills but also strengthened the ability to interpret business challanges using data. It serves as a strong foundation for future analytical endeavors in the field of data analytics.
