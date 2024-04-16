-- 
use netbookshop;
/*
 * Представление для выбора книг конкретного автора
 Хранимое представление aut:
DROP table IF EXISTS aut;
CREATE VIEW aut AS
SELECT b.id, b.name
FROM book b
JOIN book_has_author bha ON b.id = bha.book_id 
JOIN author a ON bha.author_id = a.id 
WHERE a.lastname = 'Петров';
*/
-- Использование представления внутри другого запроса
SELECT * FROM aut
WHERE name LIKE 'Золотой %' ;

/*
 * Представление для выбора книг конкретного жанра
Хранимое представление ganr:
CREATE VIEW ganr AS
SELECT b.id, b.name, b.yearr 
FROM book b
JOIN book_has_ganres bhg  ON b.id = bhg.book_id 
JOIN ganres g  ON bhg.ganres_id = g.id 
WHERE g.name LIKE 'Приключ%';

 */
-- Использование представления внутри другого запроса
-- для вывода книг, изданных между 2018 и 2020 гг
SELECT * FROM ganr
WHERE yearr BETWEEN 2018 AND 2020;


/*
SELECT a.id, a.lastname, bha.book_id AS book, 
GROUP_CONCAT(b.name)
FROM
  author a
  INNER JOIN 
  book_has_author bha
    ON a.id = bha.author_id
  LEFT JOIN book b
    ON b.id = bha.book_id 
  GROUP BY a.lastname;
*/