SELECT title || ' by ' || COALESCE(authors, translators, 'Unknown Author') AS full_info
FROM books;

select * from books where download_count>25000;

select * from books where languages in ('en', 'es');

select * from books where copyright = false;

select * from books where formats LIKE 'text%';

select * from books where subjects LIKE '%Gothic fiction%';

select * from books ORDER BY download_count DESC LIMIT 5;

select * from books 
WHERE (languages = 'en' AND copyright = true ) OR (languages = 'es');

select DISTINCT authors from books where authors IS NOT NULL;