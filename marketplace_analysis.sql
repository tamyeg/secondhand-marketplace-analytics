-- PostgreSQL. Import data/listings.csv into a table with the following schema:
CREATE TABLE IF NOT EXISTS listings (
  listing_id INTEGER PRIMARY KEY, seller_id INTEGER NOT NULL,
  category TEXT, brand TEXT, condition TEXT, listing_price_eur NUMERIC(10,2),
  views INTEGER, favourites INTEGER, days_to_snapshot INTEGER,
  sold INTEGER, sale_price_eur NUMERIC(10,2), created_at DATE
);
-- Example psql command after CREATE TABLE (path must be accessible to your psql client):
-- \copy listings FROM 'data/listings.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');

-- 1. Which categories have the highest sell-through rate?
SELECT category, COUNT(*) AS listings, SUM(sold) AS sold_count,
       ROUND(100.0 * SUM(sold) / NULLIF(COUNT(*), 0), 2) AS sell_through_pct
FROM listings GROUP BY category ORDER BY sell_through_pct DESC;

-- 2. Price and engagement by category.
SELECT category, ROUND(AVG(listing_price_eur), 2) AS avg_listing_price,
       ROUND(AVG(views), 1) AS avg_views, ROUND(AVG(favourites), 1) AS avg_favourites
FROM listings GROUP BY category ORDER BY avg_views DESC;

-- 3. Seller leaderboard; protect against misleading small sample sizes.
SELECT seller_id, COUNT(*) AS listings, SUM(sold) AS sold_count,
       ROUND(100.0 * SUM(sold) / COUNT(*), 2) AS sell_through_pct
FROM listings GROUP BY seller_id HAVING COUNT(*) >= 5 ORDER BY sold_count DESC LIMIT 10;

-- 4. Monthly listing cohorts (not sales cohorts: no sale timestamps provided).
SELECT DATE_TRUNC('month', created_at)::date AS listing_month,
       COUNT(*) AS listings, ROUND(AVG(listing_price_eur),2) AS avg_price
FROM listings GROUP BY 1 ORDER BY 1;
