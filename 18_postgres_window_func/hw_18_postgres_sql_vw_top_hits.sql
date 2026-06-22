--Які треки були куплені найчастіше в кожному жанрі (по 1 треку на жанр)? 
--Це допомагає зрозуміти «хіти» жанру — хороші кандидати для плейлистів, реклами або рекомендацій.
--об'єднуємо таблиці треків, жанрів та продажів 
--і підсумовуємо кількість куплених копій (SUM(il.Quantity)) 
--для кожного треку
--Застосовуємо ROW_NUMBER()  або DISTINCT ON
CREATE OR REPLACE VIEW vw_top_hits as
WITH track_rank as(
	SELECT g.name as genre_name,
			a.name as artist_name,
			t.name as track_name, 
			sum(il.quantity) as qty_track,
			ROW_NUMBER() OVER (
				PARTITION BY g.name
				ORDER BY sum(il.quantity) DESC, t.track_id
			) as rank_track
	FROM genre g
	JOIN track t using(genre_id)
	JOIN invoice_line il using(track_id)
	JOIN album using(album_id)
	JOIN artist a using(artist_id)
	GROUP BY 1, 2, 3, t.track_id
	)
SELECT genre_name, artist_name, track_name, qty_track
FROM track_rank
WHERE rank_track = 1;

select * from vw_top_hits