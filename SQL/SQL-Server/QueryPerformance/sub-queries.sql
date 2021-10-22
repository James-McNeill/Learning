-- Working with sub-queries

-- 1. Uncorrelated sub-query
SELECT UNStatisticalRegion,
       CountryName 
FROM Nations
WHERE Code2 -- Country code for outer query 
         IN (SELECT Country -- Country code for sub-query
             FROM Earthquakes
             WHERE Depth >= 400 ) -- Depth filter
ORDER BY UNStatisticalRegion;

-- 2. Correlated sub-query
SELECT UNContinentRegion,
       CountryName, 
        (SELECT AVG(Magnitude) -- Add average magnitude
        FROM Earthquakes e 
         	  -- Add country code reference
        WHERE n.Code2 = e.Country) AS AverageMagnitude 
FROM Nations n
ORDER BY UNContinentRegion DESC, 
         AverageMagnitude DESC;
