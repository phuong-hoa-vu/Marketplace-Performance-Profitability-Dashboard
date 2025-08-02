### olist_orders
- `order_id`: ✅ No duplicates — confirmed unique across 99,441 rows
- `order_approved_at`: ❌ 160 nulls
- `order_delivered_carrier_date`: ❌ 1783 nulls
- `order_delivered_customer_date`: ❌ 2965 nulls
### olist_order_reviews
- `review_comment_title`: ❌ 87656 nulls
- `review_comment_message`: ❌ 58247 nulls
- `order_id`: ❌ Found 789 orders with multiple reviews
- In many cases, reviews had:
    - Different `review_score`s
    - Later `review_answer_timestamp`s
- Interpreted as customers updating their reviews

### olist_products
- `product_category_name`: ❌ 610 nulls
- `product_name_lenght`: ❌ 610 nulls
- `product_photos_qty`: ❌ 610 nulls
- `product_name_lenght`: ❌ 610 nulls
- `product_weight_g`: ❌ 2 nulls
- `product_length_cm`: ❌ 2 nulls
- `product_height_cm`: ❌ 2 nulls
- `product_width_cm`: ❌ 2 nulls

### review_comment_message

- Most values are in Portuguese
- Cannot conduct sentiment analysis or keyword clustering without translation
- For this project, we focus only on **quantitative review metrics**:
  - Review score distribution
  - 1-star review rates
  - Review volume over time
### olist_order_items

- `order_id + product_id`: ❌ Some duplicates found
    - Indicates multiple instances of the same product purchased in a single order
    - Olist does not use a `quantity` field — instead, each item is listed as a separate row
    - No actual row-level duplication: `order_id + order_item_id` is unique ✅
### olist_order_payments

- `order_id`: ❌ Not unique — one order may have multiple payment rows
- `order_id + payment_sequential`: ✅ Confirmed unique
- Data structure reflects installment or multi-method payments (e.g., part credit card, part voucher)
