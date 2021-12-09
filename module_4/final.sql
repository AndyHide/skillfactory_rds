-- 4.1
/* выбираем название города и количество аэропортов из таблицы аэропортов, группировка по городу, сортировка по количеству аэропортов по убыванию */

SELECT a.city,
       count(a.airport_code) AS count_airports
FROM dst_project.airports AS a
GROUP BY a.city
ORDER BY 2 DESC

-- 4.2.1
/* подсчитываем количеству уникальных статусов в таблице рейсов */

SELECT count(DISTINCT f.status)
FROM dst_project.flights AS f

--4.2.2
/* подсчитываем количество рейсов в таблице рейсов со статусом "Вылетел" */

SELECT count(f.flight_id)
FROM dst_project.flights AS f
WHERE f.status = 'Departed'

--4.2.3
/* Подсчиытваем количество мест в самолёте из таблицы самолётов и присоединённой к ней таблицы мест по коду самолёта, фильтр по модели */

SELECT count(s.seat_no) AS count_seats
FROM dst_project.aircrafts AS a
LEFT JOIN dst_project.seats AS s ON a.aircraft_code = s.aircraft_code
WHERE model = 'Boeing 777-300'

--4.2.4

SELECT count(DISTINCT f.flight_id)
FROM dst_project.flights AS f
WHERE f.actual_arrival BETWEEN '2017-4-1'::date AND '2017-9-1'::date
  AND f.status = 'Arrived' 
/* Хотелось бы уточнить в условии задачи, что в данные временные рамки должно попасть именно время прилёта.
В первом своём подходе к решению я искал рейсы, которые целиком уложились в заданный интервал, то есть вылетели уже в апреле и приземлились в сентябре и получил неправильный ответ, что считаю неверным.
Условие "Сколько состоявшихся (фактических) рейсов было совершено между X и Y" мне кажется верным трактовать, как "Сколько рейсов целиком попало между X и Y", а не "сколько самолётов приземлилось между X и Y"*/



-- 4.3.1

SELECT count(f.flight_id)
FROM dst_project.flights AS f
WHERE f.status = 'Cancelled'

-- 4.3.2

SELECT count(f.aircraft_code)
FROM dst_project.aircrafts AS f
WHERE (lower(f.model) LIKE '%boeing%')

SELECT count(f.aircraft_code)
FROM dst_project.aircrafts AS f
WHERE (lower(f.model) LIKE '%sukhoi superjet%')

SELECT count(f.aircraft_code)
FROM dst_project.aircrafts AS f
WHERE (lower(f.model) LIKE '%airbus%')

-- 4.3.3

SELECT count(a.airport_code),
       left(a.timezone, position('/' in a.timezone) - 1) AS ZONE
FROM dst_project.airports AS a
GROUP BY ZONE

--4.3.4

SELECT f.flight_id,
       f.actual_arrival - f.scheduled_arrival AS delay
FROM dst_project.flights AS f
WHERE f.status = 'Arrived'
ORDER BY delay DESC
LIMIT 1



-- 4.4.1

SELECT f.scheduled_departure
FROM dst_project.flights AS f
ORDER BY f.scheduled_departure
LIMIT 1

-- 4.4.2

SELECT EXTRACT(epoch FROM f.scheduled_arrival - f.scheduled_departure)/60 AS flight_time
FROM dst_project.flights AS f
ORDER BY flight_time DESC
LIMIT 1

--4.4.3

SELECT EXTRACT(epoch FROM f.scheduled_arrival - f.scheduled_departure)/60 AS flight_time,
       f.departure_airport,
       f.arrival_airport
FROM dst_project.flights AS f
ORDER BY flight_time DESC
LIMIT 1

-- 4.4.4

SELECT avg(extract(epoch FROM f.scheduled_arrival - f.scheduled_departure)/60) AS average_flight_time
FROM dst_project.flights AS f



-- 4.5.1

SELECT s.fare_conditions,
       count(DISTINCT s.seat_no) AS count_seats
FROM dst_project.seats AS s
WHERE s.aircraft_code = 'SU9'
GROUP BY s.fare_conditions
ORDER BY count_seats DESC
LIMIT 1

-- 4.5.2

SELECT b.total_amount
FROM dst_project.bookings AS b
ORDER BY b.total_amount ASC
LIMIT 1

-- 4.5.3

SELECT bp.seat_no
FROM dst_project.tickets AS t
LEFT JOIN dst_project.boarding_passes AS bp ON t.ticket_no = bp.ticket_no
WHERE t.passenger_id = '4313 788533'



-- 5.1.1

SELECT count(DISTINCT flight_id)
FROM dst_project.flights AS f
LEFT JOIN dst_project.airports AS a ON f.arrival_airport = a.airport_code
WHERE a.city = 'Anapa'
  AND extract(YEAR FROM f.actual_arrival) = 2017

-- 5.1.2

SELECT count(DISTINCT f.flight_id)
FROM dst_project.flights AS f
LEFT JOIN dst_project.airports AS a ON f.arrival_airport = a.airport_code
WHERE a.city = 'Anapa'
  AND extract(YEAR FROM f.scheduled_departure) = 2017
  AND extract(MONTH FROM f.scheduled_departure) in (1, 2, 12)
  
-- 5.1.3

SELECT count(DISTINCT f.flight_id)
FROM dst_project.flights AS f
LEFT JOIN dst_project.airports AS a ON f.departure_airport = a.airport_code
WHERE f.status = 'Cancelled'
  AND a.city = 'Anapa'

-- 5.1.4

SELECT count(DISTINCT f.flight_id)
FROM dst_project.flights AS f
LEFT JOIN dst_project.airports AS aa ON f.arrival_airport = aa.airport_code
LEFT JOIN dst_project.airports AS da ON f.departure_airport = da.airport_code
WHERE aa.city != 'Moscow'
  AND da.city = 'Anapa'
  
-- 5.1.5

SELECT a.model,
       count(DISTINCT s.seat_no) AS number_seats
FROM dst_project.flights AS f
LEFT JOIN dst_project.airports AS da ON f.departure_airport = da.airport_code
LEFT JOIN dst_project.aircrafts AS a ON f.aircraft_code = a.aircraft_code
LEFT JOIN dst_project.seats AS s ON f.aircraft_code = s.aircraft_code
WHERE da.city = 'Anapa'
GROUP BY a.model
ORDER BY number_seats DESC
LIMIT 1