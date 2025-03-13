# Evaluating the Relationship Between Corporate Sustainability (Measured by Environmental Productivity Metrics) and Financial Performance in the Top 100 Sustainable Corporations of 2024

## Overview
This case study analyzes the relationship between corporate sustainability and financial performance using two datasets: the 2024 Global 100 Full Dataset (environmental productivity metrics) and the Most Sustainable Corporations dataset (financial and diversity metrics). By linking the datasets via Rank, we use SQL for data integration and Power BI for visualization to assess how environmental efficiency impacts financial outcomes among the top 100 sustainable corporations in 2024.

## Objective  
**Main Question**:  
"How do environmental productivity metrics correlate with financial performance indicators among the top 100 sustainable corporations in 2024?"

- Investigate correlations between environmental productivity scores (e.g., `Energy Productivity Score`, `Carbon Productivity Score`) and financial metrics (e.g., `Revenue`, `Profit %`)
- Explore whether companies with higher sustainability grades (e.g., `Climate Grade`, `Overall Score`) achieve better financial performance
- Analyze trends by industry and location.

## Datasets  
- **Dataset 1**: 2024 Global 100 Full Dataset
  - **Source**: 
  - **Key Columns**: 2024 Ranking, Name, USD Purchasing Power Parity Revenue, Energy Productivity Score, Carbon Productivity Score, Water Productivity Score, Overall Score
- **Dataset 2**: Most Sustainable Corporations
  - **Source**: 
  - **Key Columns**: Rank, Company, Revenue, Profit %, Climate Grade, Sustainability Initiatives
- **Relationship**: Linked via 2024 Ranking (Full Dataset) = Rank (Most Sustainable).
## Repository Structure  
- **README.md**: Overview, instructions, and case study summary
- **data/**: Dataset folder
- **sql/**: SQL scripts
  - data_preparation.sql: Cleaning and joining queries
  - er_diagram.sql: ER Diagram definition
- **power_bi/**: Power BI files
  - sustainability_financial.pbix
- **analysis/**: Analysis outputs
  - exploratory_results.md: Summary of findings
  - visualizations/: charts/graphs
- **docs/**                 
  - case_study.md: Full case study write-up

## Analysis Workflow
### 1. **Data Preparation** - SQL

  1.1 **Load the Data**
  
  1.2 **Clean the Data**:
  
  - Standardize `CEO Pay Ratio` (convert time format to numeric days in `Most_Sustainable`)
  - Handle missing values
  - Split `HQ Location` and `Location` into `City` and `Country`
    
  1.3 **Join the Datasets**: Merge on 2024 Ranking and Rank.
  
  1.4 **Transform the Data**: Create derived columns
  
### 2. **Exploratory Analysis**
- **Analysis**
  - **Summary Statistics**: Compute averages for revenue, profit_percent, energy_prod_score
  - **Correlations**: Analyze relationships (e.g., `energy_prod_score` vs. `profit_usd`, `carbon_prod_score` vs. `revenue`)
  - **Group Analysis**: Aggregate by `gics_sector` or `country` to compare sustainability-financial performance

- **Visualizations** (Power BI)
  - **Import Data**: Load `combined_2024.csv` into Power BI.
  - **Create Visuals**
    - **Scatter Plot**: `energy_prod_score` (x-axis) vs. `profit_usd` (y-axis), sized by `revenue`, colored by `climate_grade`
    - **Bar Chart**: Average `profit_percent` by `gics_sector`
    - **Line Chart**: `rank_2024` vs. `revenue` and `profit_usd`
    - **Matrix**: `gics_industry` vs. `energy_prod_score`, `carbon_prod_score`, `revenue`, `profit_percent`
  - **Add Filters**: Slicers for `gics_sector`, `country`, and `climate_grade`

### 3. Outputs
- **Exploratory Results**: `exploratory_results.md` with findings
- **Visualizations**: PNGs/JPEGs in `visualizations/`
- **Power BI File**: `sustainability_financial.pbix`
