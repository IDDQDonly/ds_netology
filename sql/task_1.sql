--=============== МОДУЛЬ 2. РАБОТА С БАЗАМИ ДАННЫХ =======================================
--= ПОМНИТЕ, ЧТО НЕОБХОДИМО УСТАНОВИТЬ ВЕРНОЕ СОЕДИНЕНИЕ И ВЫБРАТЬ СХЕМУ PUBLIC===========
SET search_path TO public;

--======== ОСНОВНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Выведите уникальные названия городов из таблицы городов.

select distinct city
from city



--ЗАДАНИЕ №2
--Доработайте запрос из предыдущего задания, чтобы запрос выводил только те города,
--названия которых начинаются на “L” и заканчиваются на “a”, и названия не содержат пробелов.

select distinct city
from city
WHERE city LIKE 'L%a' AND city NOT LIKE '% %'

--ЗАДАНИЕ №3
--Получите из таблицы платежей за прокат фильмов информацию по платежам, которые выполнялись 
--в промежуток с 17 июня 2005 года по 19 июня 2005 года включительно, 
--и стоимость которых превышает 1.00.
--Платежи нужно отсортировать по дате платежа.

select payment_id,payment_date,amount 
from payment
where (payment_date::date between '2005-06-17' and '2005-06-19') and amount > 1
order by payment_date 


--ЗАДАНИЕ №4
-- Выведите информацию о 10-ти последних платежах за прокат фильмов.

select payment_id,payment_date,amount
from payment
order by payment_date desc
limit 10



--ЗАДАНИЕ №5
--Выведите следующую информацию по покупателям:
--  1. Фамилия и имя (в одной колонке через пробел)
--  2. Электронная почта
--  3. Длину значения поля email
--  4. Дату последнего обновления записи о покупателе (без времени)
--Каждой колонке задайте наименование на русском языке.

select concat(first_name, ' ', last_name) "Фамилия и имя", email "Электронная почта", length(email) "Длина Email", date(last_update) "Дата"
from customer 


--ЗАДАНИЕ №6
--Выведите одним запросом только активных покупателей, имена которых KELLY или WILLIE.
--Все буквы в фамилии и имени из верхнего регистра должны быть переведены в нижний регистр.

select lower(last_name),lower(first_name), active
from customer
where active = 1 and (lower(first_name) = 'kelly' or lower(first_name) = 'willie') 


-- не совсем понятно какой столбец брать надо activebool или active 
-- вариант для activebool

select lower(first_name),lower(last_name), activebool 
from customer
where activebool is true and (lower(first_name) = 'kelly' or lower(first_name) = 'willie')


--======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Выведите информацию о фильмах, у которых рейтинг “R” и стоимость аренды указана от 
--0.00 до 3.00 включительно, а также фильмы c рейтингом “PG-13” и стоимостью аренды больше или равной 4.00.

select film_id, title, description,rating,rental_rate 
from film
where (rating = 'R' and rental_rate between 0.00 and 3.00) or (rating = 'PG-13' and rental_rate >= 4.00)

--ЗАДАНИЕ №2
--Получите информацию о трёх фильмах с самым длинным описанием фильма.

select film_id, title, description,length(description)
from film
order by length desc 
limit 3


