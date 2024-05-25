CREATE DATABASE Capstone2;
CREATE TABLE consumers(
Consumer_ID VARCHAR(255) PRIMARY KEY,
City VARCHAR (255) NOT NULL,
State  VARCHAR (255) NOT NULL,
Country VARCHAR (255) NOT NULL,
Longitude BIGINT,
Latitude BIGINT,
Smokers VARCHAR (255) NOT NULL,
Drink_Level VARCHAR (255) NOT NULL,
Transportation_Method VARCHAR (255) NOT NULL,
Martial_Status VARCHAR (255) NOT NULL,
Children VARCHAR (255) NOT NULL,
Age INT NOT NULL,
Occupation VARCHAR (255) NOT NULL,
Budget VARCHAR (255) NOT NULL
);

CREATE TABLE consumer_preferences(
Consumer_ID VARCHAR(255),
Preferred_Cuisine VARCHAR (255) NOT NULL,
FOREIGN KEY (Consumer_ID)REFERENCES consumers(Consumer_ID)
);

CREATE TABLE ratings(
Restaurant_ID INT PRIMARY KEY,
Overall_Rating INT NOT NULL,
Food_Rating INT NOT NULL,
Service_Rating INT NOT NULL,
Consumer_ID VARCHAR(255),
FOREIGN KEY (Consumer_ID) REFERENCES consumers(Consumer_ID)
);

CREATE TABLE restaurant_cuisines(
Cuisine VARCHAR (255) NOT NULL,
Restaurant_ID INT,
FOREIGN KEY (Restaurant_ID) REFERENCES ratings(Restaurant_ID)
);

CREATE TABLE restaurants(
Name VARCHAR (255) NOT NULL,
City VARCHAR (255) NOT NULL,
State VARCHAR (255) NOT NULL,
Country VARCHAR (255) NOT NULL,
Zip_Code BIGINT not null,
Latitude BIGINT,
Longitude BIGINT,
Alcohol_Service VARCHAR (255) NOT NULL,
Smoking_Allowed VARCHAR (255) NOT NULL,
Price VARCHAR (255) NOT NULL,
Franchise VARCHAR (255) NOT NULL,
Area VARCHAR (255) NOT NULL,
Parking VARCHAR (255) NOT NULL,
Restaurant_ID INT,
FOREIGN KEY (Restaurant_ID) REFERENCES ratings(Restaurant_ID)
);

ALTER Table consumers
DROP Longitude;

ALTER Table consumers
DROP Latitude;

-- HIGHEST RATED RESTAURANTS
SELECT
r.Name AS Resturant_Name,
AVG(ra.overall_rating) AS Avg_overall_rating,
AVG(ra.food_rating) AS Avg_food_rating,
AVG(ra.service_rating) AS Avg_service_rating
FROM restaurants r
INNER JOIN 
ratings ra ON ra.Restaurant_ID = r.Restaurant_ID
INNER JOIN
restaurant_cuisines rc ON rc.Restaurant_ID = r.Restaurant_ID
GROUP BY ra.Restaurant_ID, r.Name
ORDER BY Avg_food_rating desc, Avg_overall_rating desc;

-- EVALUATING HIGHEST RATED RESTAURANTS
SELECT
r.Name AS Restaurant_Name,
rc.Cuisine,
r.Price,
r.City,
r.Alcohol_Service,
r.Smoking_Allowed,
r.Parking,
r.Area,
AVG(ra.overall_rating) AS Avg_overall_rating,
AVG(ra.food_rating) AS Avg_food_rating,
AVG(ra.service_rating) AS Avg_service_rating
FROM restaurants r
INNER JOIN 
ratings ra ON ra.Restaurant_ID = r.Restaurant_ID
INNER JOIN
restaurant_cuisines rc ON rc.Restaurant_ID = r.Restaurant_ID
GROUP BY ra.Restaurant_ID, r.Name, rc.Cuisine, r.Price, r.City, r.Alcohol_Service, r.Smoking_Allowed, r.Parking, r.Area
ORDER BY Avg_food_rating desc, Avg_overall_rating desc;

-- CONSUMER DEMOGRAPHICS
-- BY CITY
SELECT City,
COUNT(*) AS consumer_count,
COUNT(City) / (SELECT COUNT(*) FROM consumers) * 100 AS perc_consumers
FROM consumers
GROUP BY City
ORDER BY consumer_count desc;

-- BY STATE
SELECT State,
COUNT(*) AS consumer_count,
COUNT(State) / (SELECT COUNT(*) FROM consumers) * 100 AS perc_consumers
FROM consumers
GROUP BY State
ORDER BY consumer_count desc;

