-- Create table: Sustainability_Full
CREATE TABLE IF NOT EXISTS Sustainability_Full (
    rank_2024 INTEGER PRIMARY KEY,
    rank_2023 INTEGER,
    name TEXT,
    gics_industry TEXT,
    gics_sector TEXT,
    hq_location TEXT,
    revenue_usd_ppp REAL,
    energy_prod_score REAL,
    carbon_prod_score REAL,
    water_prod_score REAL,
    ceo_pay_ratio TEXT,
    overall_score TEXT
);

-- Create table: Most_Sustainable
CREATE TABLE IF NOT EXISTS Most_Sustainable (
    rank INTEGER PRIMARY KEY,
    prev_rank INTEGER,
    company TEXT,
    location TEXT,
    industry TEXT,
    revenue REAL,
    profit_percent REAL,
    ceo_pay_ratio TEXT,
    women_board_percent REAL,
    women_leadership_percent REAL,
    women_workforce_percent REAL,
    climate_grade TEXT,
    sustainability_initiatives TEXT
);

-- Add city and country to Sustainability_Full (ignore if already exist)
ALTER TABLE Sustainability_Full ADD COLUMN city TEXT;
ALTER TABLE Sustainability_Full ADD COLUMN country TEXT;
-- Populate city and country in Sustainability_Full
UPDATE Sustainability_Full
SET city = SUBSTR(hq_location, 1, INSTR(hq_location, ', ') - 1),
    country = SUBSTR(hq_location, INSTR(hq_location, ', ') + 2);

-- Add city and country to Most_Sustainable
ALTER TABLE Most_Sustainable ADD COLUMN city TEXT;
ALTER TABLE Most_Sustainable ADD COLUMN country TEXT;
-- Populate city and country in Most_Sustainable
UPDATE Most_Sustainable
SET city = SUBSTR(location, 1, INSTR(location, ', ') - 1),
    country = SUBSTR(location, INSTR(location, ', ') + 2);

-- Add the column for change ceo_pay_ratio to days
ALTER TABLE Most_Sustainable ADD COLUMN ceo_pay_ratio_days REAL;
-- Update with corrected logic
UPDATE Most_Sustainable
SET ceo_pay_ratio_days = CASE
    WHEN ceo_pay_ratio LIKE '%days%' THEN 
        CAST(SUBSTR(ceo_pay_ratio, 1, INSTR(ceo_pay_ratio, ' days') - 1) AS REAL) +
        CAST(SUBSTR(
            SUBSTR(ceo_pay_ratio, INSTR(ceo_pay_ratio, ' days, ') + 7),
            1,
            INSTR(SUBSTR(ceo_pay_ratio, INSTR(ceo_pay_ratio, ' days, ') + 7), ':') - 1
        ) AS REAL) / 24.0
    WHEN ceo_pay_ratio LIKE '__:__:__' AND ceo_pay_ratio NOT LIKE '%days%' THEN 
        CAST(SUBSTR(ceo_pay_ratio, 1, INSTR(ceo_pay_ratio, ':') - 1) AS REAL) / 24.0
    WHEN ceo_pay_ratio LIKE '%:1' THEN 
        CAST(SUBSTR(ceo_pay_ratio, 1, INSTR(ceo_pay_ratio, ':') - 1) AS REAL)
    ELSE NULL
    END;
-- Verify results
SELECT ceo_pay_ratio, ceo_pay_ratio_days FROM Most_Sustainable LIMIT 10;

-- Creat "Combined" Table (Joining 2 Tables)
CREATE TABLE IF NOT EXISTS Combined AS
SELECT 
    f.rank_2024, f.name, f.gics_industry, f.gics_sector, f.city AS full_city, f.country AS full_country, 
    f.revenue_usd_ppp, f.energy_prod_score, f.carbon_prod_score, f.water_prod_score, f.overall_score,
    m.prev_rank, m.company, m.industry, m.revenue, m.profit_percent, m.ceo_pay_ratio_days, 
    m.women_board_percent, m.women_leadership_percent, m.women_workforce_percent, m.climate_grade,
    m.sustainability_initiatives
FROM Sustainability_Full f
JOIN Most_Sustainable m ON f.rank_2024 = m.rank;

-- Add profit_usd column from calculation (revenue x profit_percent)
ALTER TABLE Combined ADD COLUMN profit_usd REAL;
-- Update profit_usd, handling text formats
UPDATE Combined
SET profit_usd = 
    CAST(REPLACE(REPLACE(COALESCE(revenue, 0), '$', ''), ',', '') AS REAL) * 
    CAST(REPLACE(COALESCE(profit_percent, 0), '%', '') AS REAL) / 
    CASE WHEN profit_percent LIKE '%%' THEN 100.0 ELSE 1.0 END;
-- Verify the result
SELECT 
    rank_2024, 
    company, 
    revenue, 
    profit_percent, 
    profit_usd 
FROM Combined 
WHERE rank_2024 = 1;

-- Update revenue to numeric format
UPDATE Combined
SET revenue = CAST(REPLACE(REPLACE(revenue, '$', ''), ',', '') AS REAL);
-- Update revenue_usd_ppp to numeric format
UPDATE Combined
SET revenue_usd_ppp = CAST(REPLACE(REPLACE(revenue_usd_ppp, '$', ''), ',', '') AS REAL);
-- Update each column to remove '%' and convert to decimal (REAL)
UPDATE Combined
SET energy_prod_score = CAST(REPLACE(COALESCE(energy_prod_score, '0'), '%', '') AS REAL) / 100.0,
    carbon_prod_score = CAST(REPLACE(COALESCE(carbon_prod_score, '0'), '%', '') AS REAL) / 100.0,
    water_prod_score = CAST(REPLACE(COALESCE(water_prod_score, '0'), '%', '') AS REAL) / 100.0,
    profit_percent = CAST(REPLACE(COALESCE(profit_percent, '0'), '%', '') AS REAL) / 100.0,
    women_board_percent = CAST(REPLACE(COALESCE(women_board_percent, '0'), '%', '') AS REAL) / 100.0,
    women_leadership_percent = CAST(REPLACE(COALESCE(women_leadership_percent, '0'), '%', '') AS REAL) / 100.0,
    women_workforce_percent = CAST(REPLACE(COALESCE(women_workforce_percent, '0'), '%', '') AS REAL) / 100.0;

-- Verify the changes
SELECT 
    rank_2024, 
    company, 
    energy_prod_score, 
    carbon_prod_score, 
    water_prod_score, 
    profit_percent, 
    women_board_percent, 
    women_leadership_percent, 
    women_workforce_percent 
FROM Combined 
LIMIT 5;
