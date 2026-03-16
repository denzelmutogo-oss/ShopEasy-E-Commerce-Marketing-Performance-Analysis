-- =====================================================
-- dim_customers
-- Enrich customer data with geographic information
-- =====================================================

SELECT 
    c.CustomerID,       -- Unique identifier for each customer (primary key)
    c.CustomerName,     -- Customer's full name
    c.Email,            -- Customer contact email
    c.Gender,           -- Customer gender for demographic analysis
    c.Age,              -- Customer age used for segmentation analysis

    g.Country,          -- Country pulled from geography table
    g.City              -- City pulled from geography table

FROM dbo.customers AS c   -- Base customer table containing demographic attributes

LEFT JOIN dbo.geography g -- Geography lookup table containing location information
    ON c.GeographyID = g.GeographyID  

-- LEFT JOIN ensures all customers remain in the dataset
-- even if some customers do not have geography data assigned.
