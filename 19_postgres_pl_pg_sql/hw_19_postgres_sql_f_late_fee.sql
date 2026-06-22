--Створіть функцію f_late_fee(deadline_date DATE, fee_per_day NUMERIC), 
--яка розраховує пеню за прострочення на основі кількості днів після заданого терміну.
--Якщо термін_закінчення знаходиться в майбутньому або сьогодні, повернути 0.
--Якщо термін минув, обчислити:
--days_late = today - deadline_date
--late_fee = days_late × fee_per_day
--Повернути загальну суму комісії у вигляді числового значення.
CREATE OR REPLACE FUNCTION f_late_fee(deadline_date DATE, fee_per_day NUMERIC)
RETURNS NUMERIC
LANGUAGE plpgsql
STRICT
AS $$
DECLARE
	days_late INTEGER;
BEGIN
	IF deadline_date >= CURRENT_DATE OR fee_per_day <= 0 THEN
		RETURN 0;
	ELSE
		days_late := CURRENT_DATE - deadline_date;
		RETURN days_late * fee_per_day;
	END IF;
END;
$$;

SELECT f_late_fee(date('2026-03-12'), -4.16::numeric);