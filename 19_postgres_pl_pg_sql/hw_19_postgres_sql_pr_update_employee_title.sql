--Створіть процедуру pr_update_employee_title(employee_id INT, new_title TEXT), 
--яка оновлює посаду співробітника в таблиці Employee.
CREATE OR REPLACE PROCEDURE pr_update_employee_title(p_employee_id INT, p_new_title TEXT)
LANGUAGE plpgsql
as $$
	BEGIN
		UPDATE employee 
		SET title = p_new_title	WHERE employee_id = p_employee_id;
	END;
	$$;	

--SELECT title from employee where employee_id = 3;

call pr_update_employee_title(3, 'something');--Sales Support Agent

--DROP PROCEDURE pr_update_employee_title(integer,text)