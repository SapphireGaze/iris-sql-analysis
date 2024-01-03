-- query for number of rows
SELECT COUNT(*) AS number_of_rows FROM public.iris;

-- query for number of columns
SELECT COUNT(*) AS number_of_columns FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 'iris';

-- query for name and data type of each column
SELECT column_name, data_type FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 'iris';

-- query for rows with NULL values
SELECT * FROM public.iris
WHERE (sepal_length, sepal_width, petal_length, petal_width) IS NULL;

-- replace sepal_length with sepal_width/petal_length/petal_width for summary statistics of other columns
WITH values AS (
	SELECT
		ROUND(AVG(sepal_length)::NUMERIC, 2) AS mean,
		ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY sepal_length)::NUMERIC, 2) AS median,
		ROUND(MODE() WITHIN GROUP (ORDER BY sepal_length)::NUMERIC, 2) AS mode,
		ROUND(MIN(sepal_length)::NUMERIC, 2) AS minimum,
		ROUND(MAX(sepal_length)::NUMERIC, 2) AS maximum,
		ROUND(STDDEV(sepal_length)::NUMERIC, 2) AS standard_deviation,
		ROUND(VARIANCE(sepal_length)::NUMERIC, 2) AS variance,
		ROUND(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY sepal_length)::NUMERIC, 2) AS q1,
		ROUND(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY sepal_length)::NUMERIC, 2) AS q3
	FROM public.iris
), combined_table AS (
	SELECT 1 AS sno, 'mean' AS statistic, mean AS value FROM values
	UNION ALL
	SELECT 2 AS sno, 'median' AS statistic, median AS value FROM values
	UNION ALL
	SELECT 3 AS sno, 'mode' AS statistic, mode AS value FROM values
	UNION ALL
	SELECT 4 AS sno, 'minimum' AS statistic, minimum AS value FROM values
	UNION ALL
	SELECT 5 AS sno, 'maximum' AS statistic, maximum AS value FROM values
	UNION ALL
	SELECT 6 AS sno, 'range' AS statistic, maximum - minimum AS value FROM values
	UNION ALL
	SELECT 7 AS sno, 'standard deviation' AS statistic, standard_deviation AS value FROM values
	UNION ALL
	SELECT 8 AS sno, 'variance' AS statistic, variance AS value FROM values
	UNION ALL
	SELECT 9 AS sno, 'Q1' AS statistic, q1 AS value FROM values
	UNION ALL
	SELECT 10 AS sno, 'Q3' AS statistic, q3 AS value FROM values
	UNION ALL
	SELECT 11 AS sno, 'IQR' AS statistic, q3 - q1 AS value FROM values
	UNION ALL
	SELECT 12 AS sno, 'skewness' AS statistic, ROUND(3 * (mean - median) / standard_deviation, 2) AS value FROM values
)

-- query for summary statistics of chosen column
SELECT * FROM combined_table;