-- BY COUNTRY
SELECT Country,
COUNT(*) AS consumer_count,
COUNT(Country) / (SELECT COUNT(*) FROM consumers) * 100 AS perc_consumers
FROM consumers
GROUP BY Country
ORDER BY consumer_count desc;

-- BY SMOKERS
SELECT Smokers,
COUNT(*) AS consumer_count,
COUNT(Smokers) / (SELECT COUNT(*) FROM consumers) * 100 AS perc_consumers
FROM consumers
GROUP BY Smokers
ORDER BY consumer_count desc;

-- BY DRINK LEVEL
SELECT Drink_Level,
COUNT(*) AS consumer_count,
COUNT(Drink_Level) / (SELECT COUNT(*) FROM consumers) * 100 AS perc_consumers
FROM consumers
GROUP BY Drink_Level
ORDER BY consumer_count desc;

-- BY TRANSPORTATION METHOD
SELECT Transportation_Method,
COUNT(*) AS consumer_count,
COUNT(Transportation_Method) / (SELECT COUNT(*) FROM consumers) * 100 AS perc_consumers
FROM consumers
GROUP BY Transportation_Method
ORDER BY consumer_count desc;

-- BY MARTIAL STATUS
SELECT Martial_Status,
COUNT(*) AS consumer_count,
COUNT(Martial_Status) / (SELECT COUNT(*) FROM consumers) * 100 AS perc_consumers
FROM consumers
GROUP BY Martial_Status
ORDER BY consumer_count desc;

-- BY CHILDREN
SELECT Children,
COUNT(*) AS consumer_count,
COUNT(Children) / (SELECT COUNT(*) FROM consumers) * 100 AS perc_consumers
FROM consumers
GROUP BY Children
ORDER BY consumer_count desc;

-- BY AGE
SELECT
CASE
WHEN Age BETWEEN 18 AND 25 THEN 'Young Adults'
WHEN Age BETWEEN 26 AND 35 THEN 'Adults'
WHEN Age BETWEEN 36 AND 45 THEN 'Middle Aged'
WHEN Age BETWEEN 46 and 55 THEN 'Mature Adults'
WHEN Age BETWEEN 56 AND 65 THEN 'Senior Citizens'
ELSE 'Elderly'
END AS Age_group,
COUNT(*) AS consumer_count,
COUNT(CASE
WHEN Age BETWEEN 18 AND 25 THEN 'Young Adults'
WHEN Age BETWEEN 26 AND 35 THEN 'Adults'
WHEN Age BETWEEN 36 AND 45 THEN 'Middle Aged'
WHEN Age BETWEEN 46 and 55 THEN 'Mature Adults'
WHEN Age BETWEEN 56 AND 65 THEN 'Senior Citizens'
ELSE 'Elderly'
END) /(SELECT COUNT(*) FROM consumers) * 100 AS perc_consumers
FROM consumers
GROUP BY Age_group
ORDER BY consumer_count desc;

-- BY OCCUPATION
SELECT Occupation,
COUNT(*) AS consumer_count,
COUNT(Occupation) / (SELECT COUNT(*) FROM consumers) * 100 AS perc_consumers
FROM consumers
GROUP BY Occupation
ORDER BY consumer_count desc;

-- BY BUDGET
SELECT Budget,
COUNT(*) AS consumer_count,
COUNT(Budget) / (SELECT COUNT(*) FROM consumers) * 100 AS perc_consumers
FROM consumers
GROUP BY Budget
ORDER BY consumer_count desc;

-- DEMAND AND SUPPLY
-- CONSUMER PREFERENCES FOR CUISINE TYPE FOR THE DEMAND AND SUPPLY GAP
-- Consumer preferences for cuisine types
SELECT Preferred_Cuisine,
COUNT(*) AS Preference_count
FROM consumer_preferences
GROUP BY Preferred_Cuisine
ORDER BY Preference_count desc;

-- Restaurant ratings by cuisine type
SELECT
rc.Cuisine,
AVG(ra.overall_rating) AS Avg_overall_rating,
AVG(ra.food_rating) AS Avg_food_rating
FROM ratings ra
INNER JOIN
restaurants r ON ra.Restaurant_ID = r.Restaurant_ID
INNER JOIN
restaurant_cuisines rc ON r.Restaurant_ID = ra.Restaurant_ID
GROUP BY rc.Cuisine
ORDER BY Avg_food_rating desc;

-- Combine consumer preferences analysis(Demand) and restaurant ratings analysis(Supply)
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

SELECT*
FROM demand_supply_analysis;

-- NUMBER OF RESTAURANTS IN EACH LOCATION
SELECT City,
COUNT(*) AS Restaurant_count
FROM restaurants
GROUP BY City
ORDER BY Restaurant_count desc;
















