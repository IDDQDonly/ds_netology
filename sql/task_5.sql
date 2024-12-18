task_6_last.sql--=============== МОДУЛЬ 6. POSTGRESQL =======================================
--= ПОМНИТЕ, ЧТО НЕОБХОДИМО УСТАНОВИТЬ ВЕРНОЕ СОЕДИНЕНИЕ И ВЫБРАТЬ СХЕМУ PUBLIC===========
SET search_path TO public;

--======== ОСНОВНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Напишите SQL-запрос, который выводит всю информацию о фильмах 
--со специальным атрибутом "Behind the Scenes".

explain analyze
select film_id , title, special_features 
from film f
where special_features @> array['Behind the Scenes'] 


--ЗАДАНИЕ №2
--Напишите еще 2 варианта поиска фильмов с атрибутом "Behind the Scenes",
--используя другие функции или операторы языка SQL для поиска значения в массиве.

explain analyze
select film_id , title, special_features
from film f
where special_features && array['Behind the Scenes'] 

explain analyze
select film_id , title, special_features
from film f
where 'Behind the Scenes' in (select unnest(special_features))



--ЗАДАНИЕ №3
--Для каждого покупателя посчитайте сколько он брал в аренду фильмов 
--со специальным атрибутом "Behind the Scenes.

--Обязательное условие для выполнения задания: используйте запрос из задания 1, 
--помещенный в CTE. CTE необходимо использовать для решения задания.

explain analyze
with special as (
	select film_id , title, special_features 
	from film f
	where special_features @> array['Behind the Scenes'] )
select c.customer_id, count(r.rental_id)
from customer c 
join rental r on c.customer_id = r.customer_id 
join inventory i on i.inventory_id = r.inventory_id 
join special s on s.film_id = i.film_id
group by c.customer_id 
order by c.customer_id



--ЗАДАНИЕ №4
--Для каждого покупателя посчитайте сколько он брал в аренду фильмов
-- со специальным атрибутом "Behind the Scenes".

--Обязательное условие для выполнения задания: используйте запрос из задания 1,
--помещенный в подзапрос, который необходимо использовать для решения задания.

explain analyze
select c.customer_id, count(r.rental_id)
from customer c 
join rental r on c.customer_id = r.customer_id 
join inventory i on i.inventory_id = r.inventory_id 
join (	
	select film_id , title, special_features 
	from film f
	where special_features @> array['Behind the Scenes']
) as special on i.film_id = special.film_id 
group by c.customer_id 
order by c.customer_id


--ЗАДАНИЕ №5
--Создайте материализованное представление с запросом из предыдущего задания
--и напишите запрос для обновления материализованного представления


create materialized view special as
	select c.customer_id, count(r.rental_id)
	from customer c 
	join rental r on c.customer_id = r.customer_id 
	join inventory i on i.inventory_id = r.inventory_id 
	join (	
		select film_id , title, special_features 
		from film f
		where special_features @> array['Behind the Scenes']
	) as special on i.film_id = special.film_id 
	group by c.customer_id 
	order by c.customer_id
	
refresh materialized view special




--ЗАДАНИЕ №6
--С помощью explain analyze проведите анализ стоимости выполнения запросов из предыдущих заданий и ответьте на вопросы:
--1. с каким оператором или функцией языка SQL, используемыми при выполнении домашнего задания: 
--поиск значения в массиве затрачивает меньше ресурсов системы;
--2. какой вариант вычислений затрачивает меньше ресурсов системы: 
--с использованием CTE или с использованием подзапроса.
1. в моем случае использование операторов <@ или && работает лучше и затрачивает меньше ресурсов, чем UNNEST
2. в моем случае разница минимальна, я бы даже сказал, что оба эти подхода работает одинаково по затратам ресурсов, но в теории использование CTE на больших данных и сложных запросах должно показывать себя хуже, чем подзапрос




