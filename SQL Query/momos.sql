WITH aggregated_transactions AS (

	SELECT
		DATE(transactions.created_at) AS transaction_date,
	   	brands.brand_name AS brand_name,
	  	outlets.outlet_name AS outlet_name,
	   	transactons.platform AS channel,
	   	NULL::float AS ad_spend,
	   	EXTRACT(HOUR FROM created_at) AS transaction_hour,
	   	transactions.order_type AS order_type,
	   	COUNT(*) AS total_orders,
	   	COUNT(CASE WHEN transactions.order_status ='COMPLETED' THEN 1 ELSE 0 END) AS total_completed_orders,
	   	SUM(CASE WHEN transactions.order_status ='COMPLETED' THEN transactons.sales_amount ELSE 0) END AS total_sales,
	   	COUNT(CASE WHEN transactions.order_status ='COMPLETED' AND transactions.promo_amount > 0 THEN 1 ELSE 0) END AS total_promo_orders,
	   	SUM(CASE WHEN transactions.order_status ='COMPLETED' AND transactions.promo_amount > 0 THEN transactions.sales_amount ELSE 0) AS total_promo_sales,
	   	COUNT(CASE WHEN transactions.order_status ='COMPLETED' AND (transactions.promo_amount = 0 OR transactions.promo_amount IS NULL) THEN 1 ELSE 0) AS total_non_promo_orders,
	   	SUM(CASE WHEN transactions.order_status ='COMPLETED' AND (transactions.promo_amount = 0 OR transactions.promo_amount IS NULL) THEN transactions.sales_amount ELSE 0) AS total_non_promo_sales,
	   	SUM(CASE WHEN transactions.order_status ='COMPLETED' THEN transactions.promo_amount ELSE 0) AS platform_promo_spend,
   		NULL::float AS clicks,
   		NULL::float AS impressions,
   		NULL::float AS reach
	FROM platform_transactions AS transactions
	JOIN outlets ON transactions.outlet_id = outlets.id
	JOIN brands ON outlets.brand_id = brands.id
	GROUP BY 
		transaction_date,
		brand_name,
		outlet_name,
		channel,
		transaction_hour,
		order_type
),
aggregated_ads AS (

	SELECT
		fb_ads.id AS fb_ads_id,
		date AS transaction_date,
	   	brands.brand_name AS brand_name,
	  	outlets.outlet_name AS outlet_name,
	   	'Facebook' AS channel,
	   	SUM(spend) AS ad_spend,
	   	NULL::float AS transaction_hour,
	   	NULL::float AS order_type,
	   	NULL::float AS total_orders,
	   	NULL::float AS total_completed_orders,
	   	NULL::float AS total_sales,
	   	NULL::float AS total_promo_orders,
	   	NULL::float AS total_promo_sales,
	   	NULL::float AS total_non_promo_orders,
	   	NULL::float AS total_non_promo_sales,
	   	NULL::float AS platform_promo_spend,
	   	SUM(fb_ads.clicks) :: float AS clicks,
	   	SUM(fb_ads.impressions) :: float AS impressions,
   		SUM(fb_ads.reach) :: float AS reach
	FROM facebook_ads AS fb_ads
	JOIN outlets ON fb_ads.outlet_id = outlets.id
	JOIN brands ON outlets.brand_id = brands.id
	GROUP BY 
		fb_ads_id,
		transaction_date,
		brand_name,
		outlet_name,
		channel,
		transaction_hour,
		order_type
)	
SELECT * 
FROM 
	aggregated_transactions
UNION
SELECT 
	transaction_date,
	brand_name,
	outlet_name,
	channel,
	ad_spend,
	transaction_hour,
	order_type,
	total_orders,
	total_completed_orders,
	total_sales,
	total_promo_orders,
	total_promo_sales,
	total_non_promo_orders,
	total_non_promo_sales,
	platform_promo_spend,
	clicks,
	impressions,
	reach
FROM 
	aggregated_ads








