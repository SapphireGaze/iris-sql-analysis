-- remove strong outliers from each of the columns
DELETE FROM public.iris
WHERE sepal_length < (SELECT ROUND(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY sepal_length)::NUMERIC, 2) -
					 	(3 * (ROUND(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY sepal_length)::NUMERIC, 2) -
							 ROUND(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY sepal_length)::NUMERIC, 2)))
					 FROM public.iris) 
	OR sepal_length > (SELECT ROUND(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY sepal_length)::NUMERIC, 2) +
					 	(3 * (ROUND(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY sepal_length)::NUMERIC, 2) -
							 ROUND(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY sepal_length)::NUMERIC, 2)))
					  FROM public.iris);

DELETE FROM public.iris
WHERE sepal_width < (SELECT ROUND(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY sepal_width)::NUMERIC, 2) -
					 	(3 * (ROUND(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY sepal_width)::NUMERIC, 2) -
							 ROUND(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY sepal_width)::NUMERIC, 2)))
					 FROM public.iris) 
	OR sepal_width > (SELECT ROUND(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY sepal_width)::NUMERIC, 2) +
					 	(3 * (ROUND(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY sepal_width)::NUMERIC, 2) -
							 ROUND(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY sepal_width)::NUMERIC, 2)))
					  FROM public.iris);
					  
DELETE FROM public.iris
WHERE petal_length < (SELECT ROUND(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY petal_length)::NUMERIC, 2) -
					 	(3 * (ROUND(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY petal_length)::NUMERIC, 2) -
							 ROUND(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY petal_length)::NUMERIC, 2)))
					 FROM public.iris) 
	OR petal_length > (SELECT ROUND(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY petal_length)::NUMERIC, 2) +
					 	(3 * (ROUND(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY petal_length)::NUMERIC, 2) -
							 ROUND(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY petal_length)::NUMERIC, 2)))
					  FROM public.iris);
					  
DELETE FROM public.iris
WHERE petal_width < (SELECT ROUND(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY petal_width)::NUMERIC, 2) -
					 	(3 * (ROUND(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY petal_width)::NUMERIC, 2) -
							 ROUND(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY petal_width)::NUMERIC, 2)))
					 FROM public.iris) 
	OR petal_width > (SELECT ROUND(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY petal_width)::NUMERIC, 2) +
					 	(3 * (ROUND(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY petal_width)::NUMERIC, 2) -
							 ROUND(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY petal_width)::NUMERIC, 2)))
					  FROM public.iris);

-- create Pearson Correlation Coefficient (R value) matrix based on variable pairs
SELECT CORR(sepal_length, sepal_width) AS sepal_length_vs_sepal_width,
	CORR(petal_length, petal_width) AS petal_length_vs_petal_width,
	CORR(sepal_length, petal_length) AS sepal_length_vs_petal_length,
	CORR(sepal_width, petal_width) AS sepal_width_vs_petal_width
FROM public.iris;