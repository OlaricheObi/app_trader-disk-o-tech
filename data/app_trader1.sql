-- SELECT *
-- FROM play_store_apps INNER JOIN app_store_apps
-- ON play_store_apps.name = app_store_apps.name;

-- SELECT COUNT(DISTINCT(name))
-- FROM play_store_apps

-- SELECT play_store_apps.name, app_store_apps.rating, app_store_apps.price
-- FROM play_store_apps LEFT JOIN app_store_apps
-- USING (name);

-- WITH unique_names AS (SELECT DISTINCT(name)
					  
-- SELECT aa.name AS app_name, ROUND(ROUND(aa.rating/5, 1)*5, 1) AS apple_rating, aa.price AS apple_price, aa.primary_genre AS apple_genre,
-- ROUND(ROUND(pa.rating/5, 1)*5, 1) AS play_rating, pa.price AS play_price, pa.genres AS play_genre
-- FROM play_store_apps AS pa INNER JOIN app_store_apps AS aa
-- ON aa.name = pa.name
-- ORDER BY pa.rating DESC
					  

SELECT DISTINCT(aa.name) AS app_name, ((ROUND(ROUND(aa.rating/5, 1)*5, 1) *2) +1) + ((ROUND(ROUND(pa.rating/5, 1)*5, 1) * 2) +1) AS joint_lifespan, (((ROUND(ROUND(aa.rating/5, 1)*5, 1) *2) +1) + ((ROUND(ROUND(pa.rating/5, 1)*5, 1) * 2) +1)) * 12 * 5000 AS expected_revenue, aa.price AS apple_price, TRIM(REPLACE(pa.price, '$', '')) AS play_price, aa.primary_genre AS apple_genre, pa.genres AS play_genre,
	CASE WHEN aa.price <= 1 THEN 10000.00
	WHEN aa.price > 1 THEN aa.price * 10000 END AS apple_purchase_price,
	CASE WHEN TRIM(REPLACE(pa.price, '$', ''))::numeric <= 1 THEN 10000.00
	WHEN TRIM(REPLACE(pa.price, '$', ''))::numeric > 1 THEN TRIM(REPLACE(pa.price, '$', ''))::numeric * 10000 END AS play_purchase_price
FROM play_store_apps AS pa INNER JOIN app_store_apps AS aa
ON aa.name = pa.name
ORDER BY joint_lifespan DESC;
-- added app purchase price