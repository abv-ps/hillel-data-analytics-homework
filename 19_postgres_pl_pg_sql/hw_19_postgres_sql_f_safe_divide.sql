--Створіть функцію f_safe_divide(numerator INT, denominator INT), 
--яка повертає результат ділення, але повертає NULL, 
--якщо знаменник дорівнює нулю (помилок не виникає)
CREATE OR REPLACE FUNCTION f_safe_divide(numenator INT, denominator INT)
RETURNS NUMERIC
LANGUAGE plpgsql
STRICT
AS $$
BEGIN
	IF denominator = 0 THEN
		RETURN NULL;
	ELSE
		RETURN ROUND(numenator::numeric / denominator, 2);
	END IF;
END;
$$;

SELECT f_safe_divide(7, 3);