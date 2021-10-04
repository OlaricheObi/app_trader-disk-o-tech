WITH main_query AS (SELECT DISTINCT(aa.name) AS app_name, ROUND(((((ROUND(ROUND(aa.rating/5, 1) *5, 1) *2) +1) + ((ROUND(ROUND(pa.rating/5, 1) *5, 1) * 2) +1)) / 2), 2) AS avg_lifespan,
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
SELECT expected_revenue - marketing_costs - GREATEST(app_purchase_price, 
	   play_purchase_price) AS net_profit, 
	   app_name, apple_genre, play_genre, 
	   apple_content_rating, 
	   main_query.a_review_count
FROM main_query
ORDER BY net_profit DESC, a_review_count DESC
LIMIT 10;

SELECT aa.name,
	   aa.review_count + pa.review_count AS total_reviews,
	   aa.rating
FROM app_store_apps AS aa
INNER JOIN play_store_apps AS pa
USING (name);

