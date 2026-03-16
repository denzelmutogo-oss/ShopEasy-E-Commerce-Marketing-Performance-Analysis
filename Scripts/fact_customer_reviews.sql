-- =====================================================
-- fact_customer_reviews
-- Clean review text formatting
-- =====================================================

SELECT 
    ReviewID,      -- Unique review identifier
    CustomerID,    -- Links review to the customer dimension
    ProductID,     -- Links review to the product dimension
    ReviewDate,    -- Date the review was submitted
    Rating,        -- Customer rating score (typically 1–5 stars)

    -- Replace double spaces with single spaces to standardize text
    REPLACE(ReviewText, '  ', ' ') AS ReviewText

FROM dbo.customer_reviews;

-- This cleaning step improves readability and prepares
-- the text data for NLP and sentiment analysis later in the pipeline.
