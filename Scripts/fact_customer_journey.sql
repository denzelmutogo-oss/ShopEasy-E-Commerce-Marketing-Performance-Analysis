-- =====================================================
-- fact_customer_journey
-- Remove duplicate journey events and fill missing durations
-- =====================================================

SELECT 
    JourneyID,     -- Unique identifier for each customer journey event
    CustomerID,    -- Links to the customer dimension
    ProductID,     -- Links to the product dimension
    VisitDate,     -- Date of the customer interaction
    Stage,         -- Stage in the customer journey (Awareness, Consideration, etc.)
    Action,        -- Customer action (View, Click, Purchase)

    -- Replace missing durations with the average duration for that date
    COALESCE(Duration, avg_duration) AS Duration

FROM (

    SELECT 
        JourneyID,
        CustomerID,
        ProductID,
        VisitDate,

        -- Standardize stage text to uppercase
        UPPER(Stage) AS Stage,

        Action,
        Duration,

        -- Calculate the average duration for interactions on the same day
        AVG(Duration) OVER (PARTITION BY VisitDate) AS avg_duration,

        -- Identify duplicate records
        ROW_NUMBER() OVER (
            PARTITION BY CustomerID, ProductID, VisitDate, UPPER(Stage), Action
            ORDER BY JourneyID
        ) AS row_num

    FROM dbo.customer_journey

) AS subquery

-- Keep only the first record from each duplicate group
WHERE row_num = 1;
