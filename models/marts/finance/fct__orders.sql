WITH orders AS (
    SELECT * FROM {{ ref ('stg__jaffle_shop__orders' ) }}
),

payments AS (
    SELECT * FROM {{ ref ('stg__stripe__payments') }}
),

order_payments AS (
    SELECT
        order_id,
        sum(CASE WHEN status = 'success' THEN amount END) AS amount

    FROM payments
    GROUP BY 1
),

final AS (

    SELECT
        orders.order_id,
        orders.customer_id,
        orders.order_date,
        coalesce(order_payments.amount, 0) AS amount

    FROM orders
    LEFT JOIN order_payments ON orders.order_id = order_payments.order_id
)

SELECT * FROM final
