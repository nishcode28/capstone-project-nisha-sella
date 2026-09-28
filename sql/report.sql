/*a) Order totals
i)total_orders
output:
+--------------+
| total_orders |
+--------------+
|          180 |
+--------------+

sqlite> SELECT COUNT(*) AS total_orders
   ...> FROM orders;
*/
SELECT COUNT(*) AS total_orders
FROM orders;
/* ii)total_revenue
output:
+---------------+
| total_revenue |
+---------------+
|       99860.2 |
+---------------+

sqlite> SELECT
   ...>     SUM(o.quantity * p.price * (1 - COALESCE(o.discount_pct, 0) / 100.0)) AS total_revenue
   ...> FROM orders o
   ...> JOIN products p ON o.product_id = p.product_id;
*/
SELECT
    SUM(o.quantity * p.price * (1 - COALESCE(o.discount_pct, 0) / 100.0)) AS total_revenue
FROM orders o
JOIN products p ON o.product_id = p.product_id;
/* iii) average_order_value
output:
+---------------------+
| average_order_value |
+---------------------+
|   554.7788888888889 |
+---------------------+

sqlite> SELECT
   ...>     SUM(o.quantity * p.price * (1 - COALESCE(o.discount_pct, 0) / 100.0)) / COUNT(o.order_id) AS average_order_value
   ...> FROM orders o
   ...> JOIN products p ON o.product_id = p.product_id;
*/
SELECT
    SUM(o.quantity * p.price * (1 - COALESCE(o.discount_pct, 0) / 100.0)) / COUNT(o.order_id) AS average_order_value
FROM orders o
JOIN products p ON o.product_id = p.product_id;


/*
b)Query: Total orders, rated orders, and unrated orders in one query

sqlite> SELECT
   ...>     COUNT(*) AS total_orders,
   ...>     COUNT(rating) AS rated_orders,
   ...>     COUNT(*) - COUNT(rating) AS unrated_orders
   ...> FROM orders;
Output:
+--------------+--------------+----------------+
| total_orders | rated_orders | unrated_orders |
+--------------+--------------+----------------+
|          180 |          165 |             15 |
+--------------+--------------+----------------+

*/
SELECT 
    COUNT(*) AS total_orders,
    COUNT(rating) AS rated_orders,
    COUNT(*) - COUNT(rating) AS unrated_orders
FROM orders;
/*
c)Query: customer with zero orders
sqlite> SELECT
   ...>     c.customer_id,
   ...>     c.name
   ...> FROM customers c
   ...> LEFT JOIN orders o ON c.customer_id = o.customer_id
   ...> GROUP BY c.customer_id
   ...> HAVING COUNT(o.order_id) = 0;
Output:
+-------------+--------+
| customer_id |  name  |
+-------------+--------+
| C045        | Vihaan |
+-------------+--------+
sqlite> SELECT customer_id, name
   ...> FROM customers
   ...> WHERE customer_id NOT IN (
(x1...>     SELECT DISTINCT customer_id
(x1...>     FROM orders
(x1...> );
Output:
+-------------+--------+
| customer_id |  name  |
+-------------+--------+
| C045        | Vihaan |
+-------------+--------+
*/
SELECT 
    c.customer_id,
    c.name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
HAVING COUNT(o.order_id) = 0;

SELECT customer_id, name
FROM customers
WHERE customer_id NOT IN (
    SELECT DISTINCT customer_id 
    FROM orders
);

/*
d)Query: cities with an order return rate greater than 20%
sqlite> SELECT
   ...>     c.city,
   ...>     Count(o.order_id) AS total_orders,
   ...>     Sum(o.returned) AS returned_orders,
   ...>     Round((SUM(o.returned) * 100.0) / COUNT(o.order_id), 1) AS return_rate_pct
   ...> FROM orders o
   ...> JOIN customers c ON o.customer_id = c.customer_id
   ...> GROUP BY c.city
   ...> HAVING return_rate_pct > 20
   ...> ORDER BY return_rate_pct DESC;
output:
+-----------+--------------+-----------------+-----------------+
|   city    | total_orders | returned_orders | return_rate_pct |
+-----------+--------------+-----------------+-----------------+
| Jaipur    |           19 |               8 |           42.11 |
| Lucknow   |           49 |              15 |           30.61 |
| Bangalore |           33 |               8 |           24.24 |
+-----------+--------------+-----------------+-----------------+

*/
SELECT 
    c.city,
    Count(o.order_id) AS total_orders,
    Sum(o.returned) AS returned_orders,
    Round((SUM(o.returned) * 100.0) / COUNT(o.order_id), 1) AS return_rate_pct
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.city
HAVING return_rate_pct > 20
ORDER BY return_rate_pct DESC;

