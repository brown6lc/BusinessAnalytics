# Analytics Portfolio
A collection of business analytics projects demonstrating skills in data cleaning, 
process monitoring, and operational dashboard design.

---

## Projects

### 1. Manufacturing Defect Operations Dashboard
**Tools:** Python (pandas), Tableau, Excel, Kaggle (for data sourcing)

**Dataset:** 1,000 manufacturing defect records (Jan–Jun 2024)
`https://www.kaggle.com/datasets/fahmidachowdhury/manufacturing-defects/data`

Built an operational KPI dashboard to monitor defect patterns, inspection team 
workload, and repair cost trends across a 6-month production period.

<img width="995" height="793" alt="image" src="https://github.com/user-attachments/assets/5c602e07-e88d-4b33-9f60-0bd39af90d34" />

**Skills demonstrated:**
- Root cause analysis via defect type and severity breakdown
- Process monitoring with critical defect rate trend line
- Workload distribution across inspection teams
- Heatmap analysis of defect location vs severity

**Files:** `analyticsProjectDirectory/EDAdefects/`

### 2. Manufacturing Process Improvement & Monte Carlo Simulation
**Tools:** Python (NumPy, pandas), Power BI, Lucidchart

**Dataset:** Synthetic — failure probabilities parameterized from manufacturing defect records analysis

Modeled a 6-stage manufacturing production process to identify high-risk failure points and quantify the impact of a targeted process intervention using Monte Carlo simulation.

<img width="988" height="561" alt="image" src="https://github.com/user-attachments/assets/8d92e4c4-7749-4796-b182-521b7a5baeea" />

**Skills demonstrated:**
- Process mapping of current and improved state manufacturing workflows in Lucidchart
- Monte Carlo simulation (10,000 iterations) to model defect propagation across production stages
- Scenario comparison quantifying the effect of a targeted Stage 3 assembly intervention
- Power BI dashboard visualizing defect rate distributions, stage-level failure contributions, and current vs. improved process outcomes

**Key findings:**
- Stage 3 (Assembly) identified as highest-risk stage at 10% failure rate
- Projected overall defect rate of 27.85% under current process conditions
- Targeted inline QC intervention at Stage 3 reduces failure rate from 10% to 4%, projecting a 4.47% reduction in overall defect rate

**Files:** `analyticsProjectDirectory/monteCarlo/`

### 3. COVID-19 Global Data Analysis
**Tools:** PostgreSQL, R

**Dataset:** 6 structured CSV datasets covering global case, death, recovery, and testing data
`https://www.kaggle.com/datasets/imdevskp/corona-virus-report`

Loaded and queried six COVID-19 datasets to surface trends in lethality, regional disparities, outbreak hotspots, and the relationship between testing intensity and mortality outcomes.

**Skills demonstrated:**
- Multi-table relational database design and data ingestion via COPY
- Time-series analysis of global case fatality rate evolution
- WHO region aggregation with recovery rate calculation
- Week-over-week growth rate analysis for outbreak hotspot identification
- Cross-country testing vs. mortality correlation setup

**Key findings:**
In progress

**Files:** `analyticsProjectDirectory/covidAnalysis/`
---

## In Progress
- Process Mapping & Improvement Project
- Root Cause Analysis Case Study

---

## Tools & Skills
Python (pandas, numpy), SQL, R, Tableau, Power Bi, Excel, Data Cleaning, Monte Carlo Simulation, Process Analysis, KPI Design
