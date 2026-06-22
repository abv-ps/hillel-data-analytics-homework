SELECT  genre.name, 
		count(track.name) as cnt_track,
		sum(invoice_line.unit_price * invoice_line.quantity) as sum_genre
FROM track 
JOIN genre using(genre_id)
JOIN invoice_line using(track_id)

GROUP BY genre.genre_id
ORDER BY sum_genre desc;

SELECT customer.country, 
		count(DISTINCT customer.customer_id) as cnt_clients,
		sum(invoice_line.unit_price * invoice_line.quantity) as sum_country
FROM invoice
JOIN customer using(customer_id)
JOIN invoice_line using(invoice_id)

GROUP BY customer.country
ORDER BY cnt_clients desc;

SELECT customer.first_name || ' ' || customer.last_name AS client_full_name,
		sum(invoice_line.unit_price * invoice_line.quantity) as sum_client,
		CAST(max(invoice.invoice_date) as DATE) as last_purchase_date,
		CASE WHEN EXTRACT(YEAR FROM max(invoice.invoice_date))<2025 THEN 'lost client'
		ELSE 'current client' END as client_status
FROM invoice
JOIN customer using(customer_id)
JOIN invoice_line using(invoice_id)

GROUP BY customer.customer_id
--HAVING EXTRACT(YEAR FROM max(invoice.invoice_date))<2025
ORDER BY sum_client desc;


SELECT track.track_id, track.name, sum(invoice_line.unit_price * invoice_line.quantity) as sum_track
FROM track
LEFT JOIN invoice_line using(track_id)
WHERE invoice_line.track_id IS NULL
GROUP BY track_id
ORDER BY track.name;

SELECT artist.name, count(track_id) as cnt_track
FROM artist
JOIN album using(artist_id)
JOIN track using(album_id)

GROUP BY artist.artist_id
ORDER BY cnt_track DESC;

SELECT customer.country, 
		genre.name as genre_name, 
		ROUND(sum(invoice_line.unit_price * invoice_line.quantity)
		/ COUNT(DISTINCT customer.customer_id), 2) as avg_revenue
FROM genre
JOIN track using(genre_id)
JOIN invoice_line using(track_id)
JOIN invoice using(invoice_id)
JOIN customer using(customer_id)

GROUP BY customer.country, genre.name
HAVING ROUND(sum(invoice_line.unit_price * invoice_line.quantity) --для наочності - зменшення кількості рядків
		/ COUNT(DISTINCT customer.customer_id), 0) >5
ORDER BY customer.country, avg_revenue DESC;


