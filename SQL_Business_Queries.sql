/* 
==========================================================
Project Title: Video Game Sales Analytics using SQL
Author: Muskan Bhardwaj
Description:
This project focuses on data cleaning, integration, 
and analytical querying of video game sales data.
The goal is to prepare structured data for Power BI 
dashboard visualization and business insights.
==========================================================
*/


/* ======================================================
   SECTION 1: Database Creation & Setup
====================================================== */
CREATE DATABASE VideoGameAnalytics;
GO
USE VideoGameAnalytics;
GO


/* ======================================================
   SECTION 2: Table Creation
====================================================== */

--Creating Games Table
CREATE TABLE games (
    game_id INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(255),
    release_year INT,
    primary_genre NVARCHAR(100),
    team NVARCHAR(255),
    rating FLOAT,
    plays INT,
    wishlist INT,
    backlogs INT
);

--Creating Sales Table
CREATE TABLE sales (
    sale_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255),
    platform NVARCHAR(50),
    year INT,
    genre NVARCHAR(100),
    publisher NVARCHAR(255),
    na_sales FLOAT,
    eu_sales FLOAT,
    jp_sales FLOAT,
    other_sales FLOAT,
    global_sales FLOAT
);


/* ======================================================
   SECTION 3: Data Validation & Row Count Checks
====================================================== */

--Checking Null Values
SELECT COUNT(*) AS total_rows
FROM dbo.cleaned_games;
SELECT *
FROM dbo.cleaned_games
WHERE Release_Date IS NULL;

--Total Rows in Each Dataset
SELECT COUNT(*) AS games_rows FROM dbo.cleaned_games;
SELECT COUNT(*) AS sales_rows FROM dbo.cleaned_sales;


/* ======================================================
   SECTION 4: Top Performing Games
====================================================== */

-- Top 10 games by Global Sales
SELECT TOP 10
    g.Title,
    g.Genres,
    s.Platform,
    SUM(s.Global_Sales) AS Total_Global_Sales
FROM dbo.cleaned_games g
JOIN dbo.cleaned_sales s
    ON LOWER(g.Title) = LOWER(s.Name)
GROUP BY g.Title, g.Genres, s.Platform
ORDER BY Total_Global_Sales DESC;


/* ======================================================
   SECTION 5: Platform Performance Analysis
====================================================== */

SELECT
    Platform,
    SUM(Global_Sales) AS Platform_Global_Sales
FROM dbo.cleaned_sales
GROUP BY Platform
ORDER BY Platform_Global_Sales DESC;


/* ======================================================
   SECTION 6: Genre Performance Analysis
====================================================== */

SELECT
    g.Primary_Genre,
    SUM(s.Global_Sales) AS Genre_Global_Sales
FROM dbo.cleaned_games g
JOIN dbo.cleaned_sales s
    ON LOWER(g.Title) = LOWER(s.Name)
GROUP BY g.Primary_Genre
ORDER BY Genre_Global_Sales DESC;


/* ======================================================
   SECTION 7: Yearly Sales Trend
====================================================== */

SELECT
    s.Year,
    SUM(s.Global_Sales) AS Yearly_Global_Sales
FROM dbo.cleaned_sales s
GROUP BY s.Year
ORDER BY s.Year;


/* ======================================================
   SECTION 8: Regional Sales Breakdown
====================================================== */

SELECT
    SUM(NA_Sales) AS NA,
    SUM(EU_Sales) AS EU,
    SUM(JP_Sales) AS JP,
    SUM(Other_Sales) AS Other_Regions
FROM dbo.cleaned_sales;


/* ======================================================
   SECTION 9: Creating Unified Analytical View
====================================================== */

CREATE OR ALTER VIEW vw_game_sales AS
SELECT
    g.Title,
    REPLACE(REPLACE(g.Genres, '[', ''), ']', '') AS Primary_Genre,
    g.Release_Date,
    g.Rating,
    s.Platform,
    s.Year,
    s.Publisher,
    s.NA_Sales,
    s.EU_Sales,
    s.JP_Sales,
    s.Other_Sales,
    s.Global_Sales
FROM dbo.cleaned_games g
JOIN dbo.cleaned_sales s
ON LOWER(g.Title) = LOWER(s.Name);

