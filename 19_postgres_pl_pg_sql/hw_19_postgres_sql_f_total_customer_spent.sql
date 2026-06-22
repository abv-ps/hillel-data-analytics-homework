--Створіть функцію f_total_customer_spent(customer_id INT), 
--яка повертає загальну суму витрат клієнта, використовуючи таблицю Invoice.
CREATE OR REPLACE FUNCTION f_total_customer_spent(v_customer_id INT)
RETURNS NUMERIC
LANGUAGE plpgsql
STRICT
AS $total_client_spent$
DECLARE 
	v_total_sum NUMERIC;
	v_full_name TEXT;
BEGIN
	EXECUTE $client_full_name$
		CREATE OR REPLACE FUNCTION f_client_full_name(v_v_customer_id INT) 
		RETURNS TEXT[] AS $$
		SELECT ARRAY[first_name, last_name]
			FROM customer
			WHERE customer_id = v_v_customer_id
		$$ LANGUAGE SQL;
	$client_full_name$;
	
	EXECUTE $concat_values$
		CREATE OR REPLACE FUNCTION f_concat_values(sep text, VARIADIC arr anyarray) 
		RETURNS text AS $$
	    SELECT array_to_string(arr, sep);
		$$ LANGUAGE SQL;
	$concat_values$;
	
	SELECT f_concat_values(' ', VARIADIC f_client_full_name (v_customer_id))
	INTO v_full_name;
	
	SELECT sum(total) INTO v_total_sum 
	FROM invoice 
	WHERE customer_id = v_customer_id;

	RAISE NOTICE 'Клієнт % загалом витратив %', v_full_name, COALESCE(v_total_sum, 0);

	RETURN COALESCE(v_total_sum, 0);
END;
$total_client_spent$;

SELECT f_total_customer_spent(25);