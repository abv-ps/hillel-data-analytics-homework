--Які клієнти приносять найбільше доходу, і які серед них улюблені жанри?
--Визначити топ 10 клієнтів за загальною сумою покупок
--Для цих клієнтів — з’ясувати, які жанри вони купують
--Отримати топ 5 жанрів по кількості топ клієнтів, які слухають цей жанр.
CREATE OR REPLACE VIEW vw_client_genre_spending_info as
		SELECT c.customer_id as client_id, 
			c.first_name || ' ' || c.last_name as full_name, 
			g.name as genre_name, 
			sum(il.quantity*il.unit_price) as total_sum	
		FROM genre g
		JOIN track using(genre_id)
		JOIN invoice_line il using(track_id)
		JOIN invoice using(invoice_id)
		JOIN customer c using (customer_id)
		GROUP BY 1, 2, 3;

--SELECT * from vw_client_genre_spending_info
--SELECT sum(total_sum) from vw_client_genre_spending_info
;
CREATE TEMP TABLE top_10_clients as
SELECT client_id, full_name, sum(total_sum) as total_sum
FROM vw_client_genre_spending_info
GROUP BY 1, 2
ORDER BY total_sum DESC
LIMIT 10;

SELECT * from top_10_clients; --топ 10 клієнтів за загальною сумою покупок

SELECT full_name, genre_name
FROM vw_client_genre_spending_info
WHERE client_id in (select client_id from top_10_clients)
ORDER BY full_name; --жанри для топ 10 клієнтів


SELECT genre_name, COUNT(DISTINCT client_id) as count_of_clients
FROM vw_client_genre_spending_info
WHERE client_id IN (SELECT client_id FROM top_10_clients)
GROUP BY genre_name
ORDER BY count_of_clients DESC
LIMIT 5; -- топ 5 жанрів по кількості топ 10 клієнтів

