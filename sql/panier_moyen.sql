SELECT
  SUM(oi.sale_price) / COUNT(DISTINCT o.order_id) AS panier_moyen
FROM `bigquery-public-data.thelook_ecommerce.order_items` oi
JOIN `bigquery-public-data.thelook_ecommerce.orders` o
  ON oi.order_id = o.order_id
JOIN `bigquery-public-data.thelook_ecommerce.users` u
  ON o.user_id = u.id
  AND oi.sale_price > 0
  AND u.country = 'France'
  AND u.gender = 'F'
  AND EXTRACT(YEAR FROM o.created_at) BETWEEN 2023 AND 2024;