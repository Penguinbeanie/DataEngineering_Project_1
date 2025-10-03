-- 1. Which are the top 3 most-traded companies in each sector during Q1 2025?
WITH Q1_2025 AS (
    SELECT 
        f.CompanyID, 
        SUM(f.Volume) AS total_volume, 
        d.Sector
    FROM FactStockPrice f
    JOIN DimDate dd 
        ON f.DateID = dd.DateID
    JOIN DimCompany d 
        ON f.CompanyID = d.CompanyID
    WHERE dd.Year = 2025 
      AND dd.Quarter = 1
    GROUP BY f.CompanyID, d.Sector
)
SELECT 
    Sector, 
    CompanyID, 
    total_volume
FROM (
    SELECT 
        Sector, 
        CompanyID, 
        total_volume,
        ROW_NUMBER() OVER (
            PARTITION BY Sector 
            ORDER BY total_volume DESC
        ) AS rn
    FROM Q1_2025
) ranked
WHERE rn <= 3
ORDER BY Sector, total_volume DESC;


-- 2. How has the average price by sectors changed over the past 10 years?
-- using (Open+Close)/2 as “average price”
SELECT 
    d.Sector, 
    dd.Year,
    AVG((f.Open + f.Close) / 2) AS avg_price
FROM FactStockPrice f
JOIN DimDate dd 
    ON f.DateID = dd.DateID
JOIN DimCompany d 
    ON f.CompanyID = d.CompanyID
WHERE dd.Year BETWEEN EXTRACT(YEAR FROM CURRENT_DATE) - 10 
                  AND EXTRACT(YEAR FROM CURRENT_DATE)
GROUP BY d.Sector, dd.Year
ORDER BY d.Sector, dd.Year;


-- 3. Which 10 companies experienced the highest price growth in Q1 2025 from highest to lowest , and what were their percentage gains? 
-- (Growth = % change from first close in Q1 to last close in Q1)
WITH q1_prices AS (
    SELECT 
        f.CompanyID, 
        dd.FullDate, 
        f.Close
    FROM FactStockPrice f
    JOIN DimDate dd 
        ON f.DateID = dd.DateID
    WHERE dd.Year = 2025 
      AND dd.Quarter = 1
),
first_last AS (
    SELECT 
        CompanyID,
        FIRST_VALUE(Close) OVER (
            PARTITION BY CompanyID 
            ORDER BY FullDate ASC
        ) AS start_price,
        LAST_VALUE(Close) OVER (
            PARTITION BY CompanyID 
            ORDER BY FullDate ASC
            ROWS BETWEEN UNBOUNDED PRECEDING 
                     AND UNBOUNDED FOLLOWING
        ) AS end_price
    FROM q1_prices
)
SELECT 
    CompanyID,
    ROUND(((end_price - start_price) / start_price) * 100, 2) AS pct_growth
FROM first_last
GROUP BY CompanyID, start_price, end_price
ORDER BY pct_growth DESC
LIMIT 10;


-- 4. Which are the top 5 companies with the highest average relative volatility in Q1 2025?
-- (Relative volatility = (High - Low)/((High+Low)/2), averaged across Q1)
SELECT 
    f.CompanyID,
    ROUND(AVG((f.High - f.Low) / NULLIF(((f.High + f.Low)/2), 0)), 4) AS avg_rel_volatility
FROM FactStockPrice f
JOIN DimDate dd 
    ON f.DateID = dd.DateID
WHERE dd.Year = 2025 
  AND dd.Quarter = 1
GROUP BY f.CompanyID
ORDER BY avg_rel_volatility DESC
LIMIT 5;


-- 5. How has the sector composition of S&P 500 companies changed from 2000 to 2025?
SELECT 
    d.Sector, 
    dd.Year, 
    COUNT(DISTINCT f.CompanyID) AS company_count
FROM FactStockPrice f
JOIN DimDate dd 
    ON f.DateID = dd.DateID
JOIN DimCompany d 
    ON f.CompanyID = d.CompanyID
WHERE dd.Year BETWEEN 2000 AND 2025
GROUP BY d.Sector, dd.Year
ORDER BY dd.Year, d.Sector;
