--Які клієнти витратили більше середнього значення витрат усіх клієнтів?
--Використовує підзапит у WHERE.

CREATE VIEW  vw_above_average_spending as ( 
		WITH client_spending as (
				SELECT 	c.customer_id,
						c.first_name || ' ' || c.last_name AS client_full_name,
						ROUND(sum(il.unit_price * il.quantity),2) as client_expences
				FROM customer c
				JOIN invoice i using(customer_id)
				JOIN invoice_line il using(invoice_id)
				GROUP BY c.customer_id
				ORDER BY client_expences DESC
		)
	SELECT client_full_name, 
			client_expences
	FROM client_spending
	WHERE client_expences > (
			SELECT avg(client_expences) FROM client_spending
		)
	ORDER BY client_expences DESC
	)
select * from vw_above_average_spending