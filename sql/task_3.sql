--=============== МОДУЛЬ 4. УГЛУБЛЕНИЕ В SQL =======================================
--= ПОМНИТЕ, ЧТО НЕОБХОДИМО УСТАНОВИТЬ ВЕРНОЕ СОЕДИНЕНИЕ И ВЫБРАТЬ СХЕМУ PUBLIC===========
SET search_path TO public;

--======== ОСНОВНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--База данных: если подключение к облачной базе, то создаёте новую схему с префиксом в --виде фамилии, название должно быть на латинице в нижнем регистре и таблицы создаете --в этой новой схеме, если подключение к локальному серверу, то создаёте новую схему и --в ней создаёте таблицы.

--Спроектируйте базу данных, содержащую три справочника:
--· язык (английский, французский и т. п.);
--· народность (славяне, англосаксы и т. п.);
--· страны (Россия, Германия и т. п.).
--Две таблицы со связями: язык-народность и народность-страна, отношения многие ко многим. Пример таблицы со связями — film_actor.
--Требования к таблицам-справочникам:
--· наличие ограничений первичных ключей.
--· идентификатору сущности должен присваиваться автоинкрементом;
--· наименования сущностей не должны содержать null-значения, не должны допускаться --дубликаты в названиях сущностей.
--Требования к таблицам со связями:
--· наличие ограничений первичных и внешних ключей.

--В качестве ответа на задание пришлите запросы создания таблиц и запросы по --добавлению в каждую таблицу по 5 строк с данными.
 
--СОЗДАНИЕ ТАБЛИЦЫ ЯЗЫКИ

create schema m4

create table language(
		language_id serial primary key,
		language_name varchar(100) not null unique)

-- ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ ЯЗЫКИ

insert into "language" (language_name) 
values ('Русский'), ('Английский'), ('Французский'), ('Немецкий'), ('Китайский')

--СОЗДАНИЕ ТАБЛИЦЫ НАРОДНОСТИ

create table nationality(
		nationality_id serial primary key,
		nationality_name varchar(100) not null unique)

--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ НАРОДНОСТИ

insert into nationality (nationality_name)
values ('Русские'),('Англичане'), ('Американцы'), ('Канадцы'), ('Французы'), ('Бельгийцы'), ('Немцы'), ('Австрийцы'), ('Швейцарцы'),('Китайцы'), ('Тайваньцы'), ('Сингапурцы')

--СОЗДАНИЕ ТАБЛИЦЫ СТРАНЫ

create table country(
		country_id serial primary key,
		country_name varchar(100)not null unique)

--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ СТРАНЫ

insert into country (country_name)
values ('Россия'),('Казахстан'),('Беларусь'),('Англия'),('США'),('Канада'),('Австралия'),('Франция'),('Бельгия'),('Швейцария'),('Германия'),('Австрия'),('Лихтенштейн'),('Китай'),('Тайвань'),('Сингапур'),('Малайзия'),('Индонезия')


--СОЗДАНИЕ ПЕРВОЙ ТАБЛИЦЫ СО СВЯЗЯМИ

create table language_nationality (
    language_id INT,
    nationality_id INT,
    primary key (language_id, nationality_id),
    foreign key (language_id) references language(language_id),
    foreign key (nationality_id) references nationality(nationality_id))

--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ СО СВЯЗЯМИ

insert into language_nationality (language_id, nationality_id) values
((select language_id from language where language_name = 'Русский'), (select nationality_id from nationality where nationality_name = 'Русские')),
((select language_id from language where language_name = 'Английский'), (select nationality_id from nationality where nationality_name = 'Англичане')),
((select language_id from language where language_name = 'Английский'), (select nationality_id from nationality where nationality_name = 'Американцы')),
((select language_id from language where language_name = 'Английский'), (select nationality_id from nationality where nationality_name = 'Канадцы')),
((select language_id from language where language_name = 'Французский'), (select nationality_id from nationality where nationality_name = 'Французы')),
((select language_id from language where language_name = 'Французский'), (select nationality_id from nationality where nationality_name = 'Бельгийцы')),
((select language_id from language where language_name = 'Немецкий'), (select nationality_id from nationality where nationality_name = 'Немцы')),
((select language_id from language where language_name = 'Немецкий'), (select nationality_id from nationality where nationality_name = 'Австрийцы')),
((select language_id from language where language_name = 'Немецкий'), (select nationality_id from nationality where nationality_name = 'Швейцарцы')),
((select language_id from language where language_name = 'Китайский'), (select nationality_id from nationality where nationality_name = 'Китайцы')),
((select language_id from language where language_name = 'Китайский'), (select nationality_id from nationality where nationality_name = 'Тайваньцы')),
((select language_id from language where language_name = 'Китайский'), (select nationality_id from nationality where nationality_name = 'Сингапурцы'))

--СОЗДАНИЕ ВТОРОЙ ТАБЛИЦЫ СО СВЯЗЯМИ

create table nationality_country (
    nationality_id int,
    country_id int,
    primary key (nationality_id, country_id),
    foreign key (nationality_id) references nationality(nationality_id),
    foreign key (country_id) references country(country_id))

--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ СО СВЯЗЯМИ
insert into nationality_country (nationality_id, country_id) values
((select nationality_id from nationality where nationality_name = 'Русские'), (select country_id from country where country_name = 'Россия')),
((select nationality_id from nationality where nationality_name = 'Русские'), (select country_id from country where country_name = 'Казахстан')),
((select nationality_id from nationality where nationality_name = 'Русские'), (select country_id from country where country_name = 'Беларусь')),
((select nationality_id from nationality where nationality_name = 'Англичане'), (select country_id from country where country_name = 'Англия')),
((select nationality_id from nationality where nationality_name = 'Американцы'), (select country_id from country where country_name = 'США')),
((select nationality_id from nationality where nationality_name = 'Канадцы'), (select country_id from country where country_name = 'Канада')),
((select nationality_id from nationality where nationality_name = 'Англичане'), (select country_id from country where country_name = 'Австралия')),
((select nationality_id from nationality where nationality_name = 'Французы'), (select country_id from country where country_name = 'Франция')),
((select nationality_id from nationality where nationality_name = 'Бельгийцы'), (select country_id from country where country_name = 'Бельгия')),
((select nationality_id from nationality where nationality_name = 'Швейцарцы'), (select country_id from country where country_name = 'Швейцария')),
((select nationality_id from nationality where nationality_name = 'Немцы'), (select country_id from country where country_name = 'Германия')),
((select nationality_id from nationality where nationality_name = 'Австрийцы'), (select country_id from country where country_name = 'Австрия')),
((select nationality_id from nationality where nationality_name = 'Немцы'), (select country_id from country where country_name = 'Лихтенштейн')),
((select nationality_id from nationality where nationality_name = 'Китайцы'), (select country_id from country where country_name = 'Китай')),
((select nationality_id from nationality where nationality_name = 'Тайваньцы'), (select country_id from country where country_name = 'Тайвань')),
((select nationality_id from nationality where nationality_name = 'Сингапурцы'), (select country_id from country where country_name = 'Сингапур')),
((select nationality_id from nationality where nationality_name = 'Китайцы'), (select country_id from country where country_name = 'Малайзия')),
((select nationality_id from nationality where nationality_name = 'Китайцы'), (select country_id from country where country_name = 'Индонезия'))

