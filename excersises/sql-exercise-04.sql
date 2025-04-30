/*
* File: 04-query-optimization.sql
* Author: [Your Name]
* Created: [Current Date]
* 
* Description: Query optimization exercise for Git training
* Domain: Oil and Gas
* 
* Instructions:
* 1. This query needs optimization for better performance
* 2. Make multiple commits showing your thought process
* 3. Use descriptive commit messages explaining your reasoning
* 4. Each optimization should be its own commit
*/

-- ORIGINAL QUERY
-- This query analyzes the production decline rates of oil wells
-- Current performance: Takes approximately 45 seconds to run

SELECT 
    w.well_id,
    w.well_name,
    w.field_name,
    w.basin,
    w.operator,
    w.completion_date,
    w.lateral_length_ft,
    w.well_type,
    
    -- Calculate first year production
    SUM(CASE 
        WHEN p.production_date BETWEEN w.completion_date AND DATEADD(YEAR, 1, w.completion_date)
        THEN p.oil_production_bbls
        ELSE 0
    END) as first_year_oil,
    
    SUM(CASE 
        WHEN p.production_date BETWEEN w.completion_date AND DATEADD(YEAR, 1, w.completion_date)
        THEN p.gas_production_mcf
        ELSE 0
    END) as first_year_gas,
    
    -- Calculate second year production
    SUM(CASE 
        WHEN p.production_date BETWEEN DATEADD(YEAR, 1, w.completion_date) AND DATEADD(YEAR, 2, w.completion_date)
        THEN p.oil_production_bbls
        ELSE 0
    END) as second_year_oil,
    
    SUM(CASE 
        WHEN p.production_date BETWEEN DATEADD(YEAR, 1, w.completion_date) AND DATEADD(YEAR, 2, w.completion_date)
        THEN p.gas_production_mcf
        ELSE 0
    END) as second_year_gas,
    
    -- Calculate third year production
    SUM(CASE 
        WHEN p.production_date BETWEEN DATEADD(YEAR, 2, w.completion_date) AND DATEADD(YEAR, 3, w.completion_date)
        THEN p.oil_production_bbls
        ELSE 0
    END) as third_year_oil,
    
    SUM(CASE 
        WHEN p.production_date BETWEEN DATEADD(YEAR, 2, w.completion_date) AND DATEADD(YEAR, 3, w.completion_date)
        THEN p.gas_production_mcf
        ELSE 0
    END) as third_year_gas,
    
    -- Calculate decline rates
    CASE 
        WHEN SUM(CASE 
            WHEN p.production_date BETWEEN w.completion_date AND DATEADD(YEAR, 1, w.completion_date)
            THEN p.oil_production_bbls ELSE 0
        END) > 0
        THEN 1 - (SUM(CASE 
            WHEN p.production_date BETWEEN DATEADD(YEAR, 1, w.completion_date) AND DATEADD(YEAR, 2, w.completion_date)
            THEN p.oil_production_bbls ELSE 0
        END) / SUM(CASE 
            WHEN p.production_date BETWEEN w.completion_date AND DATEADD(YEAR, 1, w.completion_date)
            THEN p.oil_production_bbls ELSE 0
        END))
        ELSE NULL
    END as oil_decline_rate_year1,
    
    CASE 
        WHEN SUM(CASE 
            WHEN p.production_date BETWEEN DATEADD(YEAR, 1, w.completion_date) AND DATEADD(YEAR, 2, w.completion_date)
            THEN p.oil_production_bbls ELSE 0
        END) > 0
        THEN 1 - (SUM(CASE 
            WHEN p.production_date BETWEEN DATEADD(YEAR, 2, w.completion_date) AND DATEADD(YEAR, 3, w.completion_date)
            THEN p.oil_production_bbls ELSE 0
        END) / SUM(CASE 
            WHEN p.production_date BETWEEN DATEADD(YEAR, 1, w.completion_date) AND DATEADD(YEAR, 2, w.completion_date)
            THEN p.oil_production_bbls ELSE 0
        END))
        ELSE NULL
    END as oil_decline_rate_year2,
    
    -- Add more detailed well data
    w.frac_stages,
    w.proppant_volume_lbs,
    w.fluid_volume_bbls,
    w.reservoir_depth_ft,
    w.reservoir_pressure_psi,
    w.reservoir_temperature_f,
    w.porosity_pct,
    w.permeability_md,
    w.water_saturation_pct,
    w.api_gravity,
    w.gor_initial,
    
    -- Estimated ultimate recovery calculations
    w.eur_oil_mbbls,
    w.eur_gas_mmcf,
    
    -- Economic calculations
    w.drilling_cost_usd,
    w.completion_cost_usd,
    w.facilities_cost_usd,
    w.total_cost_usd,
    
    -- Calculate cost per foot
    w.total_cost_usd / NULLIF(w.lateral_length_ft, 0) as cost_per_foot,
    
    -- Calculate NPV and IRR (from pre-calculated fields)
    w.npv10_mmusd,
    w.irr_pct,
    
    -- Count workover operations
    COUNT(DISTINCT wo.workover_id) as workover_count,
    SUM(wo.workover_cost_usd) as total_workover_cost
FROM 
    wells w
LEFT JOIN 
    production p ON w.well_id = p.well_id
LEFT JOIN 
    workover_operations wo ON w.well_id = wo.well_id
WHERE 
    w.completion_date >= '2015-01-01'
    AND w.completion_date <= '2020-12-31'
    AND w.well_status = 'ACTIVE'
    AND w.well_type IN ('OIL', 'GAS', 'COMBO')
    AND w.basin IN ('Permian', 'Eagle Ford', 'Bakken', 'Marcellus')
GROUP BY
    w.well_id,
    w.well_name,
    w.field_name,
    w.basin,
    w.operator,
    w.completion_date,
    w.lateral_length_ft,
    w.well_type,
    w.frac_stages,
    w.proppant_volume_lbs,
    w.fluid_volume_bbls,
    w.reservoir_depth_ft,
    w.reservoir_pressure_psi,
    w.reservoir_temperature_f,
    w.porosity_pct,
    w.permeability_md,
    w.water_saturation_pct,
    w.api_gravity,
    w.gor_initial,
    w.eur_oil_mbbls,
    w.eur_gas_mmcf,
    w.drilling_cost_usd,
    w.completion_cost_usd,
    w.facilities_cost_usd,
    w.total_cost_usd,
    w.npv10_mmusd,
    w.irr_pct
ORDER BY 
    w.basin,
    w.completion_date;

-- OPTIMIZATION OPPORTUNITIES:
-- 1. Add appropriate indexes
-- 2. Reduce unnecessary columns
-- 3. Pre-aggregate some calculations
-- 4. Optimize the JOIN logic
-- 5. Use CTEs or temporary tables for the year calculations
-- 6. Limit the date range more specifically
-- 7. Add NOLOCK hints if appropriate for your environment
-- 8. Consider partitioning strategies

-- Your optimized query goes below:
-- (Make incremental improvements with multiple commits)

