

# Capstone Project Pipeline Write-up

This repository contains the end-to-end data processing, SQL reporting, Python analysis, visualization, and AI narrative generation pipeline for the Capstone Project. Follow the instructions below step-by-step to reproduce all analysis and output metrics.

---

## 1. Database Setup & SQL Execution

The database relies on raw data files located in the `data/` directory (`customers.csv`, `orders.csv`, `products.csv`). To create the schema, populate the tables, and execute analytical reports:

1. Open your terminal or SQL client.

2. Load the schema to set up tables:

   
   ```bash
   sqlite3 capstone.db < sql/schema.sql
   ```
   
3. Load the seed dataset:
   
   ```bash
   sqlite3 capstone.db < sql/seed_data.sql
   ```
   
4. Run the analytical report queries:
   
   ```bash
   sqlite3 capstone.db < sql/report.sql
   ```
   
## 2. Python Data Cleaning, EDA & Visualization
   
After setting up the database, execute the Python scripts in sequence to clean data, run Exploratory Data Analysis (EDA), generate visualizations, and export key findings.

1. **Run Cleaning and EDA:**

   ```bash
   python analysis/clean_and_eda.py
   ```

   *Note: Running clean_and_eda.py also completes Task 1 of Part 3, which automatically exports and writes the structured analysis output to narrator/findings.json.*
   
2. **Generate Visualizations:**

  ```bash
   python analysis/visualize.py
   ```

   *This generates the chart images located in the visualizations/
   directory (monthly_revenue_trend.png and return_rate_by_payment.png).*

## 3. Narrative Generation (narrator/generate_narrative.py)

The final step generates the project narrative based on narrator/findings.json. This script can be run using either an online Gemini API key or in offline mode.

### Option A: Online Mode (With Gemini API Key)
Set your Gemini API key as an environment variable, then run the script:

- **On macOS/Linux:**

```bash
export GEMINI_API_KEY="your_api_key_here"
python narrator/generate_narrative.py
```

-**On Windows (Command Prompt):**

```cmd
set GEMINI_API_KEY="your_api_key_here"
python narrator/generate_narrative.py
```

-**On Windows (PowerShell):**

```
$env:GEMINI_API_KEY="your_api_key_here"
python narrator/generate_narrative.py
```

### Option B: Offline Mode (Without API Key)
If no API key is provided, run the script directly without setting the environment variable:

```bash
python narrator/generate_narrative.py
```
When executed without GEMINI_API_KEY, the script automatically triggers the fallback offline path to generate the narrative locally using pre-configured logic.

   
