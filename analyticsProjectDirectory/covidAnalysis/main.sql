-- ============================================================
-- COVID-19 Global Data Analysis
-- Author: Landon
-- Date: 2024
-- Description: Setup file — creates all tables and imports data
-- ============================================================


-- ============================================================
-- STEP 1: DROP TABLES (safe re-run)
-- ============================================================

DROP TABLE IF EXISTS country_wise_latest;
DROP TABLE IF EXISTS covid_19_clean_complete;
DROP TABLE IF EXISTS day_wise;
DROP TABLE IF EXISTS full_grouped;
DROP TABLE IF EXISTS usa_county_wise;
DROP TABLE IF EXISTS worldometer_data;


-- ============================================================
-- STEP 2: CREATE TABLES
-- ============================================================

CREATE TABLE country_wise_latest (
    "Country/Region"          TEXT,
    Confirmed                 INTEGER,
    Deaths                    INTEGER,
    Recovered                 INTEGER,
    Active                    INTEGER,
    "New cases"               INTEGER,
    "New deaths"              INTEGER,
    "New recovered"           INTEGER,
    "Deaths / 100 Cases"      NUMERIC,
    "Recovered / 100 Cases"   NUMERIC,
    "Deaths / 100 Recovered"  NUMERIC,
    "Confirmed last week"     INTEGER,
    "1 week change"           INTEGER,
    "1 week % increase"       NUMERIC,
    "WHO Region"              TEXT
);

CREATE TABLE covid_19_clean_complete (
    "Province/State"  TEXT,
    "Country/Region"  TEXT,
    Lat               NUMERIC,
    Long              NUMERIC,
    Date              DATE,
    Confirmed         INTEGER,
    Deaths            INTEGER,
    Recovered         INTEGER,
    Active            INTEGER,
    "WHO Region"      TEXT
);

CREATE TABLE day_wise (
    Date                      DATE,
    Confirmed                 INTEGER,
    Deaths                    INTEGER,
    Recovered                 INTEGER,
    Active                    INTEGER,
    "New cases"               INTEGER,
    "New deaths"              INTEGER,
    "New recovered"           INTEGER,
    "Deaths / 100 Cases"      NUMERIC,
    "Recovered / 100 Cases"   NUMERIC,
    "Deaths / 100 Recovered"  NUMERIC,
    "No. of countries"        INTEGER
);

CREATE TABLE full_grouped (
    Date              DATE,
    "Country/Region"  TEXT,
    Confirmed         INTEGER,
    Deaths            INTEGER,
    Recovered         INTEGER,
    Active            INTEGER,
    "New cases"       INTEGER,
    "New deaths"      INTEGER,
    "New recovered"   INTEGER,
    "WHO Region"      TEXT
);

CREATE TABLE usa_county_wise (
    UID            INTEGER,
    iso2           TEXT,
    iso3           TEXT,
    code3          INTEGER,
    FIPS           NUMERIC,
    Admin2         TEXT,
    Province_State TEXT,
    Country_Region TEXT,
    Lat            NUMERIC,
    Long_          NUMERIC,
    Combined_Key   TEXT,
    Date           DATE,
    Confirmed      INTEGER,
    Deaths         INTEGER
);

CREATE TABLE worldometer_data (
    "Country/Region"    TEXT,
    Continent           TEXT,
    Population          BIGINT,
    TotalCases          INTEGER,
    NewCases            INTEGER,
    TotalDeaths         INTEGER,
    NewDeaths           INTEGER,
    TotalRecovered      INTEGER,
    NewRecovered        INTEGER,
    ActiveCases         INTEGER,
    "Serious,Critical"  INTEGER,
    "Tot Cases/1M pop"  NUMERIC,
    "Deaths/1M pop"     NUMERIC,
    TotalTests          BIGINT,
    "Tests/1M pop"      NUMERIC,
    "WHO Region"        TEXT
);


-- ============================================================
-- STEP 3: IMPORT DATA
-- ============================================================

COPY country_wise_latest
FROM 'C:/Users/lando/Documents/VSCODE-Working/analyticsProjectDirectory/SQLproj/covid data/country_wise_latest.csv'
WITH CSV HEADER;

