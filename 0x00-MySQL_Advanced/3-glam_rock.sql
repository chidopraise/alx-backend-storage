-- Script to list all Glam rock bands ranked by their longevity
-- The result includes the band name and their lifespan in years until 2022
-- The result is ordered by lifespan in descending order

SELECT band_name,
       IFNULL(
           IF(split IS NULL, 2022 - formed, split - formed),
           0
       ) AS lifespan
FROM metal_bands
WHERE main_style = 'Glam rock'
ORDER BY lifespan DESC;
