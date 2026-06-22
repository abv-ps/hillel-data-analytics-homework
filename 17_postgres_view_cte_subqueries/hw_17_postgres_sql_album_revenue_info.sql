--Чи приносять альбоми з треками кількох жанрів більше доходу, ніж альбоми з треками лише одного жанру?
 --Визначте, скільки різних жанрів має кожен альбом
--Обчисліть дохід, отриманий від кожного альбому
--Порівняйте середній дохід між альбомами з 1, 2, 3,... жанрами.
CREATE OR REPLACE VIEW vw_genre_album_spending_info as
	SELECT g.name as genre_name, a.album_id, a.title, sum(il.quantity*il.unit_price) as total_sum
	FROM invoice_line il
	JOIN track t using(track_id)
	JOIN genre g using(genre_id)
	JOIN album a using(album_id)
	GROUP BY 1, 2, 3;
--SELECT * FROM vw_genre_album_spending_info

SELECT title, COUNT(genre_name) as cnt_genre 
FROM vw_genre_album_spending_info
GROUP BY 1
ORDER BY cnt_genre DESC;--кількість жанрів для кожного альбома

SELECT title, sum(total_sum) as total_sum
FROM vw_genre_album_spending_info
GROUP BY 1
ORDER BY total_sum DESC;--дохід від кожного альбома

SELECT cnt_genre, 
		round(AVG(album_total_sum), 2) as avg_album_sum, 
		count(album_id) as cnt_album
FROM (
	SELECT album_id, 
			COUNT(DISTINCT genre_name) as cnt_genre,  
			sum(total_sum) as album_total_sum
	FROM vw_genre_album_spending_info
	GROUP BY 1
	ORDER BY cnt_genre DESC
	)
GROUP BY cnt_genre
ORDER BY cnt_genre;
--Середній дохід збільшується відповідно до кількості жанрів в альбомі,
--напевне меломанам подобається більша різноманітність, що
--також опосеродковано підтверджується наявністю shuffle у всіх популярних плеєрах та музичних сервісах.