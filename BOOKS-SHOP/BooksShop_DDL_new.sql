-- Книжный интернет-магазин"
-- Здесь также приведен код представлений, триггеров и процедур

DROP DATABASE IF EXISTS NetBookShop;
CREATE DATABASE NetBookShop;
USE NetBookShop;

/*-- -----------------------------------------------------
-- Table cover
Вид обложки книги
-- -----------------------------------------------------*/
CREATE TABLE IF NOT EXISTS cover (
  id INT UNSIGNED NOT NULL,
  typee VARCHAR(50) NOT NULL COMMENT 'Тип обложки книги',
  PRIMARY KEY (id)
  );

 
 /*  -----------------------------------------------------
 Table publisher
 Tаблица для хранения данных по издательству книги. 
Организована связь \"один ко многим\" с книгами, т.к. издательство может издавать много разных книг, 
но книгу с конкретным ISBN (первичный ключ таблицы book) может издать только одно издательство.
-- -----------------------------------------------------*/
 CREATE TABLE IF NOT EXISTS publisher (
  id TINYINT UNSIGNED NOT NULL COMMENT 'Первичный ключ - стандартизованный код издательства (третья группа цифр в коде ISBN)',
  name VARCHAR(100) NOT NULL COMMENT 'Название издательства',
  country VARCHAR(50) NOT NULL COMMENT 'Страна, где находится издательство',
  town VARCHAR(40) NOT NULL COMMENT 'Город, где находится издательство',
  PRIMARY KEY (id)
 );
 
  /*-- -----------------------------------------------------
-- Table ganres
Таблица с перечнем жанров, к которым можно отнести книгу
-- -----------------------------------------------------*/
CREATE TABLE IF NOT EXISTS ganres (
  id TINYINT NOT NULL,
  name VARCHAR(50) NOT NULL COMMENT 'Наименование жанра',
  PRIMARY KEY (id),
  INDEX `ganre_name_idx` (name) 
);

 
 /*-- -----------------------------------------------------
-- Table author
Таблица основных сведений об авторе
-- -----------------------------------------------------*/
CREATE TABLE IF NOT EXISTS author (
  id INT NOT NULL, -- AUTO_INCREMENT,
  lastname VARCHAR(45) NOT NULL COMMENT 'Фамилия',
  firstname VARCHAR(40) NULL COMMENT 'Имя',
  middlename VARCHAR(45) NULL COMMENT 'Отчество (если есть)',
  birthday_year VARCHAR(20) NULL COMMENT 'Год рождения автора. Если это древние философы, может быть и до н.э. 
											Поэтому определяем тип как VARCHAR',
  biography TEXT NULL COMMENT 'Краткая биография',
  -- photo_id INT NOT NULL COMMENT 'Ссылка на таблицу с указателями фото автора.',
  PRIMARY KEY (id),
  INDEX `fk_author_lastname_idx` (lastname) 
   );
 
  /*-- -----------------------------------------------------
-- Table `photo`
 Таблица для хранения сылок на графические файлы,
 в которых представлены фото автора 
 Имеется возможность разместить несколько фото автора для лучшего представления покупателю.
-- -----------------------------------------------------*/
CREATE TABLE IF NOT EXISTS author_photo (
  id INT NOT NULL,
  id_author INT NOT NULL COMMENT 'Ccылка на автора. ',
  photo VARCHAR(250) NOT NULL COMMENT 'Ссылка на файл, где расположено фото автора.',
  PRIMARY KEY (id),
  FOREIGN KEY (id_author) REFERENCES author(id) ON DELETE NO ACTION ON UPDATE NO ACTION
  );  
  /*-- -----------------------------------------------------
-- Table `book`
Основная таблица БД. Здесь содержатся данные о книге.
-- -----------------------------------------------------*/
CREATE TABLE IF NOT EXISTS book (
  id VARCHAR(50) NOT NULL COMMENT 'Первичный ключ - уникальный код книги. 
	Представляет собой Международный стандартный книжный номер (International Standard Book Number, сокращённо — ISBN) . 
	Состоит из цифр и букв.',
  name VARCHAR(200) NOT NULL COMMENT 'Название книги',
  pages SMALLINT UNSIGNED NOT NULL COMMENT 'Количество страниц',
  yearr YEAR NULL COMMENT 'Год издания книги',
  publisher_id TINYINT UNSIGNED NOT NULL COMMENT 'Ссылаемся на издателя',
  cover_id INT UNSIGNED NOT NULL COMMENT 'Ссылаемся на тип обложки',
  price DECIMAL(8,2) UNSIGNED NOT NULL COMMENT 'Цена для покупателя',
  quant SMALLINT UNSIGNED NOT NULL COMMENT 'Количество экземпляров книги, доступных в настоящий момент для продажи.',
  annotation TEXT COMMENT 'Краткая аннотация на данную книгу',
  PRIMARY KEY (id),
INDEX book_name_idx(name)  COMMENT 'Индексируемся по названию книги',

 
    FOREIGN KEY (cover_id) REFERENCES cover(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (publisher_id) REFERENCES publisher(id) ON DELETE NO ACTION ON UPDATE NO ACTION
   );  
  
/*-- -----------------------------------------------------
-- Table `photo`
 Таблица для хранения сылок на графические файлы,
 в которых представлены фото книги 
 Имеется возможность разместить несколько фото книги для лучшего представления покупателю.
-- -----------------------------------------------------*/
CREATE TABLE IF NOT EXISTS book_photo (
  id INT NOT NULL,
  id_book VARCHAR(50) NOT NULL COMMENT 'Первичный ключ - уникальный код книги. ',
  photo VARCHAR(250) NOT NULL COMMENT 'Ссылка на файл, где расположено фото книги.',
  PRIMARY KEY (`id`),
  FOREIGN KEY (id_book) REFERENCES book(id) ON DELETE CASCADE ON UPDATE CASCADE
  );  
  
/*-- -----------------------------------------------------
-- Table book_has_ganres
Промежуточная таблица для организации связи 
многие ко многим\" между книгой и жанром. 
У каждой книги может быть перечислено несколько жанров (например, \"История\", \"Детектив\"), 
что расширит возможность поиска интересующих книг для покупателя. '
-- -----------------------------------------------------*/
CREATE TABLE IF NOT EXISTS book_has_ganres (
  book_id VARCHAR(50) NOT NULL,
  ganres_id TINYINT NOT NULL COMMENT 'Название жанра. У одной книги их может быть несколько.',
  PRIMARY KEY (`book_id`, `ganres_id`),
  -- INDEX (ganres_id),
  -- INDEX (book_id),
  FOREIGN KEY (book_id) REFERENCES book(id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  FOREIGN KEY (ganres_id)
    REFERENCES ganres(id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;

/*-- -----------------------------------------------------
-- Table book_has_author
Промежуточная таблица для организации связи \"многие ко многим\" между книгой и автором. 
У каждой книги может быть  несколько авторов.
-- -----------------------------------------------------*/
CREATE TABLE IF NOT EXISTS book_has_author (
  book_id VARCHAR(50) NOT NULL,
  author_id INT NOT NULL,
  num_order INT COMMENT 'Порядок расположения авторов при вызове информации о книге.
			Обычно первыми идут наиболее известные',
  PRIMARY KEY (`book_id`, `author_id`),
  -- INDEX `fk_book_has_author_author1_idx` (`author_id` ASC) VISIBLE,
  -- INDEX `fk_book_has_author_book1_idx` (`book_id` ASC) VISIBLE,
    FOREIGN KEY (book_id) REFERENCES book(id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    FOREIGN KEY (author_id) REFERENCES author(id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
  );
 
 
/*-- -----------------------------------------------------
-- Table buyers
Таблица с общими данными покупателей книг
-- -----------------------------------------------------*/
CREATE TABLE IF NOT EXISTS buyers (
  id INT NOT NULL,
  lastname VARCHAR(45) NOT NULL COMMENT 'Фамилия покупателя',
  firstname VARCHAR(45) NOT NULL COMMENT 'Имя покупателя',
  middlename VARCHAR(45) COMMENT 'Отчество покупателя (если есть)',
  sex ENUM('F', 'M') COMMENT 'Пол покупателя',
  birthday DATE COMMENT 'Дата рождения покупателя',
  phone VARCHAR(20) NOT NULL COMMENT 'Телефон покупателя',
  email VARCHAR(100) NOT NULL COMMENT 'Электронная почта покупателя',
  PRIMARY KEY (`id`),
  INDEX `id_buyers_idx` (id)

); 
 
/*-- -----------------------------------------------------
-- Table `NetBookShop`.`employee`
Сведения о сотруднике магазина
-- -----------------------------------------------------*/
CREATE TABLE IF NOT EXISTS employee (
  id INT NOT NULL COMMENT 'Табельный номер сотрудника',
  lastname VARCHAR(45) NOT NULL COMMENT 'Фамилия',
  firstname VARCHAR(45) NOT NULL COMMENT 'Имя',
  middlename VARCHAR(45) COMMENT 'Отчество',
  int_phone INT NOT NULL COMMENT 'Внутренний телефон',
  mob_phone VARCHAR(20) COMMENT 'Мобильный телефон',
  PRIMARY KEY (`id`),
  INDEX `id_lastname_empl_idx` (lastname)
);

 /*-- -----------------------------------------------------
-- Table regions
Таблица с перечнем названий субъектов РФ.
ID соответствует официально принятому номеру региона
-- -----------------------------------------------------*/
CREATE TABLE IF NOT EXISTS region (
  id INT(2) NOT NULL,
  name VARCHAR(100) NOT NULL COMMENT 'Название субъекта РФ',
  PRIMARY KEY (id),
  INDEX `region_name_idx` (name) 
);

/*-- -----------------------------------------------------
-- Table `NetBookShop`.`delivery_address`
Таблица с адресами клиентов, в которые осуществляется доставка книг
-- -----------------------------------------------------*/
CREATE TABLE IF NOT EXISTS delivery_address (
  id INT NOT NULL,
  region_id INT(2) NOT NULL COMMENT 'Код региона РФ (республика, край, область, город федерального значения)',
  address VARCHAR(100) NOT NULL COMMENT 'Полный адрес (без региона и индекса)',
  postcode INT(6) NOT NULL COMMENT 'Почтовый индекс',
  buyers_id INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_delivery_address_id_region_idx` (region_id),
 FOREIGN KEY (region_id) REFERENCES region(id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  FOREIGN KEY (buyers_id) REFERENCES buyers(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

/*-- -----------------------------------------------------
-- Table orders_main
Таблица, в которой формируется основная информация по заказам, сделанным покупателями
-- -----------------------------------------------------*/
CREATE TABLE IF NOT EXISTS orders_main (
  id SERIAL PRIMARY KEY COMMENT 'Первичный ключ',
  date_begin DATE NOT NULL COMMENT 'Дата оформления заказа',
  buyers_id INT NOT NULL COMMENT 'Код покупателя',
  delivery_address_id INT NOT NULL COMMENT 'Связь с адресом доставки',
  INDEX `fk_date_begin_idx` (date_begin)
  /*
    FOREIGN KEY (buyers_id) REFERENCES buyers(id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    
    FOREIGN KEY (delivery_address_id) REFERENCES delivery_address(id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
   */
    );
   
/*-- -----------------------------------------------------
-- Table orders_add
Таблица, в которой отражаюется служебная информация по заказам покупателя.
Связана с основной таблицей orders_main связью типа 'один к одному'
-- -----------------------------------------------------*/
CREATE TABLE IF NOT EXISTS orders_add (    
order_id BIGINT UNSIGNED NOT NULL COMMENT 'Первичный ключ. Соответствует ключу таблицы orders_main',
  employee_id INT NULL COMMENT 'Табельный номер сотрудника, ответственного за выполнение заказа',
  status_delivered INT(1) NOT NULL DEFAULT 0 COMMENT 'Отметка о выполнении заказа. По умолчанию заказ не выполнен (0)',
  PRIMARY KEY (order_id),
  
FOREIGN KEY (order_id) REFERENCES orders_main(id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  
    FOREIGN KEY (employee_id) REFERENCES employee(id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    );
    

/*-- -----------------------------------------------------
-- Table basket_order
   Таблица "корзина заказа". В одном заказе может быть несколько разных книг. 
   При этом может быть несколько штук любого экземпляра.
-- -----------------------------------------------------*/
CREATE TABLE IF NOT EXISTS basket_order (
  buyers_id INT NOT NULL,
  book_id VARCHAR(50) NOT NULL,
  quantity TINYINT NOT NULL DEFAULT 1 COMMENT 'Количество книг данного типа. По умолчанию - одна штука.',
  PRIMARY KEY (`buyers_id`, `book_id`),
     FOREIGN KEY (buyers_id) REFERENCES buyers(id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    FOREIGN KEY (book_id) REFERENCES book(id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

/*-- -----------------------------------------------------
-- Table detail_order
   Таблица "детализация заказа". Это уже окончательно сформированный заказ по книгам и их количеству.
   В отличие от оперативной корзины покупателя (basker_orders), это уже окончательный заказ.
-- -----------------------------------------------------*/
CREATE TABLE IF NOT EXISTS detail_order (
  id SERIAL PRIMARY KEY,
  buyers_id INT NOT NULL,
  book_id VARCHAR(50) NOT NULL,
  quantity TINYINT NOT NULL DEFAULT 1 COMMENT 'Количество книг данного типа. По умолчанию - одна штука.',
  order_id BIGINT UNSIGNED COMMENT 'Ссылка на таблицу заказов orders');
 /*  
     FOREIGN KEY (buyers_id) REFERENCES buyers(id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    FOREIGN KEY (book_id) REFERENCES book(id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    FOREIGN KEY (order_id) REFERENCES orders_main(id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION


*/

/*-- -----------------------------------------------------
-- Table choice
   Таблица "выбор покупателя". В эту таблицу заносятся данные о выборе покупателями книг
   (когда был сделан отбор книги в корзину). При этом неважно, попала книга в заказ или нет.
   Важен сам факт, что книгой покупатель интересовался. Соответственно, данная информация в дальнейшем имеет ценность
   для планирования закупок тех или иных книг, а также предпочтений конкретного покупателя. 
   Все это представляет интерес для планирования коммерческой деятельности.
   Информация в таблицу заносится с помощью триггера.
   -- -----------------------------------------------------*/
DROP TABLE IF EXISTS choice;
CREATE TABLE choice (
	created_at DATETIME NOT NULL COMMENT 'Время-дата интереса.',
	buyers_id INT NOT NULL COMMENT 'Покупатель.',
    book_id VARCHAR(50) NOT NULL COMMENT 'Книга.'
	
) ENGINE = ARCHIVE;

/*
 * Представление для выбора книг конкретного автора
 Хранимое представление aut:*/
DROP table IF EXISTS aut;
CREATE VIEW aut AS
SELECT b.id, b.name
FROM book b
JOIN book_has_author bha ON b.id = bha.book_id 
JOIN author a ON bha.author_id = a.id 
WHERE a.lastname = 'Петров';


/*
 * Представление для выбора книг конкретного жанра
Хранимое представление ganr: */
CREATE VIEW ganr AS
SELECT b.id, b.name, b.yearr 
FROM book b
JOIN book_has_ganres bhg  ON b.id = bhg.book_id 
JOIN ganres g  ON bhg.ganres_id = g.id 
WHERE g.name LIKE 'Приключ%';

/*-- -----------------------------------------------------
-- Trigger choice_users
   Триггер предназначен для вноса информации о выборе покупателя с целью ее дальнейшего анализа
   (см. комментарий к таблице choice).
   -- -----------------------------------------------------*/
DROP TRIGGER IF EXISTS choice_users;
delimiter //
CREATE TRIGGER choice_users AFTER INSERT ON basket_order
FOR EACH ROW
BEGIN
	INSERT INTO choice (created_at, buyers_id, book_id)
	VALUES (NOW(), NEW.buyers_id, NEW.book_id);
END //
delimiter ;
  
/*-- -----------------------------------------------------
-- Trigger connecting_add
   Триггер предназначен для обеспечения целостности таблиц order_main - order_add.
   -- -----------------------------------------------------*/

DROP TRIGGER IF EXISTS connecting_add;
delimiter //
CREATE TRIGGER connecting_add AFTER INSERT ON orders_main
FOR EACH ROW 
BEGIN 
		INSERT INTO orders_add (order_id)
		VALUES (NEW.id);
		END //
delimiter ;
  
 -- Процедура формирования запроса количества женщин в БД.
	DROP PROCEDURE IF EXISTS netbookshop.HOW_MANY_WOMAN;
DELIMITER $$
$$
CREATE PROCEDURE netbookshop.HOW_MANY_WOMAN()
BEGIN
	SELECT COUNT(*)
	FROM buyers 
	WHERE sex = 'F';
END $$
DELIMITER ;


-- Процедура формирования заказа покупателя из его корзины.
	-- Формируем запись заказа в таблице orders_main
	-- входные данные - id пользователя и id его адреса доставки 
DELIMITER // 
CREATE PROCEDURE buyer_order(IN id INT, address INT)
BEGIN
	INSERT INTO orders_main (date_begin, buyers_id, delivery_address_id)
	VALUES (CURDATE(), id, address);
SELECT LAST_INSERT_ID();

-- Копируем данные о книгах и их количестве из корзины заказа в таблицу detail_order
-- связь - по ID пользователя
INSERT INTO detail_order (buyers_id, book_id, quantity)
SELECT buyers_id, book_id, quantity
	FROM basket_order  
	WHERE buyers_id = id;

-- вводим в таблицу со спецификацией заказа номер заказа
UPDATE detail_order 
SET order_id = LAST_INSERT_ID()
WHERE buyers_id = id;

-- После формирования заказа корзина покупателя должны быть очищена
DELETE FROM basket_order 
WHERE buyers_id = id;
END//
