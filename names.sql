-- 1. How many rows are in the names table?

SELECT
	COUNT(*)
FROM names
;

-- 1,957,046 rows

-- 2. How many total registered people appear in the dataset?

SELECT
	SUM(num_registered)
FROM names
;

-- 351,165,025 people are in the dataset

-- 3. Which name had the most appearances in a single year in the dataset?

SELECT
	name
FROM names
WHERE num_registered = (SELECT MAX(num_registered) FROM names)
;

-- Linda was the name with the most apprearances

-- 4. What range of years are included?

SELECT
	MIN(year),
	MAX(year)
FROM names
;

-- The years range from 1880 to 2018

-- 5. What year has the largest number of registrations?

SELECT
	year,
	SUM(num_registered) AS registered
FROM names
GROUP BY 1
ORDER BY 2 DESC
;

-- 1957 was the year with the most registrations

-- 6. How many different (distinct) names are contained in the dataset?

SELECT
	COUNT(DISTINCT(name))
FROM names
;

-- There are 98,400 distinct names in the dataset

-- 7. Are there more males or more females registered?

SELECT
	gender,
	SUM(num_registered) AS registered
FROM names
GROUP BY 1
ORDER BY 2 DESC
;

-- There are more males than females registered

-- 8. What are the most popular male and female names overall (i.e., the most total registrations)?

SELECT
	name,
	gender,
	SUM(num_registered) AS registered
FROM names
GROUP BY 1,2
ORDER BY 3 DESC
;

-- James is the most popular male name, Mary is the most popular female name.

-- 9. What are the most popular boy and girl names of the first decade of the 2000s (2000 - 2009)?

SELECT
	name,
	gender,
	SUM(num_registered) AS registered
FROM names
WHERE year BETWEEN 2000 AND 2009
GROUP BY 1,2
ORDER BY 3 DESC
;

-- Jacob is the most popular male name and Emily is the most popular female name between 2000 and 2009

-- 10. Which year had the most variety in names (i.e. had the most distinct names)?

SELECT
	year,
	COUNT(DISTINCT(name)) AS name_count
FROM names
GROUP BY 1
ORDER BY 2 DESC
;

-- 2008 had the most vareity in names with 32,518 names

-- 11. What is the most popular name for a girl that starts with the letter X?

SELECT
	name,
	SUM(num_registered) AS registered
FROM names
WHERE name LIKE 'X%'
AND gender = 'F'
GROUP BY 1
ORDER BY 2 DESC
;

-- Ximena is the most popuar girl's name that starts with an X

-- 12. How many distinct names appear that start with a 'Q', but whose second letter is not 'u'?

SELECT
	COUNT(DISTINCT(name)) AS count_distinct_names
FROM names
WHERE name LIKE 'Q%'
AND name NOT LIKE '%u%'
;

-- There are 45 distinct names that start with 'Q', but do not have 'u' as the second letter.

-- 13. Which is the more popular spelling between "Stephen" and "Steven"? Use a single query to answer this question.

SELECT
	name,
	SUM(num_registered) AS registered
FROM names
WHERE name = 'Stephen'
OR name = 'Steven'
GROUP BY 1
ORDER BY 2 DESC
;

-- Steven is the more popular spelling with 1,286,951 'Stevens' versus 860,972 'Stephens'.

-- 14. What percentage of names are "unisex" - that is what percentage of names have been used both for boys and for girls?

WITH male AS (SELECT
	 		DISTINCT(name) AS distinct_name
	  FROM names
	  WHERE gender = 'M'
	 ),
	 
	 female AS (SELECT
				DISTINCT(name) AS distinct_name
			FROM names
			WHERE gender = 'F'
)

SELECT
	(COUNT(DISTINCT(f.distinct_name))::float / (SELECT COUNT(DISTINCT(name)) FROM names)) * 100
FROM female f
JOIN male m ON f.distinct_name = m.distinct_name
;
	 
-- 10.95% of names are used for both boys and girls




-- 15. How many names have made an appearance in every single year since 1880?

SELECT
	COUNT(DISTINCT(name)),
	COUNT(year)/2 AS count_year
FROM names
ORDER BY 2 DESC
;

-- There are 15 names that have appeared in every year since 1880.


-- 16. How many names have only appeared in one year?

SELECT
	DISTINCT(name),
	COUNT(year) AS year_count
FROM names
GROUP BY 1
ORDER BY 2
;


-- 17. How many names only appeared in the 1950s?

select
	count(distinct(name))
from names
where year between 1950 and 1959



-- 18. How many names made their first appearance in the 2010s?



-- 19. Find the names that have not be used in the longest.




-- 20. Come up with a question that you would like to answer using this dataset. Then write a query to answer this question.