-- Average Metrics by Sector
SELECT gics_sector,
       ROUND(AVG(energy_prod_score), 2) AS avg_energy_score,
       ROUND(AVG(carbon_prod_score), 2) AS avg_carbon_score,
       ROUND(AVG(revenue), 2) AS avg_revenue,
       ROUND(AVG(profit_percent), 2) AS avg_profit_percent
FROM Combined
GROUP BY gics_sector
ORDER BY avg_energy_score DESC;

-- Correlation Insights (Manual Calculation for SQLite)
SELECT 
    -- Correlation between energy_prod_score and profit_usd
    (AVG(energy_prod_score * profit_usd) - AVG(energy_prod_score) * AVG(profit_usd)) /
    (SQRT(AVG(energy_prod_score * energy_prod_score) - AVG(energy_prod_score) * AVG(energy_prod_score)) *
     SQRT(AVG(profit_usd * profit_usd) - AVG(profit_usd) * AVG(profit_usd))) AS corr_energy_profit,

    -- Correlation between carbon_prod_score and profit_usd
    (AVG(carbon_prod_score * profit_usd) - AVG(carbon_prod_score) * AVG(profit_usd)) /
    (SQRT(AVG(carbon_prod_score * carbon_prod_score) - AVG(carbon_prod_score) * AVG(carbon_prod_score)) *
     SQRT(AVG(profit_usd * profit_usd) - AVG(profit_usd) * AVG(profit_usd))) AS corr_carbon_profit,

    -- Correlation between water_prod_score and profit_usd
    (AVG(water_prod_score * profit_usd) - AVG(water_prod_score) * AVG(profit_usd)) /
    (SQRT(AVG(water_prod_score * water_prod_score) - AVG(water_prod_score) * AVG(water_prod_score)) *
     SQRT(AVG(profit_usd * profit_usd) - AVG(profit_usd) * AVG(profit_usd))) AS corr_water_profit
FROM Combined
WHERE energy_prod_score IS NOT NULL 
  AND carbon_prod_score IS NOT NULL 
  AND water_prod_score IS NOT NULL 
  AND profit_usd IS NOT NULL;
