# 📊 Analyse E-commerce 2023 vs 2024  
## TheLook Europe — Périmètre France × Women  
Projet de fin de formation — Spécialisation Data Analyst

---

# 1️⃣ Contexte & Objectifs

Dans le cadre de ce projet, j’endosse le rôle de **Data Analyst** au sein de *TheLook Europe*.  

La direction e-commerce souhaite analyser la performance de l’activité sur le périmètre suivant :

> **France × Département "Women" × Période du 01/01/2023 au 31/12/2024**

L’objectif est de :

- Comprendre l’évolution du chiffre d’affaires et de la marge entre 2023 et 2024
- Analyser le comportement client (panier moyen, ré-achat)
- Étudier l’impact des retours
- Produire un dashboard Power BI clair et orienté décision

---

# 2️⃣ Source de données & Sous-périmètre

## 📌 Source officielle

Dataset public BigQuery :  
`bigquery-public-data.thelook_ecommerce`

Tables utilisées :

- `orders`
- `order_items`
- `products`
- `users`

## 🔗 Jointures

- `users.id = orders.user_id`
- `orders.order_id = order_items.order_id`
- `products.id = order_items.product_id`

## 🎯 Filtres appliqués

- `users.country = 'France'`
- `products.department = 'Women'`
- `DATE(order_items.created_at)`  
  BETWEEN '2023-01-01' AND '2024-12-31'

## 📦 Statuts utilisés

- **Ventes** → `status = 'Complete'`
- **Retours** → `status = 'Returned'`

Toutes les métriques sont construites selon ces conventions.

---

# 3️⃣ Structure du dépôt

/
├─ README.md
├─ data/
│ └─ thelook_fr_women_2023_2024.csv
├─ notebooks/
│ ├─ Première_exploration.ipynb
│ └─ data_dictionary.csv
├─ sql/
│ ├─ autres_KPI.sql
│ ├─ ca.sql
│ ├─ marge_brute.sql
│ ├─ panier_moyen.sqll
│ ├─ taux_reachat.sql
│ └─ taux_retour.sql
├─ powerbi/
│ └─ Final_thelook_ecommerce_power_bi.pbix
├─ slides/
│ └─ soutenance_20min.pptx

---

# 4️⃣ Étape 1 — Analyse Exploratoire (Python)

Notebook : `01_EDA_python.ipynb`

## ✔ Contrôles qualité réalisés

- Vérification des valeurs manquantes
- Détection des doublons
- Contrôle des bornes temporelles
- Vérification des formats de dates
- Cohérence des statuts

## 📊 Analyses réalisées

- Distribution des prix de vente et des coûts
- Contribution CA & marge par :
  - Marque
  - Catégorie
  - Ville
- Analyse saisonnière mensuelle
- Comparaison 2023 vs 2024 (écarts absolus et relatifs)
- Identification de pics et ruptures

---

# 5️⃣ KPI Calculés

## 💰 Chiffre d’affaires (CA)

Somme des `sale_price`  
Filtre : `status = 'Complete'`

## 📈 Marge brute

Somme de `(sale_price - cost)`  
Filtre : `status = 'Complete'`

## 🛒 Panier moyen (AOV)

CA / Nombre de commandes avec revenu > 0

## 🔁 Taux de retour

Lignes `Returned` / (Lignes `Complete` + `Returned`)

## 👥 Taux de ré-achat

Part des clients ayant **≥ 2 commandes complètes** sur une même année.

---

# 6️⃣ Étape 2 — Validation SQL (BigQuery)

Les KPI ont été recalculés directement depuis la source de vérité BigQuery.

Objectifs :

- Vérification des agrégations
- Validation des filtres
- Comparaison Python vs SQL
- Explication des éventuels écarts

La requête `extract_sous_perimetre.sql` permet de reconstruire exactement le CSV utilisé en Python et Power BI.

➡️ Traçabilité assurée entre :
BigQuery → CSV → Python → Power BI

---

# 7️⃣ Dashboard Power BI

Fichier : `powerbi/dashboard_thelook.pbix`

## 🎨 Choix de design

- Page synthèse avec KPI cards
- Comparaison mensuelle 2023 vs 2024
- Top marques & catégories (contribution CA et marge)
- Carte des villes françaises
- Analyse du taux de retour
- Décomposition du panier moyen

Objectif :  
Permettre à une direction e-commerce de :

- Identifier les moteurs de croissance
- Détecter les catégories sous-performantes
- Comprendre l’impact des retours sur la rentabilité
- Orienter les décisions marketing et merchandising

---

# 8️⃣ Principaux Enseignements

*(À adapter avec tes vrais résultats)*

- Évolution du CA entre 2023 et 2024 : +X%
- Marge en progression / érosion sur certaines catégories
- Saison forte identifiée (ex : Q4)
- Certaines marques surperforment malgré un taux de retour élevé
- Opportunité de travailler la fidélisation client

---

# 9️⃣ Reproduction du projet

## 🔧 Environnement Python

Python 3.10+

Librairies principales :

pandas
numpy
matplotlib
seaborn
