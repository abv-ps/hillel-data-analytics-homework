--Створіть тригер у таблиці Invoice, який реєструватиме створення нового рахунку-фактури, 
--вставивши в нову таблицю invoice_audit(invoice_id INT, created_at TIMESTAMP, created_by TEXT). 
--Продемонструйте, що тригер працює - спробуйте щось вставити в Invoice, після чого перевірте invoice_audit.
CREATE TABLE IF NOT EXISTS invoice_audit (
    invoice_id INT,
    created_at TIMESTAMP(0),
    created_by TEXT
);

CREATE OR REPLACE FUNCTION f_tr_invoice_audit()
RETURNS TRIGGER
LANGUAGE plpgsql
as $$
BEGIN
	INSERT INTO invoice_audit(invoice_id, created_at, created_by)
	VALUES (NEW.invoice_id, 
			CURRENT_TIMESTAMP, 
			CURRENT_USER);
	RETURN new;
END;
$$;

CREATE OR REPLACE TRIGGER tr_invoice_audit
	AFTER INSERT ON invoice
	FOR EACH ROW
	EXECUTE FUNCTION f_tr_invoice_audit();

--select max(invoice_id) from invoice;--412

INSERT INTO invoice (invoice_id, customer_id, invoice_date, total)
VALUES (413, 3, '2026-03-18', 53.22);

select * from invoice_audit;
