--Аналіз витрат клієнтів у часі. Для кожного клієнта показати, як змінювались його витрати з кожною покупкою:
--Послідовний номер інвойсу
--Загальна сума кожного інвойсу
--Кумулятивна сума витрат клієнта на кожну дату
--Рухоме середнє витрат за останні 3 інвойси
--Дата інвойсу
--Об’єднай клієнтів з інвойсами та рядками інвойсів
--Обчисли загальну суму кожного інвойсу
--Застосуй кумулятивну суму, рухоме середнє та ранжування
CREATE OR REPLACE VIEW vw_date_spending_analitics as
WITH invoice_info as (
	SELECT c.first_name || ' ' || c.last_name AS full_name,
			c.customer_id as customer_id,
			i.invoice_id as invoice_id,
			DATE(i.invoice_date) as invoice_date,
			sum(il.quantity*il.unit_price) as invoice_sum
	FROM customer c
	JOIN invoice i using(customer_id)
	JOIN invoice_line il using(invoice_id)
	GROUP BY 1, 2, 3, 4
	)
SELECT full_name, invoice_date, invoice_sum,
			ROW_NUMBER() OVER (
				PARTITION BY customer_id
				ORDER BY invoice_date, invoice_id
			) as invoice_number,
			sum(invoice_sum) OVER (
				PARTITION BY customer_id
				ORDER BY invoice_date, invoice_id
			) as cumulative_spending,
			ROUND(AVG(invoice_sum) OVER (
				PARTITION BY customer_id
				ORDER BY invoice_date, invoice_id
				ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
			), 2) as moving_avg_3_last_invoices
FROM invoice_info;

SELECT * from vw_date_spending_analitics;
		