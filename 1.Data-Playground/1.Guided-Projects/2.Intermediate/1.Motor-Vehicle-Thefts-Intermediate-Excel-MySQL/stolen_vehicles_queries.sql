-- -----------------------------------------------
-- Objective 1: Identify when vehicles were stolen
-- -----------------------------------------------

-- Find the total number of vehicles stolen each year
SELECT
    YEAR(date_stolen) AS year,
    COUNT(*) AS num_vehicles
FROM stolen_vehicles
WHERE vehicle_type IS NOT NULL
GROUP BY year;

-- Find the total number of vehicles stolen each month
SELECT
    LEFT(MONTHNAME(date_stolen), 3) AS month,
    COUNT(*) AS num_vehicles
FROM stolen_vehicles
WHERE vehicle_type IS NOT NULL
GROUP BY MONTH(date_stolen)
ORDER BY MONTH(date_stolen);

-- Find the total number of vehicles stolen each day of the week
SELECT
    CASE
	WHEN WEEKDAY(date_stolen) = 0 THEN 'Mon'
        WHEN WEEKDAY(date_stolen) = 1 THEN 'Tue'
        WHEN WEEKDAY(date_stolen) = 2 THEN 'Wed'
        WHEN WEEKDAY(date_stolen) = 3 THEN 'Thu'
        WHEN WEEKDAY(date_stolen) = 4 THEN 'Fri'
        WHEN WEEKDAY(date_stolen) = 5 THEN 'Sat'
        WHEN WEEKDAY(date_stolen) = 6 THEN 'Sun'
	END AS day_of_week,
    COUNT(*) AS num_vehicles
FROM stolen_vehicles
WHERE vehicle_type IS NOT NULL
GROUP BY WEEKDAY(date_stolen)
ORDER BY WEEKDAY(date_stolen);

-- -----------------------------------------------
-- Objective 2: Identify what vehicles were stolen
-- -----------------------------------------------

-- Find the total number of vehicles stolen per make type
SELECT
    m.make_type,
    COUNT(*) AS num_vehicles
FROM stolen_vehicles s
LEFT JOIN make_details m ON s.make_id = m.make_id
WHERE s.vehicle_type IS NOT NULL
GROUP BY m.make_type
ORDER BY num_vehicles DESC;

-- Create a pivot table with the following dimensions:
-- rows representing the top 10 stolen vehicle types
-- columns representing the make type ratio and the total number of stolen vehicles
-- values representing the total number of stolen vehicles
SELECT
    s.vehicle_type,
    ROUND(COUNT(CASE WHEN m.make_type = 'Standard' THEN s.vehicle_id ELSE NULL END)/
	  COUNT(*), 2) AS standard,
    ROUND(COUNT(CASE WHEN m.make_type = 'Luxury' THEN s.vehicle_id ELSE NULL END)/
	  COUNT(*), 2) AS luxury,
    COUNT(*) AS total
FROM stolen_vehicles s
LEFT JOIN make_details m ON s.make_id = m.make_id
WHERE s.vehicle_type IS NOT NULL
GROUP BY s.vehicle_type
ORDER BY total DESC
LIMIT 10;

-- ------------------------------------------------
-- Objective 3: Identify where vehicles were stolen
-- ------------------------------------------------

-- Find the total number of vehicles stolen per region, population, and density
SELECT
    l.region,
    l.population,
    l.density,
    COUNT(*) AS num_vehicles
FROM stolen_vehicles s
LEFT JOIN locations l ON s.location_id = l.location_id
WHERE s.vehicle_type IS NOT NULL
GROUP BY
    l.region,
    l.population,
    l.density
ORDER BY num_vehicles DESC;
