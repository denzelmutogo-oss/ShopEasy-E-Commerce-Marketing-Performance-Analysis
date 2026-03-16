-- =====================================================
-- dim_products
-- Categorize products based on pricing tiers
-- =====================================================

SELECT 
    ProductID,     -- Unique product identifier
    ProductName,   -- Name of the product
    Price,         -- Product price

    -- Create a derived column that groups products into price tiers
    CASE
        WHEN Price < 50 THEN 'Low'          -- Budget / low-cost products
        WHEN Price BETWEEN 50 AND 200 THEN 'Medium'  -- Mid-range products
        ELSE 'High'                         -- Premium products
    END AS PriceCategory

FROM dbo.products;

-- The PriceCategory field allows analysts to easily compare
-- product performance across pricing segments.
