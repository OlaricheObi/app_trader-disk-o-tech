-- SELECT *
-- FROM app_store_apps
-- WHERE name ILIKE 'freecell'
-- For viewing full table

-- SELECT *
-- FROM play_store_apps
-- WHERE name ILIKE 'ASOS'
--For viewing full table

-- SELECT ROUND(ROUND(rating/5, 1)*5, 1)
-- FROM app_store_apps
-- Formula for rounding to 0.5

-- SELECT DISTINCT(aa.name) AS app_name, aa.rating AS apple_rating, (ROUND(ROUND(aa.rating/5, 1)*5, 1) *2) +1 AS apple_lifespan, aa.price AS apple_price, aa.primary_genre AS apple_genre, pa.rating AS play_rating,
-- (ROUND(ROUND(pa.rating/5, 1)*5, 1) * 2) +1 AS play_lifespan, pa.price AS play_price, pa.genres AS play_genre
-- FROM play_store_apps AS pa INNER JOIN app_store_apps AS aa
-- ON aa.name = pa.name
-- ORDER BY apple_lifespan DESC
-- Added expected lifespans

-- SELECT DISTINCT(name)
-- FROM app_store_apps

-- SELECT DISTINCT(aa.name) AS app_name, ((ROUND(ROUND(aa.rating/5, 1)*5, 1) *2) +1) + ((ROUND(ROUND(pa.rating/5, 1)*5, 1) * 2) +1) AS joint_lifespan, (((ROUND(ROUND(aa.rating/5, 1)*5, 1) *2) +1) + ((ROUND(ROUND(pa.rating/5, 1)*5, 1) * 2) +1)) * 12 * 5000 AS expected_revenue, aa.price AS apple_price, aa.primary_genre AS apple_genre, pa.price AS play_price, pa.genres AS play_genre
-- FROM play_store_apps AS pa INNER JOIN app_store_apps AS aa
-- ON aa.name = pa.name
-- WHERE aa.price < 1
-- ORDER BY joint_lifespan DESC
-- Created joint lifespan column

-- SELECT DISTINCT(aa.name) AS app_name, ((ROUND(ROUND(aa.rating/5, 1) *5, 1) *2) +1) + ((ROUND(ROUND(pa.rating/5, 1) *5, 1) * 2) +1) AS joint_lifespan, (((ROUND(ROUND(aa.rating/5, 1)*5, 1) *2) +1) + ((ROUND(ROUND(pa.rating/5, 1)*5, 1) * 2) +1)) * 12 * 5000 AS expected_revenue, aa.price AS apple_price, TRIM(REPLACE(pa.price, '$', '')) AS play_price, aa.primary_genre AS apple_genre, pa.genres AS play_genre,
-- 	CASE WHEN aa.price <= 1 THEN 10000.00
-- 	WHEN aa.price > 1 THEN aa.price * 10000 END AS apple_purchase_price,
-- 	CASE WHEN TRIM(REPLACE(pa.price, '$', ''))::numeric <= 1 THEN 10000.00
-- 	WHEN TRIM(REPLACE(pa.price, '$', ''))::numeric > 1 THEN TRIM(REPLACE(pa.price, '$', ''))::numeric * 10000 END AS play_purchase_price
-- FROM play_store_apps AS pa INNER JOIN app_store_apps AS aa
-- ON aa.name = pa.name
-- ORDER BY joint_lifespan DESC;
-- Added expected revenue and app purchase price

-- SELECT *
-- FROM app_store_apps
-- WHERE rating IS NOT NULL
-- AND review_count::numeric > 100
-- ORDER BY rating DESC

-- SELECT *
-- FROM play_store_apps
-- WHERE rating IS NOT NULL
-- AND review_count > 100
-- ORDER BY rating DESC


-- SELECT DISTINCT(aa.name) AS app_name, ((ROUND(ROUND(aa.rating/5, 1) *5, 1) *2) +1) + ((ROUND(ROUND(pa.rating/5, 1) *5, 1) * 2) +1) AS joint_lifespan, 
-- 				(((ROUND(ROUND(aa.rating/5, 1)*5, 1) *2) +1) + ((ROUND(ROUND(pa.rating/5, 1)*5, 1) * 2) +1)) * 12 * 5000 AS expected_revenue, 
-- 				(((ROUND(ROUND(aa.rating/5, 1)*5, 1) *2) +1) + ((ROUND(ROUND(pa.rating/5, 1)*5, 1) * 2) +1)) * 12 * 1000 AS marketing_costs, 
-- 				aa.price AS apple_price, TRIM(REPLACE(pa.price, '$', '')) AS play_price, 
-- 				aa.primary_genre AS apple_genre, pa.genres AS play_genre, aa.review_count AS a_review_count, aa.content_rating AS apple_content_rating,
-- 	CASE WHEN aa.price <= 1 THEN 10000.00
-- 	WHEN aa.price > 1 THEN aa.price * 10000 END AS apple_purchase_price,
-- 	CASE WHEN TRIM(REPLACE(pa.price, '$', ''))::numeric <= 1 THEN 10000.00
-- 	WHEN TRIM(REPLACE(pa.price, '$', ''))::numeric > 1 THEN TRIM(REPLACE(pa.price, '$', ''))::numeric * 10000 END AS play_purchase_price
-- FROM play_store_apps AS pa INNER JOIN app_store_apps AS aa
-- ON aa.name = pa.name
-- ORDER BY expected_revenue DESC;

