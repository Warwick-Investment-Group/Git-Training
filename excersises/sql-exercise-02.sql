/*
* File: 02-branches.sql
* Author: [Your Name]
* Created: [Current Date]
* 
* Description: Branch exercise for Git training
* Domain: Metals and Mining
* 
* Instructions:
* 1. Create a new branch from your previous branch
* 2. Modify this file by completing the TODOs
* 3. Commit your changes with an appropriate message
* 4. Push your branch and create a pull request
*/

-- Query analyzing mining operations productivity
SELECT
    m.mine_id,
    m.mine_name,
    m.mineral_type,
    m.country,
    m.region,
    o.operation_date,
    o.ore_extracted_tons,
    o.mineral_content_percentage,
    o.extraction_cost_per_ton,
    -- Calculate the extracted mineral quantity
    (o.ore_extracted_tons * o.mineral_content_percentage / 100) AS mineral_quantity,
    -- Calculate daily operational efficiency
    (o.ore_extracted_tons / NULLIF(o.labor_hours, 0)) AS tons_per_labor_hour
FROM
    mines m
JOIN
    mining_operations o ON m.mine_id = o.mine_id
WHERE
    o.operation_date BETWEEN '2024-01-01' AND '2024-03-31'
    AND m.mineral_type IN ('Copper', 'Gold', 'Silver')
ORDER BY
    m.mineral_type,
    mineral_quantity DESC;

-- TODO: Add a filter to focus on mines in a specific region
-- TODO: Calculate the total extraction cost (ore_extracted_tons * extraction_cost_per_ton)
-- TODO: Add a profitability calculation based on current mineral prices

-- Here's the mineral price reference table structure:
-- mineral_prices (
--     mineral_type VARCHAR(50),
--     price_date DATE,
--     price_per_unit DECIMAL(10,2),
--     unit VARCHAR(20)
-- )

-- Example query to join with prices (you can modify this):
-- SELECT
--     m.mine_name,
--     m.mineral_type,
--     SUM(o.ore_extracted_tons * o.mineral_content_percentage / 100) AS total_mineral,
--     AVG(p.price_per_unit) AS avg_price,
--     SUM((o.ore_extracted_tons * o.mineral_content_percentage / 100) * p.price_per_unit) AS potential_revenue
-- FROM
--     mines m
-- JOIN
--     mining_operations o ON m.mine_id = o.mine_id
-- JOIN
--     mineral_prices p ON m.mineral_type = p.mineral_type AND o.operation_date = p.price_date
-- GROUP BY
--     m.mine_name,
--     m.mineral_type
-- ORDER BY
--     potential_revenue DESC;
