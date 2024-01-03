DROP TABLE IF EXISTS public.iris;

CREATE TABLE iris(
	sepal_length REAL,
	sepal_width REAL,
	petal_length REAL,
	petal_width REAL,
	species TEXT
);

COPY public.iris(sepal_length, sepal_width, petal_length, petal_width, species) 
FROM '/home/sapphiregaze/Downloads/IRIS.csv'
DELIMITER ','
CSV HEADER;

SELECT * FROM public.iris;