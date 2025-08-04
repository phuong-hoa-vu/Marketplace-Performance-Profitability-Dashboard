--gross sales
SELECT 
  d.year,
  SUM(oi.price) AS gross_sales
FROM fact_orders o
JOIN fact_order_items oi ON o.order_id = oi.order_id
JOIN dim_date d ON o.order_purchase_timestamp::date = d.date
WHERE o.order_status NOT IN ('canceled', 'unavailable')
GROUP BY d.year
ORDER BY d.year;


-- late delivery %
SELECT 
  ROUND(
    COUNT(CASE 
             WHEN order_delivered_customer_date > order_estimated_delivery_date 
             THEN 1 
         END) * 100.0 
    / COUNT(order_id), 
  2) AS late_delivery_percent
FROM fact_orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL;

--Avg delivery time
SELECT
  ROUND(AVG(order_delivered_customer_date::date - order_approved_at::date), 0) AS avg_delivery_time_days
FROM fact_orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_approved_at IS NOT NULL;


--review score metric
SELECT 
  review_score,
  COUNT(*) AS review_count,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS review_percentage
FROM fact_reviews
GROUP BY review_score
ORDER BY review_score;

-- on time delivery %

SELECT 
  ROUND(COUNT(CASE 
                WHEN order_delivered_customer_date <= order_estimated_delivery_date 
                THEN 1 
              END) * 100.0 / COUNT(*), 2) AS on_time_delivery_percent
FROM fact_orders
WHERE order_delivered_customer_date IS NOT NULL 
  AND order_estimated_delivery_date IS NOT NULL;

