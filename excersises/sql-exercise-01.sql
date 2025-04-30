/*
* File: 01-introduction.sql
<<<<<<< HEAD
* Author: Dakota Vaught
* Created: [Current Date]
=======
* Author: [Your Name]
* Created: Chris Buie
>>>>>>> 1053bec98b4a3c09e3ff6889912636c35aefc9e2
* 
* Description: Introduction exercise for Git training
* Domain: Oil and Gas
* 
* Instructions:
* 1. Add your name and today's date in the header above
* 2. Run this query to understand the data
* 3. Commit your changes with an appropriate message
*/

-- Basic query to analyze oil well production data
SELECT
    well_id,
    well_name,
    field_name,
    production_date,
    oil_production_bbls,
    gas_production_mcf,
    water_production_bbls,
    (oil_production_bbls * 365) AS estimated_annual_oil,
    (gas_production_mcf * 365) AS estimated_annual_gas
FROM
    production_data
WHERE
    production_date >= '2024-01-01'
    AND field_name = 'Eagle Ford'
ORDER BY
    well_id,
    production_date;

-- TODO: Add a comment explaining what insights we might derive from this query
-- TODO: Calculate the oil-to-gas ratio for each well

-- Example additional calculation you could add:
-- SELECT
--     well_id,
--     well_name,
--     AVG(oil_production_bbls) AS avg_daily_oil,
--     MAX(oil_production_bbls) AS peak_daily_oil,
--     SUM(oil_production_bbls) AS total_oil_production
-- FROM
--     production_data
-- GROUP BY
--     well_id,
--     well_name
-- ORDER BY
--     total_oil_production DESC
-- LIMIT 10;
