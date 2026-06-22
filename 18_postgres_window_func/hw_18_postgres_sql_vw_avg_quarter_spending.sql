-- Для кожного менеджера: як змінювались середні витрати клієнтів по кварталах — чи зростали/падали?
--Почни з базового з'єднання таблиць employee, customer, 
--invoice та (можливо) invoice_line, щоб зв’язати менеджера з транзакціями клієнтів.
--Використай DATE_TRUNC('quarter', invoice_date) для визначення кварталу кожної покупки.
--Згрупуй дані за employee_id та кварталом. Обчисли:
--загальну суму продажів
--кількість клієнтів
--середню суму витрат на клієнта
--Використай цей результат як CTE щоб ізольовано працювати з агрегованими даними.
--У другому CTE, застосуй віконну функцію LAG() до середньої суми витрат на клієнта, 
--щоб отримати значення за попередній квартал для кожного працівника.
--Обчисли зміну (change) як різницю між поточним і попереднім значенням.
--За допомогою CASE класифікуй кожен квартал за трендом: зростання, спад чи без змін. 
--Виведи результат з відформатованою назвою кварталу (TO_CHAR) та відсортуй за працівником і часом.
CREATE OR REPLACE VIEW vw_avg_quarter_spending as
WITH quarter_manager_sales AS (
	SELECT e.first_name || ' ' || e.last_name AS manager_full_name,
				DATE_TRUNC('quarter', i.invoice_date) as quarter,
				sum(il.quantity*il.unit_price) as invoice_sum,
				count(DISTINCT customer_id) as cnt_client,
				ROUND(sum(il.quantity*il.unit_price)/count(DISTINCT customer_id), 2)
				as avg_clnt_spending
			FROM employee e
			JOIN customer c ON c.support_rep_id = e.employee_id
			JOIN invoice i using(customer_id)
			JOIN invoice_line il using(invoice_id)
			GROUP BY 1, 2
			),
 	prew_quarter_manager_sales AS (
		SELECT manager_full_name,
				quarter,
				avg_clnt_spending,
				avg_clnt_spending -
				LAG(avg_clnt_spending, 1) OVER (
				PARTITION BY manager_full_name
				ORDER BY quarter
				) as change
			FROM quarter_manager_sales
			)
SELECT manager_full_name, 			
		TO_CHAR(quarter, 'YYYY''"Q"Q') as quarter,
		avg_clnt_spending,
		change,
		CASE 
			WHEN change IS NULL THEN 'Початок періоду'
			WHEN change > 0 THEN 'Зростання'
			WHEN change < 0 THEN 'Спад'
			ELSE 'Без змін'
		END as desc_change
		FROM prew_quarter_manager_sales pq
		ORDER BY 1, 2;
		
SELECT * from vw_avg_quarter_spending;
		