-- EXPECTED PROFIT= ROUND(((((ROUND(ROUND(aa.rating/5, 1)*5, 1) *2) +1) + 
--		((ROUND(ROUND(pa.rating/5, 1)*5, 1) * 2) +1)) / 2) * 12 * 5000, 2) - 
--		ROUND(((((ROUND(ROUND(aa.rating/5, 1)*5, 1) *2) +1) + ((ROUND(ROUND(pa.rating/5, 1)*5, 1) * 2) +1)) / 2) * 12 * 1000, 2)
--		- (the greater of apple_price OR play_price)
-- Expected Profit = Expected_Revenue - Expected_Marketing_Costs - (the greater of apple_price OR play_price)

-- WITH main_query AS (SELECT DISTINCT(aa.name) AS app_name, ROUND(((((ROUND(ROUND(aa.rating/5, 1) *5, 1) *2) +1) + ((ROUND(ROUND(pa.rating/5, 1) *5, 1) * 2) +1)) / 2), 2) AS avg_lifespan, 
-- 				ROUND(((((ROUND(ROUND(aa.rating/5, 1)*5, 1) *2) +1) + ((ROUND(ROUND(pa.rating/5, 1)*5, 1) * 2) +1)) / 2) * 12 * 5000, 2) AS expected_revenue, 
-- 				ROUND(((((ROUND(ROUND(aa.rating/5, 1)*5, 1) *2) +1) + ((ROUND(ROUND(pa.rating/5, 1)*5, 1) * 2) +1)) / 2) * 12 * 1000, 2) AS marketing_costs, 
-- 				aa.price AS apple_price, TRIM(REPLACE(pa.price, '$', '')) AS play_price, 
-- 				aa.primary_genre AS apple_genre, pa.genres AS play_genre, aa.content_rating AS acontent_rating, aa.review_count AS areview_count,				
-- 					CASE WHEN aa.price <= 1 THEN 10000.00
-- 					WHEN aa.price > 1 THEN aa.price * 10000 END AS app_purchase_price,
-- 					CASE WHEN TRIM(REPLACE(pa.price, '$', ''))::numeric <= 1 THEN 10000.00
-- 					WHEN TRIM(REPLACE(pa.price, '$', ''))::numeric > 1 THEN TRIM(REPLACE(pa.price, '$', ''))::numeric * 10000 END AS play_purchase_price
-- 				FROM play_store_apps AS pa INNER JOIN app_store_apps AS aa
-- 				ON aa.name = pa.name
-- 				ORDER BY expected_revenue DESC)
-- SELECT app_name, expected_revenue - marketing_costs - GREATEST(app_purchase_price, play_purchase_price) AS net_profit, apple_genre, play_genre, areview_count, acontent_rating
-- FROM main_query
-- ORDER BY net_profit DESC, areview_count::numeric DESC



WITH main_query AS (SELECT DISTINCT(aa.name) AS app_name, ROUND(((((ROUND(ROUND(aa.rating/5, 1) *5, 1) *2) +1) + ((ROUND(ROUND(pa.rating/5, 1) *5, 1) * 2) +1)) / 2), 2) AS avg_lifespan, 
				ROUND(((((ROUND(ROUND(aa.rating/5, 1)*5, 1) *2) +1) + ((ROUND(ROUND(pa.rating/5, 1)*5, 1) * 2) +1)) / 2) * 12 * 5000, 2) AS expected_revenue, 
				ROUND(((((ROUND(ROUND(aa.rating/5, 1)*5, 1) *2) +1) + ((ROUND(ROUND(pa.rating/5, 1)*5, 1) * 2) +1)) / 2) * 12 * 1000, 2) AS marketing_costs, 
				aa.price AS apple_price, TRIM(REPLACE(pa.price, '$', '')) AS play_price, 
				aa.primary_genre AS apple_genre, pa.genres AS play_genre, aa.content_rating AS acontent_rating, aa.review_count AS areview_count,				
					CASE WHEN aa.price <= 1 THEN 10000.00
					WHEN aa.price > 1 THEN aa.price * 10000 END AS app_purchase_price,
					CASE WHEN TRIM(REPLACE(pa.price, '$', ''))::numeric <= 1 THEN 10000.00
					WHEN TRIM(REPLACE(pa.price, '$', ''))::numeric > 1 THEN TRIM(REPLACE(pa.price, '$', ''))::numeric * 10000 END AS play_purchase_price
				FROM play_store_apps AS pa INNER JOIN app_store_apps AS aa
				ON aa.name = pa.name
				ORDER BY expected_revenue DESC),
	play_review AS (SELECT name, MAX(review_count) AS preview_count 
				FROM play_store_apps AS pa
				GROUP BY name
				ORDER BY preview_count)
SELECT app_name, expected_revenue - marketing_costs - GREATEST(app_purchase_price, play_purchase_price) AS net_profit, apple_genre, play_genre, areview_count::numeric + preview_count::numeric AS total_reviews, acontent_rating 
FROM main_query
LEFT JOIN play_review
ON app_name = name
ORDER BY net_profit DESC, areview_count::numeric + preview_count::numeric DESC



