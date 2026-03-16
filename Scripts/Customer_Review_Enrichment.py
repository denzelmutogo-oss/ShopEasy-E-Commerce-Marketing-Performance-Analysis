import pandas as pd
import pyodbc
import nltk
from nltk.sentiment.vader import SentimentIntensityAnalyzer

# Download sentiment analysis dictionary used by VADER
nltk.download('vader_lexicon')


# -----------------------------------------------------
# Function to retrieve review data from SQL Server
# -----------------------------------------------------

def fetch_data_from_sql():

    conn_str = (
        "Driver={SQL Server};"
        "Server=ALI-LT2024\\SQLEXPRESS;"
        "Database=PortfolioProject_MarketingAnalytics;"
        "Trusted_Connection=yes;"
    )

    # Establish database connection
    conn = pyodbc.connect(conn_str)

    query = """
    SELECT ReviewID, CustomerID, ProductID, ReviewDate, Rating, ReviewText
    FROM fact_customer_reviews
    """

    # Load SQL data into a pandas DataFrame
    df = pd.read_sql(query, conn)

    conn.close()

    return df


# Load customer review data
customer_reviews_df = fetch_data_from_sql()


# Initialize VADER sentiment analyzer
sia = SentimentIntensityAnalyzer()


# -----------------------------------------------------
# Function to calculate sentiment score for each review
# -----------------------------------------------------

def calculate_sentiment(review):

    sentiment = sia.polarity_scores(review)

    # Compound score summarizes overall sentiment
    # Range: -1 (very negative) to +1 (very positive)
    return sentiment['compound']


# Apply sentiment scoring
customer_reviews_df['SentimentScore'] = customer_reviews_df['ReviewText'].apply(calculate_sentiment)


# -----------------------------------------------------
# Bucket sentiment scores into interpretable ranges
# -----------------------------------------------------

def sentiment_bucket(score):

    if score >= 0.5:
        return '0.5 to 1.0'   # Strong positive sentiment
    elif 0.0 <= score < 0.5:
        return '0.0 to 0.49'  # Mild positive sentiment
    elif -0.5 <= score < 0.0:
        return '-0.49 to 0.0' # Mild negative sentiment
    else:
        return '-1.0 to -0.5' # Strong negative sentiment


customer_reviews_df['SentimentBucket'] = customer_reviews_df['SentimentScore'].apply(sentiment_bucket)


# Export enriched dataset for BI dashboards and analysis
customer_reviews_df.to_csv('fact_customer_reviews_with_sentiment.csv', index=False)
