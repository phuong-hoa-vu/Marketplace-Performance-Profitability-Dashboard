### olist_orders — Cleaned approval timestamp

- 14 `delivered` orders had `order_approved_at = NULL`, which is inconsistent
- Replaced nulls for these rows with `order_purchase_timestamp` as a proxy
- 141 `canceled` and 5 `created` orders also had null `order_approved_at`
    - ✅ Left as NULL, since those orders were never processed
- order_delivered_carrier_date
- Observation: NULL for multiple statuses including delivered, approved, unavailable, etc.

Action:

order_status = 'canceled', processing, unavailable, invoiced: NULL kept.

order_status = 'delivered': retained rows but flagged for exclusion in delivery-related KPIs.

No imputation was done 

Handling Missing order_delivered_customer_date Values
Upon analysis of the cleaned_orders table, I identified 8 rows where:

order_status = 'delivered'

order_delivered_carrier_date is not null

order_delivered_customer_date is null

This suggests that the logistics partner marked the item as delivered, but the customer either:

Didn't confirm the delivery on the platform, or

The system failed to record the confirmation timestamp.

Decision:
For data quality and integrity:

These records will be retained in the dataset.

They will be excluded from KPIs that require customer confirmation of delivery (e.g., delivery punctuality, delivery duration, etc.).

They can be used in metrics where logistics fulfillment is the focus (e.g., carrier performance).

olist_order_reviews: Handling Nulls
review_score: ✅ No nulls — used in KPI calculations (e.g., NPS, average satisfaction)

review_comment_title, review_comment_message: ❌ Contains nulls

Decision:
Since this project focuses only on quantitative review analysis (via review_score) and does not perform sentiment or topic modelling from review text:

Null values in review_comment_title and review_comment_message do not impact the core business insights.

These fields will be retained but ignored in the Power BI report and KPI calculations.

olist_order_reviews – Handling Duplicates
🎯 Goal
Ensure each order_id has only one associated review, representing the most recent review activity by the customer.

🔍 Issue Identified
Some orders have multiple reviews (i.e., same order_id repeated with different review_ids).

This may happen if a customer edits their review or reviews again.

Keeping all reviews would inflate review counts and distort metrics (e.g., % of 1-star reviews).

🛠️ Solution: DISTINCT ON
We used PostgreSQL’s DISTINCT ON clause to keep only the latest review per order, based on review_answer_timestamp.


### Columns: `product_length_cm`, `product_height_cm`, `product_width_cm`

- ❌ 2 missing values found for each column
- ✅ Replaced using **median value per product category**
    - Used `PERCENTILE_CONT(0.5)` to calculate the median
    - Matched rows based on `product_category_name`
    - Ensures accurate freight/dimension-related calculations
- ✅ No rows dropped — all imputations handled in-place
