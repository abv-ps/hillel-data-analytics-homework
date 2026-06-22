--Які альбоми купують найчастіше, і чи залежить це від жанру?
--Знайти альбоми (10) з найбільшою кількістю продажів.
--Перевірити, які жанри представлені серед цих альбомів.
--Зрозуміти, чи деякі з цих жанри частіше зустрічаються.


CREATE OR REPLACE VIEW vw_genre_album_count_info as
		SELECT t.album_id as album_id, a.title as album_title,
				g.name as genre_name,
				sum(il.quantity) as qty
		FROM album a
		JOIN track t using(album_id)
		JOIN genre g using(genre_id)
		JOIN invoice_line il using(track_id)
		GROUP BY 1, 2, 3;

--SELECT * FROM vw_genre_album_count_info
--SELECT sum(qty) FROM vw_genre_album_count_info

CREATE TEMP TABLE top_10_albums as
SELECT album_id, album_title, sum(qty) as qty
FROM vw_genre_album_count_info
GROUP BY 1, 2
ORDER BY qty DESC
LIMIT 10;

SELECT * FROM top_10_albums; --топ 10 альбомів з найбільшою кількістю продаж

CREATE TEMP TABLE top_10_albums_genres as
SELECT genre_name, album_id, album_title
FROM vw_genre_album_count_info
WHERE album_id in (SELECT album_id FROM top_10_albums)
ORDER BY album_id

--SELECT * FROM top_10_albums_genres

SELECT DISTINCT genre_name FROM top_10_albums_genres; --перелік жанрів топ 10 альбомів

SELECT genre_name, COUNT(genre_name) as cnt_genre
FROM top_10_albums_genres
GROUP BY 1
ORDER BY cnt_genre DESC; --скільки разів жанр із топ 10 альбомів зустрічається в переліку
--Альбоми, у яких жанр Рок, купують частіше, зрештою це показує статистика і за кількістю треків,
--і за кількістю рядків жанра у топ 10 альбомах з найбільшою кількістю продаж.
--Тобто якщо в альбомі будуть рокові треки, цей альбом буде краще продаватись.

--select sum(il.quantity) as qty from invoice_line il