WITH daily_sales AS (
    SELECT 
        DATE_TRUNC('day', order_date) as sales_date,
        COUNT(order_id) as orders_count,
        SUM(total_amount) as revenue
    FROM orders
    WHERE status = 'Completed'
    GROUP BY 1
)
SELECT 
    sales_date,
    revenue,
    orders_count,
    revenue / NULLIF(orders_count, 0) as avg_order_value
FROM daily_sales
ORDER BY sales_date DESC;

SELECT 
    p.category,
    SUM(oi.quantity) as total_sold,
    SUM(oi.quantity * oi.unit_price) as category_revenue,
    RANK() OVER (ORDER BY SUM(oi.quantity * oi.unit_price) DESC) as category_rank
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category;
