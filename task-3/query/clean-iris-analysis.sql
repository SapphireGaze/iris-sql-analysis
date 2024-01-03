-- Delete all rows containing null values (no rows contain null values)
DELETE FROM public.iris
WHERE (sepal_length, sepal_width, petal_length, petal_width, species) IS NULL;

-- All current rows and columns apply to analysis

-- All columns are already named for simplicity

-- There is no way to merge or split data for ease of use

-- Convert data to more convenient format (convert REAL datatype to NUMERIC)
ALTER TABLE public.iris
	ALTER COLUMN sepal_length TYPE NUMERIC,
	ALTER COLUMN sepal_width TYPE NUMERIC,
	ALTER COLUMN petal_length TYPE NUMERIC,
	ALTER COLUMN petal_width TYPE NUMERIC;

-- Analysis on skewness based on data grouped by 'species' to determine if the distribution is affected by the species
SELECT 
	species,
	ROUND(3 * (ROUND(AVG(sepal_length), 2) - ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY sepal_length)::NUMERIC, 2)) / ROUND(STDDEV(sepal_length), 2), 2) AS sepal_length_avg,
	ROUND(3 * (ROUND(AVG(sepal_width), 2) - ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY sepal_width)::NUMERIC, 2)) / ROUND(STDDEV(sepal_width), 2), 2) AS sepal_width_avg,
	ROUND(3 * (ROUND(AVG(petal_length), 2) - ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY petal_length)::NUMERIC, 2)) / ROUND(STDDEV(petal_length), 2), 2) AS petal_length_avg,
	ROUND(3 * (ROUND(AVG(petal_width), 2) - ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY petal_width)::NUMERIC, 2)) / ROUND(STDDEV(petal_width), 2), 2) AS petal_width_avg
FROM public.iris
GROUP BY species;

