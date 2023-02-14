--PROJECT DESCRIPTION
--The international breweries project is based on beverage produced in the company ranging from beer to non-alcoholic drinks for the period of three 
--years (2017-2019). Data was collected on the sales from five different African countries (Nigeria, Ghana, Senegal, Benin, and Togo) and I will be 
--doing some analyses that would aid better decision making in order to maximize profit and reduce loss to the lowest minimum based on these five
--African countries sales. I used a table called “international breweries” in international breweries database

--DESIGN
--For an accurate analysis result, the data ought to be free from all command anomalies, therefore, correct use of command for querying was observed
--during analysis which made our dataset ready and good for analysis for this project and as a result helped us to narrow our insight from the gener
--al dataset. This data has been cleaned in excel but will do some EDA checks to be sure.

--EDA
SELECT *
FROM INTERNATIONAL_BREWERIES --we have 1,047 rows and 13 columns

SELECT *
FROM INTERNATIONAL_BREWERIES
WHERE EMAILS IS NULL --Result shows we have none 

SELECT DISTINCT(EMAILS)
FROM INTERNATIONAL_BREWERIES-- We have 11 distinct email

SELECT DISTINCT(COUNTRIES)
FROM INTERNATIONAL_BREWERIES--Result shows we have 5 distinct countries

SELECT DISTINCT(BRANDS)
FROM INTERNATIONAL_BREWERIES--Result shows we have 7 distinct brands

--FINDINGS
--I will be answering some insightfull business questions for PROFIT ANALYSIS and BRAND ANALYSIS

--PROFIT ANALYSIS
--1.	Within the space of the last three years, what was the profit worth of the breweries, inclusive of the Anglophone and the francophone 
--territories?
--For this question, we need to first understand that “Anglophone” simply mean, English speaking African countries and “Francophone” ,
--French speaking African countries. So we are simply determining the total profit generated across all the countries in the dataset.

SELECT SUM(PROFIT) AS INTERNATIONAL_BREWERIES_TOTAL_PROFIT
FROM INTERNATIONAL_BREWERIES -- total profit for all brands accross the three business year was found to be 105587420

--2.	Compare the total profit between these two territories in order for the territory manager, Mr. Stone to make a strategic decision that will aid
--profit maximization in 2020.

--For us to answer this question, we need to categorize the countries into “Anglophone and Francophone” which I used the case statement. After
--achieving the categorization, I did a subquery to be able to compare the two territories in distinct mode.

SELECT TERRITORIES, SUM(PROFIT) AS PROFIT FROM
       (SELECT
	   CASE WHEN COUNTRIES IN ('NIGERIA','GHANA') THEN 'ANGLOPHONE' ELSE 'FRANCOPHONE'
	   END AS TERRITORIES, SUM(PROFIT) AS PROFIT FROM INTERNATIONAL_BREWERIES
	   GROUP BY COUNTRIES) AS C
WHERE(TERRITORIES = 'ANGLOPHONE' OR TERRITORIES ='FRANCOPHONE')
GROUP BY TERRITORIES
ORDER BY SUM(PROFIT) --profit for Anglophone territories =42389260 and profit for Francophone territories =63198160. clearly, the Francophone territorie
                     --generated more profit compared to the Anglophone territories.

--3.	What country generated the highest profit in 2019

SELECT COUNTRIES, YEARS, SUM(PROFIT) AS PROFIT
FROM INTERNATIONAL_BREWERIES
WHERE YEARS = 2019
GROUP BY COUNTRIES, YEARS
ORDER BY PROFIT DESC

--We want to know the country that generated the highest profit in just 2019, we can clearly see that Ghana generated the highest profit in 2019. 
--I could just add “LIMIT 1” to my query in the “ORDER BY” clause and only Ghana will be retrieved, but because I am passionate about insight, I want
--the manager to be confident of the result by been able to view profit for other countries. Ghana = 7144070, Senegal = 6687560, Togo =6109960 
--Benin = 5273340, Nigeria = 4805320 

--4.	Help him(the manager) find the year with the highest profit.

--The answer to this question, I decided to explore the “OR” condition statement which enabled me to retrieve all the years respectively.
--Then the use of “LIMIT 1” retrieved the year with the highest profit among the three years. 

