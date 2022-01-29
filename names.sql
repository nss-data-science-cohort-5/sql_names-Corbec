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
LIMIT 1
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
AND name NOT LIKE '_u%'
;

-- There are 46 distinct names that start with 'Q', but do not have 'u' as the second letter.

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

-- From Alex

SELECT COUNT(unisex_counts)*100.00/COUNT(*)
FROM (SELECT CASE WHEN (COUNT( DISTINCT gender)>1) THEN 1 END AS unisex_counts
FROM names
GROUP BY name) AS unisex

	 
-- 10.95% of names are used for both boys and girls




-- 15. How many names have made an appearance in every single year since 1880?


SELECT
	COUNT(*)
FROM (
	SELECT
	name,
	COUNT(DISTINCT(year))
FROM names
GROUP BY 1
HAVING COUNT(DISTINCT(year)) > 138
) AS year_count
;


-- There are 921 names that have appeared in every year since 1880.


-- 16. How many names have only appeared in one year? 

SELECT
	COUNT(*)
FROM (
	SELECT
	name,
	COUNT(DISTINCT(year))
FROM names
GROUP BY 1
HAVING COUNT(DISTINCT(year)) = 1
) AS year_count
;


-- There are 21,123 names appeared only in one year

-- 17. How many names only appeared in the 1950s?

SELECT
	COUNT(distinct_name)
FROM (
	SELECT 
		DISTINCT(name) AS distinct_name,
		MIN(year) AS min_year,
		MAX(year) AS max_year
	FROM names
	GROUP BY 1
) AS start_year
WHERE min_year BETWEEN 1950 AND 1959
AND max_year BETWEEN 1950 AND 1959
;


-- 661 distinct names appeared in the 1950s

-- 18. How many names made their first appearance in the 2010s?

SELECT
	COUNT(distinct_name)
FROM (
	SELECT 
		DISTINCT(name) AS distinct_name,
		MIN(year) AS min_year
	FROM names
	GROUP by 1
) AS start_year
WHERE min_year BETWEEN 2010 AND 2019
;

-- 11,270 names made theis first appearance between 2010 and 2018.

-- 19. Find the names that have not be used in the longest.

SELECT
	distinct_name,
	MIN(max_year) AS last_year
FROM (
	SELECT 
		DISTINCT(name) AS distinct_name,
		MAX(year) AS max_year
	FROM names
	GROUP by 1
) as start_year
GROUP BY 1
ORDER BY 2
LIMIT 2
;

-- Zilpah and Roll are the names that have not been used since 1881.

-- 20. Come up with a question that you would like to answer using this dataset. Then write a query to answer this question.

-- Bonus Questions

-- 1. Find the longest name contained in this dataset. What do you notice about the long names?

SELECT
	name,
	MAX(LENGTH(name))
FROM names
GROUP BY 1
ORDER BY 2 DESC
;

-- The longest names are 15 characters and they are combined names, or perhaps typos where first and middle names were not separated.

-- 2. How many names are palindromes (i.e. read the same backwards and forwards, such as Bob and Elle)?

SELECT
	COUNT(DISTINCT(name))
FROM names
WHERE LOWER(name) = REVERSE(LOWER(name))

-- There are 137 palindrome names

-- 3. Find all names that contain no vowels (for this question, we'll count a,e,i,o,u, and y as vowels). 
--(Hint: you might find this page helpful: https://www.postgresql.org/docs/8.3/functions-matching.html)

select
	name
from names
where name !~ '[AEIOUaeiou]'


-- 4. How many double-letter names show up in the dataset? Double-letter means the same letter repeated back-to-back, like Matthew or Aaron. Are there any triple-letter names?






