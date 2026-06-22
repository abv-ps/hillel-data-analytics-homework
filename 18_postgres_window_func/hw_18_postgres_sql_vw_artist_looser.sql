--Знайди артистів, чиї альбоми не містять жодного треку, який було куплено хоча б один раз. 
--Які артисти "не приносять грошей взагалі"
--Для кожного артиста перевіряємо, чи існує хоч один куплений трек цього артиста
--Використовуємо NOT EXISTS з корельованим підзапитом або JOIN 
CREATE OR REPLACE VIEW vw_artist_looser as
	SELECT DISTINCT a.name as artist_name, al.title as album_title
	FROM artist a
	JOIN album al using(artist_id) 
	WHERE NOT EXISTS (
					SELECT 1
					FROM track t
					JOIN invoice_line il using(track_id)
					WHERE t.album_id = al.album_id
	);
			
SELECT * from vw_artist_looser