--=============== МОДУЛЬ 3. ОСНОВЫ SQL =======================================
--= ПОМНИТЕ, ЧТО НЕОБХОДИМО УСТАНОВИТЬ ВЕРНОЕ СОЕДИНЕНИЕ И ВЫБРАТЬ СХЕМУ PUBLIC===========
SET search_path TO public;

--======== ОСНОВНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Выведите для каждого покупателя его адрес проживания, 
--город и страну проживания.


select concat(c.last_name,' ',c.first_name) as "Customer name",a.address,c2.city,c3.country
from customer c 
inner join address a on a.address_id = c.address_id
inner join city c2 on c2.city_id = a.city_id 
inner join country c3 on c3.country_id = c2.country_id



--ЗАДАНИЕ №2
--С помощью SQL-запроса посчитайте для каждого магазина количество его покупателей.

select s.store_id, count(c.customer_id) 
from customer c 
inner join store s on s.store_id = c.store_id 
group by s.store_id 


--Доработайте запрос и выведите только те магазины, 
--у которых количество покупателей больше 300-от.
--Для решения используйте фильтрацию по сгруппированным строкам 
--с использованием функции агрегации.


select s.store_id, count(c.customer_id) as c2
from customer c 
inner join store s on s.store_id = c.store_id 
group by s.store_id
having count(c.customer_id) > 300

-- Доработайте запрос, добавив в него информацию о городе магазина, 
--а также фамилию и имя продавца, который работает в этом магазине.

select s.store_id as "ID магазина", count(c.customer_id) as "Количество покупателей",c2.city as "Город", concat(s2.last_name,' ',s2.first_name) as "Имя сотрудника"
from customer c 
inner join store s on s.store_id = c.store_id 
inner join staff s2 on s2.store_id = s.store_id
inner join address a ON a.address_id = s.address_id
inner join city c2 on c2.city_id  = a.city_id 
group by s.store_id, s2.staff_id ,c2.city_id
having count(c.customer_id) > 300

select *
from address a 

select *
from city c 


--ЗАДАНИЕ №3
--Выведите ТОП-5 покупателей, 
--которые взяли в аренду за всё время наибольшее количество фильмов

select concat(c.last_name,' ', c.first_name) as "Фамилия и имя покупателя", count(p.customer_id)
from customer c 
inner join payment p ON p.customer_id = c.customer_id
group by c.customer_id 
order by count(p.customer_id) desc
limit 5

--ЗАДАНИЕ №4
--Посчитайте для каждого покупателя 4 аналитических показателя:
--  1. количество фильмов, которые он взял в аренду
--  2. общую стоимость платежей за аренду всех фильмов (значение округлите до целого числа)
--  3. минимальное значение платежа за аренду фильма
--  4. максимальное значение платежа за аренду фильма

select concat(c.last_name,' ', c.first_name) as "Фамилия и имя покупателя", count(p.payment_id) "Количество фильмов",round(sum(p.amount)) "Общая стоимость платежей",min(p.amount) "Минимальная стоимость платежей",max(p.amount) "Максимальная стоимость платежей"
from customer c 
left join payment p on p.customer_id = c.customer_id
group by c.customer_id
order by "Фамилия и имя покупателя"


--ЗАДАНИЕ №5
--Используя данные из таблицы городов, составьте все возможные пары городов так, чтобы 
--в результате не было пар с одинаковыми названиями городов. Решение должно быть через Декартово произведение.
 

select c.city,c2.city
from city c 
cross join city c2
where c.city <> c2.city



--ЗАДАНИЕ №6
--Используя данные из таблицы rental о дате выдачи фильма в аренду (поле rental_date) и 
--дате возврата (поле return_date), вычислите для каждого покупателя среднее количество 
--дней, за которые он возвращает фильмы. В результате должны быть дробные значения, а не интервал.
 


   
select customer_id, round(avg(extract(epoch from return_date - rental_date) / 86400.0),2)
from rental
group by customer_id 
order by customer_id 









