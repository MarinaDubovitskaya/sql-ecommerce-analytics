WITH product_stats AS (
    SELECT 
        product_id,
        SUM(quantity * unit_price) as revenue
    FROM order_items
    GROUP BY product_id
),
abc_calc AS (
    SELECT 
        product_id,
        revenue,
        SUM(revenue) OVER() as total_revenue,
        SUM(revenue) OVER(ORDER BY revenue DESC) / SUM(revenue) OVER() as cumulative_share
    FROM product_stats
)
SELECT 
    a.product_id,
    p.product_name,
    CASE 
        WHEN cumulative_share <= 0.8 THEN 'A'
        WHEN cumulative_share <= 0.95 THEN 'B'
        ELSE 'C'
    END as abc_category
FROM abc_calc a
JOIN products p ON a.product_id = p.product_id;
