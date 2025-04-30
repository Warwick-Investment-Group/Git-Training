/*
* File: 05-collaborative-workflow.sql
* Author: [Your Name]
* Created: [Current Date]
* 
* Description: Collaborative workflow exercise for Git training
* Domain: Metals and Mining + London Real Estate (Combined Analysis)
* 
* Instructions:
* 1. Review another team member's pull request for this file
* 2. Suggest changes using GitHub's review features
* 3. Approve and merge the pull request
*/

-- This query demonstrates a multi-domain analysis combining
-- metals/mining investment performance with London real estate

-- Part 1: Metals Mining Company Performance
WITH mining_performance AS (
    SELECT
        c.company_id,
        c.company_name,
        c.primary_commodity,
        c.headquarters_city,
        c.headquarters_country,
        c.market_cap_usd,
        c.employees,
        f.fiscal_year,
        f.revenue_usd,
        f.operating_profit_usd,
        f.net_income_usd,
        f.capex_usd,
        f.dividend_per_share_usd,
        f.production_volume,
        f.production_unit,
        f.average_selling_price,
        f.cash_cost_per_unit,
        f.all_in_sustaining_cost,
        
        -- Calculate key financial metrics
        (f.operating_profit_usd / NULLIF(f.revenue_usd, 0)) * 100 AS operating_margin,
        (f.net_income_usd / NULLIF(f.revenue_usd, 0)) * 100 AS profit_margin,
        f.capex_usd / NULLIF(f.production_volume, 0) AS capex_per_unit,
        f.average_selling_price - f.cash_cost_per_unit AS gross_margin_per_unit,
        f.average_selling_price - f.all_in_sustaining_cost AS net_margin_per_unit,
        
        -- Year-over-year calculations
        f.revenue_usd - LAG(f.revenue_usd) OVER (
            PARTITION BY c.company_id ORDER BY f.fiscal_year
        ) AS yoy_revenue_change,
        
        (f.revenue_usd - LAG(f.revenue_usd) OVER (
            PARTITION BY c.company_id ORDER BY f.fiscal_year
        )) / NULLIF(LAG(f.revenue_usd) OVER (
            PARTITION BY c.company_id ORDER BY f.fiscal_year
        ), 0) * 100 AS yoy_revenue_pct_change
    FROM
        mining_companies c
    JOIN
        mining_financials f ON c.company_id = f.company_id
    WHERE
        f.fiscal_year BETWEEN 2020 AND 2024
    AND
        c.market_cap_usd > 1000000000 -- Focus on major companies (>$1B market cap)
),

-- Part 2: London Real Estate Market Performance
real_estate_performance AS (
    SELECT
        r.borough_name,
        r.transaction_year,
        r.property_type,
        r.avg_price_gbp,
        r.transactions_count,
        r.avg_price_per_sqft_gbp,
        r.yoy_price_change_pct,
        r.avg_days_on_market,
        r.prime_location_flag,
        r.foreign_buyer_percentage,
        
        -- Calculate price performance against London average
        r.avg_price_gbp / NULLIF(city.avg_price_gbp, 0) AS relative_price_index,
        
        -- Calculate volatility
        r.price_volatility,
        
        -- Calculate transactions velocity
        r.transactions_count / LAG(r.transactions_count) OVER (
            PARTITION BY r.borough_name, r.property_type 
            ORDER BY r.transaction_year
        ) AS transaction_velocity
    FROM
        london_real_estate_yearly r
    JOIN (
        SELECT
            transaction_year,
            AVG(avg_price_gbp) AS avg_price_gbp
        FROM
            london_real_estate_yearly
        GROUP BY
            transaction_year
    ) city ON r.transaction_year = city.transaction_year
    WHERE
        r.transaction_year BETWEEN 2020 AND 2024
),

-- Part 3: Commodity-to-Real-Estate Correlation Analysis
commodity_prices AS (
    SELECT
        p.commodity_name,
        p.price_year,
        p.avg_annual_price_usd,
        p.min_price_usd,
        p.max_price_usd,
        p.price_volatility,
        
        -- Calculate year-over-year changes
        p.avg_annual_price_usd - LAG(p.avg_annual_price_usd) OVER (
            PARTITION BY p.commodity_name ORDER BY p.price_year
        ) AS yoy_price_change,
        
        (p.avg_annual_price_usd - LAG(p.avg_annual_price_usd) OVER (
            PARTITION BY p.commodity_name ORDER BY p.price_year
        )) / NULLIF(LAG(p.avg_annual_price_usd) OVER (
            PARTITION BY p.commodity_name ORDER BY p.price_year
        ), 0) * 100 AS yoy_price_pct_change
    FROM
        commodity_annual_prices p
    WHERE
        p.price_year BETWEEN 2020 AND 2024
    AND
        p.commodity_name IN ('Gold', 'Silver', 'Copper', 'Iron Ore', 'Oil', 'Natural Gas')
)

-- Main Analysis Query: Investment Correlation and Performance
SELECT
    -- Time period
    c.price_year AS analysis_year,
    
    -- Commodity metrics
    c.commodity_name,
    c.avg_annual_price_usd,
    c.yoy_price_pct_change AS commodity_price_change,
    
    -- Mining company metrics (averaged by commodity)
    AVG(m.operating_margin) AS avg_mining_operating_margin,
    AVG(m.profit_margin) AS avg_mining_profit_margin,
    AVG(m.yoy_revenue_pct_change) AS avg_mining_revenue_growth,
    
    -- Real estate metrics (prime London only)
    AVG(CASE WHEN r.prime_location_flag = 1 THEN r.avg_price_gbp END) AS avg_prime_property_price,
    AVG(CASE WHEN r.prime_location_flag = 1 THEN r.yoy_price_change_pct END) AS avg_prime_property_growth,
    AVG(CASE WHEN r.prime_location_flag = 1 THEN r.foreign_buyer_percentage END) AS avg_foreign_buyer_pct,
    
    -- Correlation analysis
    -- This section needs enhancements to properly calculate correlation coefficients
    -- between commodity prices and real estate values
    -- TODO: Add correlation coefficient calculations
    
    -- Investment return comparison
    -- Note: Real investment return would require more comprehensive time-series analysis
    -- and total return calculations including dividends
    AVG(m.yoy_revenue_pct_change) - AVG(CASE WHEN r.prime_location_flag = 1 THEN r.yoy_price_change_pct END) 
        AS mining_vs_real_estate_return_spread
FROM
    commodity_prices c
JOIN
    mining_performance m ON c.price_year = m.fiscal_year 
    AND (
        (c.commodity_name = m.primary_commodity) 
        OR (c.commodity_name = 'Oil' AND m.primary_commodity IN ('Oil', 'Natural Gas'))
    )
JOIN
    real_estate_performance r ON c.price_year = r.transaction_year
WHERE
    c.price_year BETWEEN 2020 AND 2024
GROUP BY
    c.price_year,
    c.commodity_name,
    c.avg_annual_price_usd,
    c.yoy_price_pct_change
ORDER BY
    c.price_year DESC,
    c.commodity_name;

-- TODO: Add analysis to determine if commodity price increases lead real estate valuation changes,
-- potentially identifying investment opportunities

-- TODO: Create visualization-ready output comparing investment performance across the sectors

-- Collaborative improvement opportunity:
-- What other comparisons or dimensions would provide valuable investment insights?
-- Add your suggestions below:

/*
Suggested improvements:

1. 

2. 

3. 

*/
