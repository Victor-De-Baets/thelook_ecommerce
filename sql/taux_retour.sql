SELECT
  COUNTIF(oi.status = 'Returned')
  / COUNTIF(oi.status IN ('Complete', 'Returned')) AS taux_retour
FROM `bigquery-public-data.thelook_ecommerce.order_items` oi
JOIN `bigquery-public-data.thelook_ecommerce.orders` o
  ON oi.order_id = o.order_id
JOIN `bigquery-public-data.thelook_ecommerce.users` u
  ON o.user_id = u.id
WHERE u.country = 'France'
  AND oi.status IN ('Complete', 'Returned')

  AND u.gender = 'F'
  AND EXTRACT(YEAR FROM o.created_at) BETWEEN 2023 AND 2024;