SELECT YEARS, SUM(PROFIT) AS TOTAL_YEAR_PROFIT
FROM INTERNATIONAL_BREWERIES
WHERE( YEARS = 2017
       OR YEARS = 2018
	   OR YEARS = 2019)
	   GROUP BY YEARS
	   ORDER BY SUM(PROFIT) DESC  --Result shows 2017 generated the highest profit.


--5.	Which month in the three years was the least profit generated?

--The answer to this question is to retrieve the month with the least profit irrespective of the year.

SELECT MONTHS, SUM(PROFIT) AS PROFIT
FROM INTERNATIONAL_BREWERIES
GROUP BY MONTHS, PROFIT
ORDER BY PROFIT --We can see from the result that, December as month has or generated the least profit accross the three years of business.

--6.	Which particular brand generated the highest profit in Senegal?

--This question will answers the most profitable beverage produced by international breweries in Senegal.


SELECT COUNTRIES, BRANDS, SUM(PROFIT) AS PROFIT
FROM INTERNATIONAL_BREWERIES
WHERE COUNTRIES = 'SENEGAL'
GROUP BY COUNTRIES, BRANDS
ORDER BY SUM(PROFIT) DESC --Castle lite as a brand generated the highest profit in senegal

--BRAND ANALYSIS
--1.	Within the last two years, the brand manager wants to know the top three brands consumed in the francophone countries.

--Remember the Francophone countries are those French speaking countries which in our dataset are ‘Senegal, Benin, and Togo’ Let’s explore and
--appreciate the power of the “WHERE” clause.

SELECT BRANDS, SUM(QUANTITY) AS QUANTITY
FROM INTERNATIONAL_BREWERIES
WHERE COUNTRIES IN ('SENEGAL', 'BENIN', 'TOGO') AND YEARS BETWEEN 2018 AND 2019
GROUP BY BRANDS
ORDER BY SUM(QUANTITY) DESC -- Result revealed that trophy,hero, and eagles lager brands in order of heirachy are the 3 most consumed brands in
                            --the francophone countries.

--2.	Find out the top two choice of consumer brands in Ghana

--Here we want to find out which brands made the highest two brands sales in Ghana. In the “GROUP BY” clause, I could just group by brands and  be 
--good, but we can be more explicit right? So let’s also group by country in case the manager is not a professional analyst.


SELECT COUNTRIES, BRANDS, SUM(QUANTITY) AS QUANTITY
FROM INTERNATIONAL_BREWERIES
WHERE COUNTRIES = 'GHANA'
GROUP BY COUNTRIES, BRANDS
ORDER BY SUM(QUANTITY) DESC --eagle lager and castle lite are the two top choice of condumer brands in ghana

--3.	Favorites malt brand in Anglophone region between 2018 and 2019.

--Remember the Anglophone region comprises of the two countries ‘Nigeria, and Ghana’ in our dataset, so we are going to find out the most 
--non-alcoholic brand sales for the last two years (2018 and 2019)

SELECT BRANDS, SUM(QUANTITY) AS QUANTITY
FROM INTERNATIONAL_BREWERIES
WHERE COUNTRIES IN('NIGERIA','GHANA') AND YEARS IN (2018,2019)
AND BRANDS LIKE '%MALT'
GROUP BY BRANDS
ORDER BY SUM(QUANTITY)DESC --Grand malt is the Favorites malt brand in Anglophone region between 2018 and 2019.


--4.	Which brands sold the highest in 2019 in Nigeria?

--The minimum result to retrieve here is two because the question read brands and not brand.

SELECT BRANDS, SUM(QUANTITY) AS QUANTITY
FROM INTERNATIONAL_BREWERIES
WHERE COUNTRIES = 'NIGERIA' AND YEARS = 2019
GROUP BY BRANDS
ORDER BY SUM(QUANTITY) DESC -- Hero and eagle lager are the brads that sold more in 2019 in Nigeria


--5.	Beer consumption in Nigeria.

--Here, we want to know the total beer(Budweiser+ castle lite + eagle lager + hero + trophy) consumed in Nigeria .

SELECT SUM(QUANTITY) AS TOTAL_QUANTITY
FROM INTERNATIONAL_BREWERIES
WHERE COUNTRIES = 'NIGERIA' AND BRANDS  NOT LIKE '%MALT' --129260 quantity of beer was consumed in Nigeria in the 3 business successful year.










