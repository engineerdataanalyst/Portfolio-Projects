-- ---------------
-- Dish Statistics
-- ---------------

-- Find the number dishes and average dish price per dish category
SELECT
    category,    
    COUNT(*) AS num_dishes,
    ROUND(AVG(price), 2) AS avg_dish_price
FROM dishes
GROUP BY category
ORDER BY category;

-- Find the least and most expensive dishes
WITH cte AS
(
    SELECT
	name,
    	category,
    	price,
    	RANK() OVER(ORDER BY price DESC) AS desc_rank,
    	RANK() OVER(ORDER BY price) AS asc_rank
    FROM dishes
)
SELECT
    name,
    category,
    price
FROM cte
WHERE desc_rank = 1 OR
      asc_rank = 1;

-- Find the least and most ordered dishes
WITH cte AS
(
    SELECT
        d.name,
        d.category,
        COUNT(*) AS num_orders,
	SUM(d.price) AS total_revenue,
        RANK() OVER(ORDER BY COUNT(*) DESC) AS desc_rank_num,
        RANK() OVER(ORDER BY COUNT(*)) AS asc_rank_num
	FROM order_details o
    LEFT JOIN dishes d ON o.dish_id = d.dish_id
    WHERE d.dish_id IS NOT NULL
    GROUP BY d.dish_id
)
SELECT
    name,
    category,
    num_orders,
    total_revenue
FROM cte
WHERE desc_rank_num = 1 OR
      asc_rank_num = 1;

-- ----------------
-- Order Statistics
-- ----------------

-- Find the number of orders and total revenue per dish category
SELECT
    d.category,
    COUNT(DISTINCT o.order_id) AS num_orders,
    SUM(d.price) AS total_revenue
FROM order_details o
LEFT JOIN dishes d ON d.dish_id = o.dish_id
WHERE d.dish_id IS NOT NULL
GROUP BY d.category
ORDER BY d.category;

-- Find the number of orders made and total revenue for all dishes
SELECT
    COUNT(DISTINCT o.order_id) AS num_orders,
    SUM(d.price) AS total_revenue
FROM order_details o
LEFT JOIN dishes d ON o.dish_id = d.dish_id
WHERE d.dish_id IS NOT NULL;

-- Find the distribution of the number of dishes and total revenue per number of orders
WITH cte AS
(
    SELECT
        o.order_id,
        COUNT(*) AS num_dishes,
        SUM(d.price) AS total_revenue
    FROM order_details o
    LEFT JOIN dishes d ON o.dish_id = d.dish_id
    WHERE d.dish_id IS NOT NULL
    GROUP BY o.order_id
)
SELECT
    COUNT(*) AS num_orders,
    num_dishes,
    SUM(total_revenue) AS total_revenue
FROM cte
GROUP BY num_dishes
ORDER BY num_dishes;
