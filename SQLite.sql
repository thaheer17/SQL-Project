CREATE TABLE appleStore_description_combined AS
SELECT * FROM appleStore_description1
UNION ALL
SELECT * FROM appleStore_description2
UNION ALL
SELECT * FROM appleStore_description3
UNION ALL
SELECT * FROM appleStore_description4

**Exploratory Data Analysis(EDA)
--Check the number of unique apps in both tables
SELECT COUNT(DISTINCT id) AS uniqueAppIDs
FROM AppleStore

SELECT COUNT(DISTINCT id) AS uniqueAppIDs
FROM appleStore_description_combined

--Check for any missing values in key fields
Select COUNT(*) AS MissingValues
FROM AppleStore
WHERE track_name IS NULL OR user_rating IS NULL or prime_genre IS NULL

Select COUNT(*) AS MissingValues
FROM appleStore_description_combined
WHERE app_desc IS NULL

--Findout the number of apps per genre
SELECT prime_genre, COUNT(*) AS NumApps
FROM AppleStore
GROUP BY prime_genre
Order BY NumApps DESC

--Gen an overview of apps ratings
SELECT MIN(user_rating) AS MinRating,
       MAX(user_rating) AS MaxRating,
       AVG(user_rating) AS AvgRating
FROM AppleStore
       
*Finding the insights-Data Analysis*
--To Check if paid apps have higher rating than free apps
SELECT CASE 
       WHEN price>0 then 'paid'
       ELSE 'free'
       END AS App_Type,
       AVG(user_rating) AS Avg_Rating
FROM AppleStore
GROUP BY App_Type

--To Check if apps with more supporting languages have higher rating
SELECT CASE
       WHEN lang_num <10 THEN '<10 Languages'
       WHEN lang_num BETWEEN 10 and 30 THEN '10-30 Languages'
       ELSE '>30 Languages'
       END AS language_bucket,
       AVG(user_rating) AS Avg_Rating
FROM AppleStore
GROUP By language_bucket
ORder by Avg_Rating DESC

--Check genres with low ratings
SELECT prime_genre,
       AVG(user_rating) AS Avg_Rating
FROM AppleStore
GROUP By prime_genre
ORder by Avg_Rating ASC
LIMIT 10

--Check if there is correlation between the length of the app descrition and the user rating
SELECT CASE
       WHEN length(b.app_desc) <500 THEN 'Short'
       WHEN length(b.app_desc) BETWEEN 500 and 1000 THEN 'Medium'
       ELSE 'Long'
       END As description_length_bucket,
       AVG(user_rating) AS Avg_Rating
FROM AppleStore AS A
JOIN appleStore_description_combined AS B
ON a.id=b.id
GROUP BY description_length_bucket
ORDER BY Avg_Rating DESC

--Top Rated Apps for each genre
SELECT prime_genre,
       track_name,
       user_rating
FROM (SELECT 
       prime_genre,
       track_name,
       user_rating,
       RANK() OVER(PARTITIOn BY prime_genre order BY user_rating DESC,rating_count_tot DESC) AS rank
      FROM AppleStore) AS A
WHERE a.rank=1

*Final Recommendations*
1. Paid Apps have better ratings.
2. Apps supporting between 10-30 languages have better ratings.
3. Finance and book apps have low ratings.
4. Apps with longer description have better ratings.
5. A new app should aim for an average rating of 3.5
6. Games and Entertaining category have high competition.