COPY covid_19_clean_complete
FROM 'C:/Users/lando/Documents/VSCODE-Working/analyticsProjectDirectory/SQLproj/covid data/covid_19_clean_complete.csv'
WITH CSV HEADER;

COPY day_wise
FROM 'C:/Users/lando/Documents/VSCODE-Working/analyticsProjectDirectory/SQLproj/covid data/day_wise.csv'
WITH CSV HEADER;

COPY full_grouped
FROM 'C:/Users/lando/Documents/VSCODE-Working/analyticsProjectDirectory/SQLproj/covid data/full_grouped.csv'
WITH CSV HEADER;

COPY usa_county_wise
FROM 'C:/Users/lando/Documents/VSCODE-Working/analyticsProjectDirectory/SQLproj/covid data/usa_county_wise.csv'
WITH CSV HEADER;

COPY worldometer_data
FROM 'C:/Users/lando/Documents/VSCODE-Working/analyticsProjectDirectory/SQLproj/covid data/worldometer_data.csv'
WITH CSV HEADER;


-- ============================================================
-- STEP 4: VERIFY IMPORTS
-- ============================================================

SELECT 'country_wise_latest'     AS table_name, COUNT(*) AS rows FROM country_wise_latest
UNION ALL
SELECT 'covid_19_clean_complete' AS table_name, COUNT(*) AS rows FROM covid_19_clean_complete
UNION ALL
SELECT 'day_wise'                AS table_name, COUNT(*) AS rows FROM day_wise
UNION ALL
SELECT 'full_grouped'            AS table_name, COUNT(*) AS rows FROM full_grouped
UNION ALL
SELECT 'usa_county_wise'         AS table_name, COUNT(*) AS rows FROM usa_county_wise
UNION ALL
SELECT 'worldometer_data'        AS table_name, COUNT(*) AS rows FROM worldometer_data;


-- ============================================================
-- STEP 5: ANALYTICAL QUERIES
-- ============================================================

-- 1. Global death rate trend over time
-- Shows how the virus lethality changed as the pandemic evolved
SELECT
    Date,
    Confirmed,
    Deaths,
    "Deaths / 100 Cases" AS death_rate
FROM day_wise
ORDER BY Date;


-- 2. Top 10 countries by case fatality rate
-- Identifies regions with weakest healthcare response or deadliest strains
SELECT
    "Country/Region",
    Confirmed,
    Deaths,
    "Deaths / 100 Cases" AS fatality_rate
FROM country_wise_latest
ORDER BY "Deaths / 100 Cases" DESC
LIMIT 10;


-- 3. WHO region comparison (cases, deaths, recovery rate)
-- Compares regional pandemic management and resource allocation
SELECT
    "WHO Region",
    SUM(Confirmed)                                                          AS total_cases,
    SUM(Deaths)                                                             AS total_deaths,
    ROUND(SUM(Recovered)::NUMERIC / NULLIF(SUM(Confirmed), 0) * 100, 2)   AS recovery_rate_pct
FROM country_wise_latest
GROUP BY "WHO Region"
ORDER BY total_cases DESC;


-- 4. Countries with fastest week-over-week growth
-- Identifies hotspots requiring immediate intervention
SELECT
    "Country/Region",
    Confirmed,
    "1 week change"     AS weekly_new_cases,
    "1 week % increase" AS weekly_growth_pct
FROM country_wise_latest
WHERE "1 week % increase" IS NOT NULL
ORDER BY "1 week % increase" DESC
LIMIT 10;


-- 5. Testing rate vs death rate (worldometer)
-- Analyzes whether higher testing correlates with lower death rates
SELECT
    "Country/Region",
    Continent,
    Population,
    "Tests/1M pop"  AS testing_rate_per_1m,
    "Deaths/1M pop" AS deaths_per_1m
FROM worldometer_data
WHERE "Tests/1M pop"  IS NOT NULL
  AND "Deaths/1M pop" IS NOT NULL
ORDER BY testing_rate_per_1m DESC;