/*
e) Query:total spent for each customer,return top 5 highest spending and then 3 excluding top 2
sqlite> SELECT
   ...>     c.customer_id,
   ...>     c.name,
   ...>     SUM(o.quantity * p.price * (1 - COALESCE(o.discount_pct, 0) / 100.0)) AS total_spent
   ...> FROM customers c
   ...> JOIN orders o ON c.customer_id = o.customer_id
   ...> JOIN products p ON o.product_id = p.product_id
   ...> GROUP BY c.customer_id, c.name
   ...> ORDER BY total_spent DESC, c.customer_id ASC
   ...> LIMIT 5;
Output:
+-------------+---------+-------------+
| customer_id |  name   | total_spent |
+-------------+---------+-------------+
| C043        | Reyansh |     12920.0 |
| C026        | Isha    |      8371.6 |
| C008        | Meera   |      4564.6 |
| C011        | Arjun   |      4111.0 |
| C042        | Sanya   |      3785.0 |
+-------------+---------+-------------+
sqlite> SELECT
   ...>     c.customer_id,
   ...>     c.name,
   ...>     SUM(o.quantity * p.price * (1 - COALESCE(o.discount_pct, 0) / 100.0)) AS total_spent
   ...> FROM customers c
   ...> JOIN orders o ON c.customer_id = o.customer_id
   ...> JOIN products p ON o.product_id = p.product_id
   ...> GROUP BY c.customer_id, c.name
   ...> ORDER BY total_spent DESC, c.customer_id ASC
   ...> LIMIT 3
   ...> OFFSET 2;
Output:
+-------------+-------+-------------+
| customer_id | name  | total_spent |
+-------------+-------+-------------+
| C008        | Meera |      4564.6 |
| C011        | Arjun |      4111.0 |
| C042        | Sanya |      3785.0 |
+-------------+-------+-------------+

*/
SELECT
    c.customer_id,
    c.name,
    SUM(o.quantity * p.price * (1 - COALESCE(o.discount_pct, 0) / 100.0)) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN products p ON o.product_id = p.product_id
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC, c.customer_id ASC
LIMIT 5;

SELECT
    c.customer_id,
    c.name,
    SUM(o.quantity * p.price * (1 - COALESCE(o.discount_pct, 0) / 100.0)) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN products p ON o.product_id = p.product_id
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC, c.customer_id ASC
LIMIT 3, offset 2;


/*
f)Query- total revenue for each category and return the category in descending revenue
sqlite> Select  p.product_id,p.category,
   ...> Count(o.order_id) as order_count,
   ...> SUM(o.quantity * p.price * (1 - COALESCE(o.discount_pct, 0) / 100.0)) AS category_revenue
   ...> FROM customers c
   ...> JOIN orders o ON c.customer_id = o.customer_id
   ...> JOIN products p ON o.product_id = p.product_id
   ...> group by p.category
   ...> order by category_revenue DESC;
Output:
+------------+--------------+-------------+------------------+
| product_id |   category   | order_count | category_revenue |
+------------+--------------+-------------+------------------+
| P04        | Haircare     |          54 |          44956.1 |
| P06        | Skincare     |          60 |          27346.0 |
| P12        | Babycare     |          30 |          16805.0 |
| P16        | PersonalCare |          36 |          10753.1 |
+------------+--------------+-------------+------------------+

*/
Select  p.product_id,p.category,
Count(o.order_id) as order_count,
SUM(o.quantity * p.price * (1 - COALESCE(o.discount_pct, 0) / 100.0)) AS category_revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN products p ON o.product_id = p.product_id
group by p.category
order by category_revenue DESC;

/*
g)Query: Like pattern match
sqlite> select * from customers WHERE name LIKE 'A%';
Output:
+-----------+------+---------+---------+-----------+------------------+
|customer_id| name |  city   |city_tier|signup_date|acquisition_source|
+-----------+------+---------+---------+-----------+------------------+
|C001       |Aarav |Mumbai   |        1|2026-01-07 |Organic           |
|C003       |Aditi |Mumbai   |        1|2026-06-23 |Organic           |
|C004       |Ananya|Lucknow  |        2|2026-01-23 |Organic           |
|C011       |Arjun |Bangalore|        1|2026-03-13 |Referral          |
|C021       |Aryan |Bangalore|        1|2026-02-11 |Ad                |
|C030       |Anika |Bangalore|        1|2026-02-24 |Organic           |
|C031       |Aditya|Jaipur   |        2|2026-06-14 |Ad                |
|C036       |Aisha |Delhi    |        1|2026-05-11 |Ad                |
|C041       |Ayaan |Lucknow  |        2|2026-01-03 |Organic           |
|C044       |Aria  |Bangalore|        1|2026-04-22 |Referral          |
+-----------+------+---------+---------+-----------+------------------+

*/
select * from customers WHERE name LIKE 'A%';
/*
h)
QUERY: distinct acquistion source value used across all customers.
sqlite> select DISTINCT acquisition_source from customers;
Output:
+--------------------+
| acquisition_source |
+--------------------+
| Organic            |
| Referral           |
| Ad                 |
| Social             |
+--------------------+
*/

select DISTINCT acquisition_source from customers;
/*
i)
Query:Alter table + update with case
sqlite> Alter table customers ADD COLUMN loyalty_tier VARCHAR(10);
sqlite> UPDATE customers
   ...> SET loyalty_tier = CASE
   ...> When city_tier = 1 THEN 'Gold' ELSE 'Silver'
   ...> END
   ...> ;
sqlite> SELECT loyalty_tier, COUNT(*) FROM customers GROUP BY loyalty_tier;

Output:
+--------------+----------+
| loyalty_tier | COUNT(*) |
+--------------+----------+
| Gold         |       28 |
| Silver       |       17 |
+--------------+----------+

*/
Alter table customers ADD COLUMN loyalty_tier VARCHAR(10);
UPDATE customers
SET loyalty_tier = CASE 
When city_tier = 1 THEN 'Gold' ELSE 'Silver'
END ;
SELECT loyalty_tier, COUNT(*) FROM customers GROUP BY loyalty_tier;
