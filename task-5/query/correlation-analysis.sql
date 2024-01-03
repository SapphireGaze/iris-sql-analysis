-- calculate slope and intercept for each species                                                                                                                                                                                                                                                                                                          
SELECT 
	'Iris-setosa' AS species,
	REGR_SLOPE(petal_width, petal_length) AS slope, 
	REGR_INTERCEPT(petal_width, petal_length) AS intercept
FROM public.iris
WHERE species = 'Iris-setosa'
UNION
SELECT 
	'Iris-versicolor' AS species,
	REGR_SLOPE(petal_width, petal_length) AS slope, 
	REGR_INTERCEPT(petal_width, petal_length) AS intercept
FROM public.iris
WHERE species = 'Iris-versicolor'
UNION
SELECT
	'Iris-virginica' AS species,
	REGR_SLOPE(petal_width, petal_length) AS slope, 
	REGR_INTERCEPT(petal_width, petal_length) AS intercept
FROM public.iris
WHERE species = 'Iris-virginica';

-- calculate linear regression, residuals/residuals squared using petal_length and petal_width as x and y for each individual species
WITH setosa_values AS (
	SELECT REGR_SLOPE(petal_width, petal_length) AS slope, 
		REGR_INTERCEPT(petal_width, petal_length) AS intercept
	FROM public.iris
	WHERE species = 'Iris-setosa'
) 
SELECT 
	petal_length, 
	petal_width, 
	setosa_values.slope * petal_length + setosa_values.intercept AS regression,
	petal_width - (setosa_values.slope * petal_length + setosa_values.intercept) AS residuals,
	POWER(petal_width - (setosa_values.slope * petal_length + setosa_values.intercept), 2) AS squared_residuals
FROM public.iris, setosa_values 
WHERE species = 'Iris-setosa';

WITH versicolor_values AS (
	SELECT REGR_SLOPE(petal_width, petal_length) AS slope, 
		REGR_INTERCEPT(petal_width, petal_length) AS intercept
	FROM public.iris
	WHERE species = 'Iris-versicolor'
)
SELECT 
	petal_length, 
	petal_width, 
	versicolor_values.slope * petal_length + versicolor_values.intercept AS regression,
	petal_width - (versicolor_values.slope * petal_length + versicolor_values.intercept) AS residuals,
	POWER(petal_width - (versicolor_values.slope * petal_length + versicolor_values.intercept), 2) AS squared_residuals
FROM public.iris, versicolor_values 
WHERE species = 'Iris-versicolor';

WITH virginica_values AS (
	SELECT REGR_SLOPE(petal_width, petal_length) AS slope, 
		REGR_INTERCEPT(petal_width, petal_length) AS intercept
	FROM public.iris
	WHERE species = 'Iris-virginica'
)
SELECT 
	petal_length, 
	petal_width, 
	virginica_values.slope * petal_length + virginica_values.intercept AS regression,
	petal_width - (virginica_values.slope * petal_length + virginica_values.intercept) AS residuals,
	POWER(petal_width - (virginica_values.slope * petal_length + virginica_values.intercept), 2) AS squared_residuals
FROM public.iris, virginica_values 
WHERE species = 'Iris-virginica';

-- calculate the coefficient of determination r squared for petal_length and petal_width for each species
SELECT 'Iris' AS species, REGR_R2(petal_width, petal_length) AS r_squared FROM public.iris 
UNION
SELECT 'Iris-setosa' AS species, REGR_R2(petal_width, petal_length) AS r_squared FROM public.iris 
WHERE species = 'Iris-setosa'
UNION
SELECT 'Iris-versicolor' AS species, REGR_R2(petal_width, petal_length) AS r_squared FROM public.iris 
WHERE species = 'Iris-versicolor'
UNION
SELECT 'Iris-virginica' AS species, REGR_R2(petal_width, petal_length) AS r_squared FROM public.iris 
WHERE species = 'Iris-virginica';

-- calculate root mean square error (RMSE) for each individual species based on petal_length and petal_width
WITH setosa_values AS (
	SELECT REGR_SLOPE(petal_width, petal_length) AS slope, 
		REGR_INTERCEPT(petal_width, petal_length) AS intercept
	FROM public.iris
	WHERE species = 'Iris-setosa'
), versicolor_values AS (
	SELECT REGR_SLOPE(petal_width, petal_length) AS slope, 
		REGR_INTERCEPT(petal_width, petal_length) AS intercept
	FROM public.iris
	WHERE species = 'Iris-versicolor'
), virginica_values AS (
	SELECT REGR_SLOPE(petal_width, petal_length) AS slope, 
		REGR_INTERCEPT(petal_width, petal_length) AS intercept
	FROM public.iris
	WHERE species = 'Iris-virginica'
) 
SELECT 
	'Iris-setosa' AS species, 
	SQRT(AVG(POWER(petal_width - (setosa_values.slope * petal_length + setosa_values.intercept), 2))) AS rmse
FROM public.iris, setosa_values
WHERE species = 'Iris-setosa'
UNION
SELECT 
	'Iris-versicolor' AS species, 
	SQRT(AVG(POWER(petal_width - (versicolor_values.slope * petal_length + versicolor_values.intercept), 2))) AS rmse
FROM public.iris, versicolor_values
WHERE species = 'Iris-versicolor'
UNION
SELECT 
	'Iris-virginica' AS species, 
	SQRT(AVG(POWER(petal_width - (virginica_values.slope * petal_length + virginica_values.intercept), 2))) AS rmse
FROM public.iris, virginica_values
WHERE species = 'Iris-virginica';
