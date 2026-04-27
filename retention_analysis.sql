SELECT 
    customer_id,
    COUNT(order_id) as total_orders,
    SUM(total_amount) as lifetime_value,
    MAX(order_date) as last_order_date,
    CURRENT_DATE - MAX(order_date)::date as days_since_last_order,
    CASE 
        WHEN (CURRENT_DATE - MAX(order_date)::date) > 90 THEN 'Churned'
        WHEN COUNT(order_id) > 5 THEN 'VIP'
        ELSE 'Active'
    END as customer_segment
FROM orders
GROUP BY customer_id;

WITH first_orders AS (
    SELECT customer_id, MIN(order_date) as first_purchase
    FROM orders
    GROUP BY customer_id
),
cohorts AS (
    SELECT 
        customer_id,
        DATE_TRUNC('month', first_purchase) as cohort_month
    FROM first_orders
)
SELECT 
    c.cohort_month,
    DATE_TRUNC('month', o.order_date) as activity_month,
    COUNT(DISTINCT o.customer_id) as active_users
FROM cohorts c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY 1, 2
ORDER BY 1, 2;
