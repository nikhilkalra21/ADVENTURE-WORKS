use workshop;


SELECT city, StateProvinceName AS state, CountryRegionName AS country, COUNT(Person_SK) AS Employee_Counts
FROM DimPerson p INNER JOIN DimGeography g
ON p.Geography_SK = g.Geography_SK
GROUP BY city, StateProvinceName, CountryRegionName
ORDER BY COUNT(Person_SK);


SELECT city, COUNT(Person_SK) AS Employee_Counts
FROM DimPerson p INNER JOIN DimGeography g
ON p.Geography_SK = g.Geography_SK
GROUP BY City;


SELECT StateProvinceName AS state, COUNT(Person_SK) AS Employee_Counts
FROM DimPerson p INNER JOIN DimGeography g
ON p.Geography_SK = g.Geography_SK
GROUP BY StateProvinceName;


SELECT CountryRegionName AS country, COUNT(Person_SK) AS Employee_Counts
FROM DimPerson p INNER JOIN DimGeography g
ON p.Geography_SK = g.Geography_SK
GROUP BY CountryRegionName;


SELECT city, COUNT(Person_SK) AS Customer_Counts
FROM dimcustomer c INNER JOIN DimGeography g
ON c.Geography_SK = g.Geography_SK
GROUP BY City
ORDER BY COUNT(Person_SK);


SELECT StateProvinceName AS state, COUNT(Person_SK) AS Customer_Counts
FROM dimcustomer c INNER JOIN DimGeography g
ON c.Geography_SK = g.Geography_SK
GROUP BY StateProvinceName
ORDER BY COUNT(Person_SK);


SELECT CountryRegionName AS country, COUNT(Person_SK) AS Customer_Counts
FROM dimcustomer c INNER JOIN DimGeography g
ON c.Geography_SK = g.Geography_SK
GROUP BY CountryRegionName
ORDER BY COUNT(Person_SK);


SELECT city, StateProvinceName AS state, CountryRegionName AS country, COUNT(Person_SK) AS Employee_Counts
FROM DimCustomer c INNER JOIN DimGeography g
ON c.Geography_SK = g.Geography_SK
GROUP BY city, StateProvinceName, CountryRegionName
ORDER BY COUNT(Person_SK);

