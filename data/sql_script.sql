--organizing by app price
/*SELECT DISTINCT(aa.name) AS app_name, ((ROUND(ROUND(aa.rating/5, 1)*5, 1) *2) +1) + ((ROUND(ROUND(pa.rating/5, 1)*5, 1) * 2) +1) AS joint_lifespan, (((ROUND(ROUND(aa.rating/5, 1)*5, 1) *2) +1) + ((ROUND(ROUND(pa.rating/5, 1)*5, 1) * 2) +1)) * 12 * 5000 AS expected_revenue, aa.price AS apple_price, TRIM(REPLACE(pa.price, '$', '')) AS play_price, aa.primary_genre AS apple_genre, pa.genres AS play_genre,
	CASE WHEN aa.price <= 1 THEN 10000.00
	WHEN aa.price > 1 THEN aa.price * 10000 END AS apple_purchase_price,
	CASE WHEN TRIM(REPLACE(pa.price, '$', ''))::numeric <= 1 THEN 10000.00
	WHEN TRIM(REPLACE(pa.price, '$', ''))::numeric > 1 THEN TRIM(REPLACE(pa.price, '$', ''))::numeric * 10000 END AS play_purchase_price
FROM play_store_apps AS pa INNER JOIN app_store_apps AS aa
ON aa.name = pa.name
ORDER BY joint_lifespan DESC;*/

--Calculating net profit for apps
/*WITH main_query AS (SELECT DISTINCT(aa.name) AS app_name, ROUND(((((ROUND(ROUND(aa.rating/5, 1) *5, 1) *2) +1) + ((ROUND(ROUND(pa.rating/5, 1) *5, 1) * 2) +1)) / 2), 2) AS avg_lifespan,
				ROUND(((((ROUND(ROUND(aa.rating/5, 1)*5, 1) *2) +1) + ((ROUND(ROUND(pa.rating/5, 1)*5, 1) * 2) +1)) / 2) * 12 * 5000, 2) AS expected_revenue,
				ROUND(((((ROUND(ROUND(aa.rating/5, 1)*5, 1) *2) +1) + ((ROUND(ROUND(pa.rating/5, 1)*5, 1) * 2) +1)) / 2) * 12 * 1000, 2) AS marketing_costs,
				aa.price AS apple_price, TRIM(REPLACE(pa.price, '$', '')) AS play_price,
				aa.primary_genre AS apple_genre, pa.genres AS play_genre, aa.review_count AS a_review_count, aa.content_rating AS apple_content_rating,
	CASE WHEN aa.price <= 1 THEN 10000.00
	WHEN aa.price > 1 THEN aa.price * 10000 END AS app_purchase_price,
	CASE WHEN TRIM(REPLACE(pa.price, '$', ''))::numeric <= 1 THEN 10000.00
	WHEN TRIM(REPLACE(pa.price, '$', ''))::numeric > 1 THEN TRIM(REPLACE(pa.price, '$', ''))::numeric * 10000 END AS play_purchase_price
FROM play_store_apps AS pa INNER JOIN app_store_apps AS aa
ON aa.name = pa.name
ORDER BY expected_revenue DESC)
SELECT expected_revenue - marketing_costs - GREATEST(app_purchase_price, play_purchase_price) AS net_profit, *
FROM main_query
LIMIT 10;*/
--calculation for net profit: expected = expected_revenue - expected_markerting_costs - (the greater of apple_price OR play_price)

/*WITH main_query AS (SELECT DISTINCT(aa.name) AS app_name, ROUND(((((ROUND(ROUND(aa.rating/5, 1) *5, 1) *2) +1) + ((ROUND(ROUND(pa.rating/5, 1) *5, 1) * 2) +1)) / 2), 2) AS avg_lifespan,
				ROUND(((((ROUND(ROUND(aa.rating/5, 1)*5, 1) *2) +1) + ((ROUND(ROUND(pa.rating/5, 1)*5, 1) * 2) +1)) / 2) * 12 * 5000, 2) AS expected_revenue,
				ROUND(((((ROUND(ROUND(aa.rating/5, 1)*5, 1) *2) +1) + ((ROUND(ROUND(pa.rating/5, 1)*5, 1) * 2) +1)) / 2) * 12 * 1000, 2) AS marketing_costs,
				aa.price AS apple_price, TRIM(REPLACE(pa.price, '$', '')) AS play_price,
				aa.primary_genre AS apple_genre, pa.genres AS play_genre, aa.review_count AS a_review_count, aa.content_rating AS apple_content_rating,
	CASE WHEN aa.price <= 1 THEN 10000.00
	WHEN aa.price > 1 THEN aa.price * 10000 END AS app_purchase_price,
	CASE WHEN TRIM(REPLACE(pa.price, '$', ''))::numeric <= 1 THEN 10000.00
	WHEN TRIM(REPLACE(pa.price, '$', ''))::numeric > 1 THEN TRIM(REPLACE(pa.price, '$', ''))::numeric * 10000 END AS play_purchase_price
FROM play_store_apps AS pa INNER JOIN app_store_apps AS aa
ON aa.name = pa.name
ORDER BY expected_revenue DESC)
SELECT expected_revenue - marketing_costs - GREATEST(app_purchase_price, play_purchase_price) AS net_profit, *
FROM main_query
ORDER BY net_profit DESC
LIMIT 10;*/

/*SELECT a.name, a.review_count, p.review_count
FROM app_store_apps AS a
FULL JOIN play_store_apps AS p
USING (name) */

--Trying to add both store reviews as a more accurate measure for install count(app popularity)
/*SELECT aa.name,
	   aa.review_count AS aa_reviews,
	   pa.review_count AS pa_reviews,
	   aa.rating
FROM app_store_apps AS aa
INNER JOIN play_store_apps AS pa
USING (name);*/
