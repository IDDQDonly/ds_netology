--=============== МОДУЛЬ 5. РАБОТА С POSTGRESQL =======================================
--= ПОМНИТЕ, ЧТО НЕОБХОДИМО УСТАНОВИТЬ ВЕРНОЕ СОЕДИНЕНИЕ И ВЫБРАТЬ СХЕМУ PUBLIC===========
SET search_path TO public;

--======== ОСНОВНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Сделайте запрос к таблице payment и с помощью оконных функций добавьте вычисляемые колонки согласно условиям:
--Пронумеруйте все платежи от 1 до N по дате платежа
--Пронумеруйте платежи для каждого покупателя, сортировка платежей должна быть по дате платежа
--Посчитайте нарастающим итогом сумму всех платежей для каждого покупателя, сортировка должна 
--быть сперва по дате платежа, а затем по размеру платежа от наименьшей к большей
--Пронумеруйте платежи для каждого покупателя по размеру платежа от наибольшего к
--меньшему так, чтобы платежи с одинаковым значением имели одинаковое значение номера.
--Можно составить на каждый пункт отдельный SQL-запрос, а можно объединить все колонки в одном запросе.



select customer_id, payment_id, payment_date,
row_number() over (order by payment_date),
row_number() over (partition by customer_id order by payment_date),
sum(amount) over (partition by customer_id order by payment_date, amount),
rank() over (partition by customer_id order by amount desc)
from payment p 

--ЗАДАНИЕ №2
--С помощью оконной функции выведите для каждого покупателя стоимость платежа и стоимость 
--платежа из предыдущей строки со значением по умолчанию 0.0 с сортировкой по дате платежа.

select customer_id,amount,
LAG(amount,1,0.0) over(partition by customer_id order by payment_date)
from payment p 



--ЗАДАНИЕ №3
--С помощью оконной функции определите, на сколько каждый следующий платеж покупателя больше или меньше текущего.

select customer_id, payment_date,amount,
amount - lag(amount,-1,0.0) over (partition by customer_id order by payment_date)
from payment p 


--ЗАДАНИЕ №4
--С помощью оконной функции для каждого покупателя выведите данные о его последней оплате аренды.


select customer_id, payment_id, amount, payment_date
from (
	select customer_id, payment_id, amount, payment_date,
	max(payment_date) over (partition by customer_id order by payment_date desc) as max_payment_date
	from payment
	) as mx
where payment_date = max_payment_date



--======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--С помощью оконной функции выведите для каждого сотрудника сумму продаж за август 2005 года 
--с нарастающим итогом по каждому сотруднику и по каждой дате продажи (без учёта времени) 
--с сортировкой по дате.


select distinct on (staff_id, payment_date::date) staff_id,payment_date::date,
sum(amount) over (partition by staff_id order by payment_date::date),
SUM(amount) OVER (partition by staff_id, date_trunc('day', payment_date) ORDER BY payment_date::date) as daily_total
from payment p 
where extract (year from payment_date) = 2005 and extract(month from payment_date) = 8	
order by staff_id,payment_date







