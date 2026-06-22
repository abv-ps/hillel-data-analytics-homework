SELECT album_id as album_id, COUNT(*) as cnt_track
FROM track
GROUP BY album_id
HAVING COUNT(*) >= 5
ORDER BY cnt_track DESC;

SELECT country, count(customer_id) as cnt_customer,
CASE WHEN count(customer_id) > 5 THEN 'large'
WHEN count(customer_id) > 2 THEN 'target'
ELSE 'small' END as client_base
FROM customer
GROUP BY country
ORDER BY cnt_customer DESC;

SELECT genre_id, 
to_char(AVG(milliseconds) * interval '1 millisecond', 'MI:SS') AS avg_time
FROM track
GROUP BY genre_id
HAVING AVG(milliseconds) > 250000
ORDER BY avg_time DESC;


SELECT support_rep_id as sup_rep, COUNT(*) as cnt_client
FROM customer
GROUP BY sup_rep
ORDER BY cnt_client DESC;

SELECT customer_id as client, COUNT(*) as count_of_orders,
sum(total) as total_expenses
FROM invoice
GROUP BY client
HAVING sum(total) > 20
ORDER BY total_expenses DESC;