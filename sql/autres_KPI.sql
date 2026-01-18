/*
KPI : Chiffre d'affaires

Périmètre :
- Pays : France
- Genre : Women (F)
- Période : 2023 à 2024
- Statut des ventes : Complete
  → garantit que seules les ventes effectivement finalisées sont prises en compte

Granularité temporelle :
- Mensuelle : DATE_TRUNC(created_at, MONTH)
- Annuelle : EXTRACT(YEAR FROM created_at)
*/

SELECT
  DATE_TRUNC(o.created_at, MONTH) AS month,
  EXTRACT(YEAR FROM o.created_at) AS year,
  SUM(oi.sale_price) AS total_revenue
FROM `bigquery-public-data.thelook_ecommerce.order_items` oi
JOIN `bigquery-public-data.thelook_ecommerce.orders` o
  ON oi.order_id = o.order_id
JOIN `bigquery-public-data.thelook_ecommerce.users` u
  ON o.user_id = u.id
WHERE u.country = 'France'              -- Filtre géographique
  AND u.gender = 'F'                    -- Filtre genre : Women
  AND o.status = 'Complete'             -- Ventes réellement réalisées
  AND EXTRACT(YEAR FROM o.created_at) BETWEEN 2023 AND 2024
GROUP BY month, year
ORDER BY month;

/*
KPI : Nombre de commandes

Choix méthodologiques :
- COUNT DISTINCT order_id pour éviter le double comptage
- Statut 'Complete' pour exclure les commandes annulées ou incomplètes
- Granularité annuelle pour une vision synthétique
*/

SELECT
  EXTRACT(YEAR FROM o.created_at) AS year,
  COUNT(DISTINCT o.order_id) AS total_orders
FROM `bigquery-public-data.thelook_ecommerce.orders` o
JOIN `bigquery-public-data.thelook_ecommerce.users` u
  ON o.user_id = u.id
WHERE u.country = 'France'
  AND u.gender = 'F'
  AND o.status = 'Complete'
  AND EXTRACT(YEAR FROM o.created_at) BETWEEN 2023 AND 2024
GROUP BY year
ORDER BY year;

/*
KPI : Panier moyen (Average Order Value)

Méthode :
- Somme des montants de ventes / nombre de commandes distinctes
- Permet de mesurer la valeur moyenne d'une commande
- Calculé uniquement sur les ventes complètes
*/

SELECT
  EXTRACT(YEAR FROM o.created_at) AS year,
  SUM(oi.sale_price) / COUNT(DISTINCT o.order_id) AS average_basket
FROM `bigquery-public-data.thelook_ecommerce.order_items` oi
JOIN `bigquery-public-data.thelook_ecommerce.orders` o
  ON oi.order_id = o.order_id
JOIN `bigquery-public-data.thelook_ecommerce.users` u
  ON o.user_id = u.id
WHERE u.country = 'France'
  AND u.gender = 'F'
  AND o.status = 'Complete'
  AND EXTRACT(YEAR FROM o.created_at) BETWEEN 2023 AND 2024
GROUP BY year
ORDER BY year;

/*
KPI : Nombre d'articles retournés

Choix du statut :
- 'Returned' permet d'identifier les ventes ayant fait l'objet d'un retour
- Analyse séparée des ventes afin de ne pas biaiser le chiffre d'affaires

Granularité :
- Mensuelle pour identifier des périodes à forte incidence de retours
*/

SELECT
  DATE_TRUNC(o.created_at, MONTH) AS month,
  COUNT(*) AS returned_items
FROM `bigquery-public-data.thelook_ecommerce.order_items` oi
JOIN `bigquery-public-data.thelook_ecommerce.orders` o
  ON oi.order_id = o.order_id
JOIN `bigquery-public-data.thelook_ecommerce.users` u
  ON o.user_id = u.id
WHERE u.country = 'France'
  AND u.gender = 'F'
  AND oi.status = 'Returned'             -- Articles retournés
  AND EXTRACT(YEAR FROM o.created_at) BETWEEN 2023 AND 2024
GROUP BY month
ORDER BY month;