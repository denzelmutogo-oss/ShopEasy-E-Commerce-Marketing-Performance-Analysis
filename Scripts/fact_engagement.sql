-- =====================================================
-- fact_engagement
-- Clean and normalize marketing engagement data
-- =====================================================

SELECT 
    EngagementID,   -- Unique identifier for each engagement event
    ContentID,      -- Identifier for the content being interacted with
    CampaignID,     -- Marketing campaign identifier
    ProductID,      -- Product associated with the campaign

    -- Standardize the content type values
    -- Example: "Socialmedia" becomes "SOCIAL MEDIA"
    UPPER(REPLACE(ContentType, 'Socialmedia', 'Social Media')) AS ContentType,

    -- Extract the number of views from a combined metric column
    LEFT(ViewsClicksCombined, CHARINDEX('-', ViewsClicksCombined) - 1) AS Views,

    -- Extract the number of clicks from the same combined column
    RIGHT(ViewsClicksCombined, LEN(ViewsClicksCombined) - CHARINDEX('-', ViewsClicksCombined)) AS Clicks,

    Likes,  -- Number of likes received for the content

    -- Convert the engagement date into a consistent format
    FORMAT(CONVERT(DATE, EngagementDate), 'dd.MM.yyyy') AS EngagementDate

FROM dbo.engagement_data

-- Remove newsletter records because they are not relevant
-- to the marketing performance analysis for this project
WHERE ContentType != 'Newsletter';
