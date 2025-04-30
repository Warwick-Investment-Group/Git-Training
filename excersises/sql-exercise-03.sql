/*
* File: 03-conflict-resolution.sql
* Author: [Your Name]
* Created: [Current Date]
* 
* Description: Conflict resolution exercise for Git training
* Domain: London Real Estate
* 
* Instructions:
* 1. Work with a partner on this file
* 2. Each person should make different changes to the same areas
* 3. Try to push your changes and resolve resulting conflicts
* 4. Document the conflict resolution process
*/

-- London Real Estate Market Analysis
-- This query analyzes property transactions in London boroughs

-- Property transaction statistics by borough
SELECT
    borough_name,
    property_type,
    -- Basic transaction statistics
    COUNT(*) AS number_of_transactions,
    AVG(sale_price) AS average_price,
    MIN(sale_price) AS minimum_price,
    MAX(sale_price) AS maximum_price,
    STDDEV(sale_price) AS price_standard_deviation,
    
    -- Price per square foot calculations
    AVG(sale_price / square_feet) AS avg_price_per_sqft,
    
    -- Year-over-year metrics
    AVG(sale_price) - LAG(AVG(sale_price)) OVER (
        PARTITION BY borough_name, property_type 
        ORDER BY EXTRACT(YEAR FROM transaction_date)
    ) AS yoy_price_change,
    
    -- Market velocity
    AVG(days_on_market) AS avg_days_on_market
FROM
    london_property_sales
WHERE
    transaction_date BETWEEN '2023-01-01' AND '2024-03-31'
    AND property_type IN ('Flat', 'Terraced', 'Semi-detached', 'Detached')
GROUP BY
    borough_name,
    property_type,
    EXTRACT(YEAR FROM transaction_date)
ORDER BY
    borough_name,
    property_type,
    EXTRACT(YEAR FROM transaction_date);

-- DELIBERATE CONFLICT AREA 1 --
-- Each team member should add different filtering criteria below
-- Person A: Add price range filtering
-- WHERE sale_price BETWEEN 500000 AND 2000000

-- Person B: Add square footage filtering
-- WHERE square_feet BETWEEN 500 AND 2000

-- DELIBERATE CONFLICT AREA 2 --
-- Each team member should add different calculations below
-- Person A: Calculate annual appreciation rates
/*
SELECT
    borough_name,
    property_type,
    transaction_year,
    current_avg_price,
    previous_avg_price,
    (current_avg_price - previous_avg_price) / previous_avg_price * 100 AS annual_appreciation_rate
FROM (
    SELECT
        borough_name,
        property_type,
        EXTRACT(YEAR FROM transaction_date) AS transaction_year,
        AVG(sale_price) AS current_avg_price,
        LAG(AVG(sale_price)) OVER (
            PARTITION BY borough_name, property_type 
            ORDER BY EXTRACT(YEAR FROM transaction_date)
        ) AS previous_avg_price
    FROM
        london_property_sales
    GROUP BY
        borough_name,
        property_type,
        EXTRACT(YEAR FROM transaction_date)
) AS price_trends
WHERE
    previous_avg_price IS NOT NULL
ORDER BY
    annual_appreciation_rate DESC;
*/

-- Person B: Calculate proximity premium to tube stations
/*
SELECT
    p.borough_name,
    p.property_type,
    CASE
        WHEN p.distance_to_tube_meters < 500 THEN 'Under 500m'
        WHEN p.distance_to_tube_meters < 1000 THEN '500m-1000m'
        WHEN p.distance_to_tube_meters < 2000 THEN '1000m-2000m'
        ELSE 'Over 2000m'
    END AS tube_proximity,
    AVG(p.sale_price) AS avg_price,
    COUNT(*) AS number_of_properties
FROM
    london_property_sales p
GROUP BY
    p.borough_name,
    p.property_type,
    CASE
        WHEN p.distance_to_tube_meters < 500 THEN 'Under 500m'
        WHEN p.distance_to_tube_meters < 1000 THEN '500m-1000m'
        WHEN p.distance_to_tube_meters < 2000 THEN '1000m-2000m'
        ELSE 'Over 2000m'
    END
ORDER BY
    p.borough_name,
    p.property_type,
    tube_proximity;
*/

-- Document your conflict resolution strategy below:
/*
CONFLICT RESOLUTION DOCUMENTATION

1. Conflicts encountered:

2. Resolution approach:

3. Git commands used:

4. Lessons learned:

*/
