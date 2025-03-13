-- Entity-Relationship Diagram for Sustainability_Full and Most_Sustainable tables

-- Table definition for Sustainability_Full
Table Sustainability_Full {
  rank_2024 integer [primary key, note: 'Ranking for 2024']
  rank_2023 integer [note: 'Ranking for 2023, nullable']
  name text [note: 'Company name']
  gics_industry text [note: 'GICS industry classification']
  gics_sector text [note: 'GICS sector classification']
  hq_location text [note: 'Headquarters location']
  revenue_usd_ppp real [note: 'Revenue in USD (PPP)']
  energy_prod_score real [note: 'Energy productivity score (0-1)']
  carbon_prod_score real [note: 'Carbon productivity score (0-1)']
  water_prod_score real [note: 'Water productivity score (0-1), nullable']
  ceo_pay_ratio text [note: 'CEO to average worker pay ratio']
  overall_score text [note: 'Overall sustainability score (e.g., A+, B)']
  city text [note: 'Derived city from hq_location']
  country text [note: 'Derived country from hq_location']
}

-- Table definition for Most_Sustainable
Table Most_Sustainable {
  rank integer [primary key, note: 'Ranking for 2024']
  prev_rank integer [note: 'Previous year ranking, nullable']
  company text [note: 'Company name']
  location text [note: 'Company location']
  industry text [note: 'Industry classification']
  revenue real [note: 'Revenue in USD, nullable']
  profit_percent real [note: 'Profit percentage (decimal), nullable']
  ceo_pay_ratio text [note: 'CEO to worker pay ratio (e.g., "36:1")']
  women_board_percent real [note: 'Percentage of women on board (decimal)']
  women_leadership_percent real [note: 'Percentage of women in leadership (decimal)']
  women_workforce_percent real [note: 'Percentage of women in workforce (decimal)']
  climate_grade text [note: 'Climate performance grade (e.g., A+, B-)']
  sustainability_initiatives text [note: 'Sustainability initiatives (e.g., 1.5°C, SBTi), nullable']
  city text [note: 'Derived city from location']
  country text [note: 'Derived country from location']
  ceo_pay_ratio_days real [note: 'CEO pay ratio converted to days']
}

-- Define the 1:1 relationship between the tables
Ref: Sustainability_Full.rank_2024 - Most_Sustainable.rank
