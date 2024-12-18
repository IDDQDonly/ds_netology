-- 1. Выведите название самолетов, которые имеют менее 50 посадочных мест?

select a.model
from aircrafts a
left join seats s on a.aircraft_code = s.aircraft_code
group by a.aircraft_code 
having count(s.seat_no) < 50

-- 2. Выведите процентное изменение ежемесячной суммы бронирования билетов, округленной до сотых.

select date_trunc('month', book_date) as month, 
round(100.0 * (sum(total_amount) - lag(sum(total_amount)) over (order by date_trunc('month', book_date))) / lag(sum(total_amount)) over (order by date_trunc('month', book_date)),2) as percent_change
from bookings
group by date_trunc('month', book_date)

-- 3. Выведите названия самолетов не имеющих бизнес - класс. Решение должно быть через функцию array_agg.

select model, massive.agg
from aircrafts a 
join(
	select aircraft_code, array_agg(distinct fare_conditions) as agg
	from seats s
	group by aircraft_code
	having not ('Business' = any(array_agg(distinct fare_conditions)))
) as massive on a.aircraft_code = massive.aircraft_code

-- 4. . Вывести накопительный итог количества мест в самолетах по каждому аэропорту на каждый день, 
-- учитывая только те самолеты, которые летали пустыми и только те дни, где из одного аэропорта таких самолетов вылетало более одного.
-- В результате должны быть код аэропорта, дата, количество пустых мест в самолете и накопительный итог.

with EmptyFlights as (
    select
        f.*,count(f.aircraft_code) over(partition by f.departure_airport, f.actual_departure::date) as flight_count
    from flights f
    left join boarding_passes bp on f.flight_id = bp.flight_id
    where bp.boarding_no is null and f.actual_departure is not null),
seat_counts as (
    select s.aircraft_code,count(*) as seat_counts
    from seats s
    group by s.aircraft_code
)
select ef.departure_airport, ef.actual_departure::date, sc.seat_counts,
    sum(sc.seat_counts) over(partition by ef.departure_airport, ef.actual_departure::date order by ef.actual_departure) as totals -- накопительный итог
from EmptyFlights ef
join seat_counts sc on sc.aircraft_code = ef.aircraft_code
where ef.flight_count > 1
order by ef.departure_airport, ef.actual_departure


-- 5. Найдите процентное соотношение перелетов по маршрутам от общего количества перелетов.
-- Выведите в результат названия аэропортов и процентное отношение.
-- Решение должно быть через оконную функцию.


select f.departure_airport_name, f.arrival_airport_name,
    round(count(f.flight_no) * 100.0 / sum(count(f.flight_no)) over (), 2) as percent_of_total_flights
from flights_v f
group by f.departure_airport_name, f.arrival_airport_name

-- 6. Выведите количество пассажиров по каждому коду сотового оператора, если учесть, что код оператора - это три символа после +7

with operators as (
    select substring(contact_data->>'phone' FROM 3 FOR 3) AS operator_code
    from tickets)
select operator_code, count(*)
from operators
group by operator_code
order by count desc

-- 7. Классифицируйте финансовые обороты (сумма стоимости перелетов) по маршрутам:
-- До 50 млн - low
-- От 50 млн включительно до 150 млн - middle
-- От 150 млн включительно - high
-- Выведите в результат количество маршрутов в каждом полученном классе

select finance_class, count(*)
from (
    select sum(tf.amount) AS total_amount,f.departure_airport,f.arrival_airport,
        (case
            when sum(tf.amount) < 50000000 then 'low'
            when sum(tf.amount) >= 50000000 and sum(tf.amount) < 150000000 then 'middle'
            else 'high'
        end )as finance_class
    from ticket_flights tf
    left join flights f on f.flight_id = tf.flight_id
    group by f.departure_airport, f.arrival_airport
) as classified_routes
group by finance_class
order by count 

-- 8. Вычислите медиану стоимости перелетов, медиану размера бронирования и отношение медианы бронирования к медиане стоимости перелетов, округленной до сотых

with ticket_median as (
    select percentile_cont(0.5) within group (order by amount) as median_ticket
    from ticket_flights),
booking_median as (
    select percentile_cont(0.5) within group (order by total_amount) as median_booking
    from bookings)
select t.median_ticket,b.median_booking,round(b.median_booking::numeric / t.median_ticket::numeric, 2) as ratio
from ticket_median t, booking_median b

-- 9. Найдите значение минимальной стоимости полета 1 км для пассажиров. То есть нужно найти расстояние между аэропортами и с учетом стоимости перелетов получить искомый результат
-- Для поиска расстояния между двумя точками на поверхности Земли используется модуль earthdistance.
-- Для работы модуля earthdistance необходимо предварительно установить модуль cube.
-- Установка модулей происходит через команду: create extension название_модуля.

select tf.flight_id, tf.fare_conditions, tf.amount, 
       earth_distance(ll_to_earth(a1.latitude, a1.longitude), ll_to_earth(a2.latitude, a2.longitude)) / 1000 AS distance_km,
       (tf.amount / (earth_distance(ll_to_earth(a1.latitude, a1.longitude), ll_to_earth(a2.latitude, a2.longitude)) / 1000)) AS cost_per_km
from ticket_flights tf
join flights f on tf.flight_id = f.flight_id
join airports a1 on f.departure_airport = a1.airport_code
join airports a2 on f.arrival_airport = a2.airport_code
order by cost_per_km
limit 1