-- Descriptive analysis of Iris-setosa using queries from previous task 
WITH values AS (
	SELECT
		ROUND(AVG(sepal_length), 2) AS sl_mean,
		ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY sepal_length)::NUMERIC, 2) AS sl_median,
		ROUND(MODE() WITHIN GROUP (ORDER BY sepal_length), 2) AS sl_mode,
		ROUND(MIN(sepal_length), 2) AS sl_minimum,
		ROUND(MAX(sepal_length), 2) AS sl_maximum,
		ROUND(STDDEV(sepal_length), 2) AS sl_standard_deviation,
		ROUND(VARIANCE(sepal_length), 2) AS sl_variance,
		ROUND(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY sepal_length)::NUMERIC, 2) AS sl_q1,
		ROUND(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY sepal_length)::NUMERIC, 2) AS sl_q3,
		ROUND(AVG(sepal_width), 2) AS sw_mean,
		ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY sepal_width)::NUMERIC, 2) AS sw_median,
		ROUND(MODE() WITHIN GROUP (ORDER BY sepal_width), 2) AS sw_mode,
		ROUND(MIN(sepal_width), 2) AS sw_minimum,
		ROUND(MAX(sepal_width), 2) AS sw_maximum,
		ROUND(STDDEV(sepal_width), 2) AS sw_standard_deviation,
		ROUND(VARIANCE(sepal_width), 2) AS sw_variance,
		ROUND(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY sepal_width)::NUMERIC, 2) AS sw_q1,
		ROUND(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY sepal_width)::NUMERIC, 2) AS sw_q3,
		ROUND(AVG(petal_length), 2) AS pl_mean,
		ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY petal_length)::NUMERIC, 2) AS pl_median,
		ROUND(MODE() WITHIN GROUP (ORDER BY petal_length), 2) AS pl_mode,
		ROUND(MIN(petal_length), 2) AS pl_minimum,
		ROUND(MAX(petal_length), 2) AS pl_maximum,
		ROUND(STDDEV(petal_length), 2) AS pl_standard_deviation,
		ROUND(VARIANCE(petal_length), 2) AS pl_variance,
		ROUND(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY petal_length)::NUMERIC, 2) AS pl_q1,
		ROUND(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY petal_length)::NUMERIC, 2) AS pl_q3,
		ROUND(AVG(petal_width), 2) AS pw_mean,
		ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY petal_width)::NUMERIC, 2) AS pw_median,
		ROUND(MODE() WITHIN GROUP (ORDER BY petal_width), 2) AS pw_mode,
		ROUND(MIN(petal_width), 2) AS pw_minimum,
		ROUND(MAX(petal_width), 2) AS pw_maximum,
		ROUND(STDDEV(petal_width), 2) AS pw_standard_deviation,
		ROUND(VARIANCE(petal_width), 2) AS pw_variance,
		ROUND(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY petal_width)::NUMERIC, 2) AS pw_q1,
		ROUND(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY petal_width)::NUMERIC, 2) AS pw_q3
	FROM public.iris
	WHERE species = 'Iris-setosa'
), combined_table AS (
	SELECT 1 AS sno, 'mean' AS statistic, sl_mean AS sepal_length, sw_mean AS sepal_width, pl_mean AS petal_length, pw_mean AS petal_width FROM values
	UNION ALL
	SELECT 2 AS sno, 'median' AS statistic, sl_median AS sepal_length, sw_median AS sepal_width, pl_median AS petal_length, pw_median AS petal_width FROM values
	UNION ALL
	SELECT 3 AS sno, 'mode' AS statistic, sl_mode AS sepal_length, sw_mode AS sepal_width, pl_mode AS petal_length, pw_mode AS petal_width FROM values
	UNION ALL
	SELECT 4 AS sno, 'minimum' AS statistic, sl_minimum AS sepal_length, sw_minimum AS sepal_width, pl_minimum AS petal_length, pw_minimum AS petal_width FROM values
	UNION ALL
	SELECT 5 AS sno, 'maximum' AS statistic, sl_maximum AS sepal_length, sw_maximum AS sepal_width, pl_maximum AS petal_length, pw_maximum AS petal_width FROM values
	UNION ALL
	SELECT 6 AS sno, 'range' AS statistic, sl_maximum - sl_minimum AS sepal_length, sw_maximum - sw_minimum AS sepal_width, pl_maximum - pl_minimum AS petal_length, pw_maximum - pw_minimum AS petal_width FROM values
	UNION ALL
	SELECT 7 AS sno, 'standard deviation' AS statistic, sl_standard_deviation AS sepal_length, sw_standard_deviation AS sepal_width, pl_standard_deviation AS petal_length, pw_standard_deviation AS petal_width FROM values
	UNION ALL
	SELECT 8 AS sno, 'variance' AS statistic, sl_variance AS sepal_length, sw_variance AS sepal_width, pl_variance AS petal_length, pw_variance AS petal_width FROM values
	UNION ALL
	SELECT 9 AS sno, 'Q1' AS statistic, sl_q1 AS sepal_length, sw_q1 AS sepal_width, pl_q1 AS petal_length, pw_q1 AS petal_width FROM values
	UNION ALL
	SELECT 10 AS sno, 'Q3' AS statistic, sl_q3 AS sepal_length, sw_q3 AS sepal_width, pl_q3 AS petal_length, pw_q3 AS petal_width FROM values
	UNION ALL
	SELECT 11 AS sno, 'IQR' AS statistic, sl_q3 - sl_q1 AS sepal_length, sw_q3 - sw_q1 AS sepal_width, pl_q3 - pl_q1 AS petal_length, pw_q3 - pw_q1 AS petal_width FROM values
	UNION ALL
	SELECT 12 AS sno, 'skewness' AS statistic, ROUND(3 * (sl_mean - sl_median) / sl_standard_deviation, 2) AS sepal_length, ROUND(3 * (sw_mean - sw_median) / sw_standard_deviation, 2) AS sepal_width, ROUND(3 * (pl_mean - pl_median) / pl_standard_deviation, 2) AS petal_length, ROUND(3 * (pw_mean - pw_median) / pw_standard_deviation, 2) AS petal_width FROM values
)

-- Query for summary statistics of chosen column
SELECT * FROM combined_table;

-- Query for displaying cleaned table
SELECT * FROM public.iris;

-- Analysis on skewness based on data grouped by 'species' to determine if the distribution is affected by the species
SELECT 
	species,
	ROUND(3 * (ROUND(AVG(sepal_length), 2) - ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY sepal_length)::NUMERIC, 2)) / ROUND(STDDEV(sepal_length), 2), 2) AS sepal_length_skewness,
	ROUND(3 * (ROUND(AVG(sepal_width), 2) - ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY sepal_width)::NUMERIC, 2)) / ROUND(STDDEV(sepal_width), 2), 2) AS sepal_width_skewness,
	ROUND(3 * (ROUND(AVG(petal_length), 2) - ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY petal_length)::NUMERIC, 2)) / ROUND(STDDEV(petal_length), 2), 2) AS petal_length_skewness,
	ROUND(3 * (ROUND(AVG(petal_width), 2) - ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY petal_width)::NUMERIC, 2)) / ROUND(STDDEV(petal_width), 2), 2) AS petal_width_skewness
FROM public.iris
GROUP BY species;