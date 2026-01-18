WITH commandes AS (
  SELECT
    o.user_id AS user_id,
    o.order_id,
    EXTRACT(YEAR FROM o.created_at) AS year
  FROM `bigquery-public-data.thelook_ecommerce.orders` o
  JOIN `bigquery-public-data.thelook_ecommerce.users` u
    ON o.user_id = u.id
  WHERE o.status = 'Complete'
    AND u.country = 'France'
    AND u.gender = 'F'
    AND EXTRACT(YEAR FROM o.created_at) BETWEEN 2023 AND 2024
),

clients_reachat AS (
  SELECT
    user_id
  FROM commandes
  GROUP BY user_id, year
  HAVING COUNT(DISTINCT order_id) >= 2
)

SELECT
  COUNT(DISTINCT cr.user_id)
  / (SELECT COUNT(DISTINCT c.user_id) FROM commandes c) AS taux_reachat
FROM clients_reachat cr;