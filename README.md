# Restaurant-Ratings-Analysis
 A customer survey was carried out in this city in 2012 to collate information about each restaurant, their cuisines, information about their consumers and the preferences of the consumers. 

## Table of Contents
- [Project Overview](#project-overview)
- [Data Source](#data-source)
- [Tools](#tools)
- [Data Cleaning](#data-cleaning)
- [Data Analysis](#data-analysis)
- [Results](#results)
- [Recommendations](#recommendations)

 ## Project Overview
 This analysis was carried out to discover and analyze customer satisfaction, food quality ratings and overall restaurant ratings to identify areas that need enhancement. We also evaluated the demand and supply gaps between various preferred cuisines and other opportunities within the Mexican restaurant market.
 ![Screenshot 2024-05-25 181207](https://github.com/Judie01/Mexico-Restaurant-Ratings/assets/170753574/9dd4cffe-59de-4df8-a29e-874e6360b59a)

 

## Data Source
The database was provided by Digitaley drive as a part of my capstone project. It consists of five tables which consists of
- Consumer preferences (330 rows and 2 columns)
- Consumers (138 rows and 12 columns)
- Ratings (1161 rows and 5 columns)
- Restaurant cuisines (112 rows and 2 columns)
- Restaurants (130 rows and 11 columns)

## Tools
- SQL Server - This was used to analyze survey data so as to retrieve specific responses, calculate average ratings and efficiently extract valuable insights to evaluate various aspects of restaurant's performance and make data-driven decisions for improvements.
- PowerBI - This was utilized to visualize and interpret survey data effectively by creating an interactive dashboard, to provide a clear and compelling view of the data.

## Data Cleaning
The data cleaning process was employed to ensure data accuracy by handling missing values and inconsistencies. These includes:
- Replaced inconsistent value like 'El RincÃn De San Francisco' was replaced with 'El RincÃn De San Francisco'.
- Columns like longitude and latitude was dropped to concentrate on important factors.
- Missing values were handled using mode imputation, where empty rows were replaced with the mode of the respective column. For instance, the empty rows in the smokers, transportation and budget columnn were replaced with No, public and medium respectively.

## Data Analysis
The data analysis process involved the use of SQL queries to perform various analysis tasks,calculate averages, count responses, retrieve data and manipulating the data to derive meaningful conclusions. For instance, the demand and supply gaps were from consumer preferences analysis(Demand) and restaurant ratings analysis(Supply);
```sql
CREATE table Demand_supply_analysis AS
SELECT 
cp.Preferred_Cuisine,
cp.Preference_count AS Demand,
rc.Restaurant_count AS Supply
FROM(
SELECT Preferred_Cuisine,
COUNT(*) AS Preference_count
FROM consumer_preferences cp
GROUP BY Preferred_Cuisine
)AS cp
LEFT JOIN
(
SELECT Cuisine,
COUNT(*) AS Restaurant_count
FROM restaurant_cuisines rc
GROUP BY Cuisine
) AS rc ON cp.Preferred_Cuisine = rc.Cuisine
ORDER BY cp.Preference_count desc;
```

## Results
- Mexican as the preferred cuisine has the highest demand compared to other cuisines.
- Majority of the consumers live in San-Luis Potosi,and are between the ages of 18-25.
- Majority are single and are on a medium budget.

## Recommendations
- Investing in a restaurant that provides services to categories such as students from 18-25 with medium to low budgets. ﻿Mexican as a preferred cuisine accounted for 49.74% of Demand therefore investing in it will be profitable.
- Since majority of the consumers are students, restaurants should invest more around student areas for a highly lucrative business.










  
















  
