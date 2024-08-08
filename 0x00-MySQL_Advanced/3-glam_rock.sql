-- Create the query to select and compute the lifespan of Glam rock bands
SELECT 
    name AS band_name, 
    CASE 
        WHEN split IS NOT NULL THEN YEAR('2022-12-31') - formed
        ELSE YEAR('2022-12-31') - formed
    END AS lifespan
FROM 
    metal_bands
WHERE 
    style = 'Glam rock'
ORDER BY 
    lifespan DESC;
