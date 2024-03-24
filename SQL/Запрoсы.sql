/*
Разные виды запросов
включающие группировки, JOIN'ы, вложенные запросы
*/
USE netbookshop;

-- Вывести авторов книг, книги которых присутствуют в магазине. 
SELECT 
concat (a.lastname, ' ', a.firstname, ' ', a.middlename ) AS 'Фамилия, имя'
FROM author a 
GROUP BY firstname ;-- группировка позволяет выести автора один раз, что нам и нужно

-- Вывести книги, которых осталось в наличии менее 100 экземпляров.
-- Сгруппировать по возрастанию остатков
SELECT 
id AS 'ISBN',
name AS 'Название книги',
quant AS 'Количество'
FROM book
WHERE quant < 100
ORDER BY quant ;

-- Вывести книги, у которых 'жесткая' обложка (вложенный запрос)
SELECT 
concat (id, ' ', name) AS 'Код, название книги'
FROM book  
WHERE cover_id = (SELECT id FROM cover WHERE typee = 'Жесткая') ;

-- Вывести книги, у которых автор Петров (вложенный/вложенный запрос)
SELECT 
id AS 'ISBN',
name AS 'Название книги'
FROM book
WHERE id = (
	SELECT book_id FROM book_has_author WHERE author_id = 
	(SELECT id FROM author WHERE lastname = 'По')
	)
;


-- Вывести список покупателей-женщин,
-- имеющими адрес в г. Москва и Московской области

SELECT 
b.lastname AS 'Фамилия',
b.firstname AS 'Имя',
b.middlename AS 'Отчество',
floor((to_days(NOW()) - to_days(b.birthday))/365.25) AS 'Возраст'

FROM buyers b
JOIN delivery_address da ON b.id = da.buyers_id 
WHERE b.sex = 'F' AND da.region_id IN(50, 77);


-- Вывести содержимое корзины конкретного покупателя
SELECT 
concat (b.lastname, ' ', b.firstname ) AS 'Фамилия, имя', 
-- WHERE id = bo.buyers_id) AS name,
book_id AS ISBN,
b2.name AS 'Название книги',
quantity AS 'Количество'
FROM basket_order bo 
JOIN book b2 ON bo.book_id = b2.id 
JOIN buyers b ON bo.buyers_id = b.id 
WHERE buyers_id = 1 ;











