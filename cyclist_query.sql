--Overview the dataset
select * 
from cyclist..yearly_cyclist;

-- Explore more about ride_length using simple aggregation functions
select 
	CONVERT(NUMERIC(18, 2), avg(cast(datediff(s, '00:00',ride_length) as bigint))/ 60 + (avg(cast(datediff(s, '00:00',ride_length) as bigint))% 60) / 100.0) as avg_ride_length,
	CONVERT(NUMERIC(18, 2), max(cast(datediff(s, '00:00',ride_length) as bigint))/ 60 + (max(cast(datediff(s, '00:00',ride_length) as bigint))% 60) / 100.0) as max_ride_length, 
	CONVERT(NUMERIC(18, 2), min(cast(datediff(s, '00:00',ride_length) as bigint))/ 60 + (min(cast(datediff(s, '00:00',ride_length) as bigint))% 60) / 100.0) as min_ride_length
from cyclist..yearly_cyclist
where cast(datediff(s, '00:00',ride_length) as bigint) between 60 and 86400;

-- To check how many riders used the bikes for over 12 hours
select 
	count(*) as over_12h_length
from cyclist..yearly_cyclist
where cast(datediff(s, '00:00',ride_length) as bigint) between 43201 and 86400;

-- Less than 0.1% riders who used the bikes for over 12 hours those observations can be considered as outliers
select 
	CONVERT(NUMERIC(18, 2), avg(cast(datediff(s, '00:00',ride_length) as bigint))/ 60 + (avg(cast(datediff(s, '00:00',ride_length) as bigint))% 60) / 100.0) as avg_ride_length,
	CONVERT(NUMERIC(18, 2), max(cast(datediff(s, '00:00',ride_length) as bigint))/ 60 + (max(cast(datediff(s, '00:00',ride_length) as bigint))% 60) / 100.0) as max_ride_length, 
	CONVERT(NUMERIC(18, 2), min(cast(datediff(s, '00:00',ride_length) as bigint))/ 60 + (min(cast(datediff(s, '00:00',ride_length) as bigint))% 60) / 100.0) as min_ride_length
from cyclist..yearly_cyclist
where cast(datediff(s, '00:00',ride_length) as bigint) between 60 and 43200;

-- Explore how the stations are used
select 
	top 10 count(*) as most_start_station,start_station_name
from cyclist..yearly_cyclist
where start_station_name is not null
group by start_station_name
order by most_start_station desc;

select 
	top 10 count(*) as most_end_station,end_station_name
from cyclist..yearly_cyclist
where end_station_name is not null
group by end_station_name
order by most_end_station desc

select 
	top 10 count(*) as least_start_station,start_station_name
from cyclist..yearly_cyclist
where start_station_name is not null
group by start_station_name
order by least_start_station;

select 
	start_station_name
from cyclist..yearly_cyclist
where start_station_name is not null 
group by start_station_name
having count(start_station_name) < 100

select 
	top 10 count(*) as least_end_station,end_station_name
from cyclist..yearly_cyclist
where end_station_name is not null
group by end_station_name
order by least_end_station;

select 
	end_station_name
from cyclist..yearly_cyclist
where end_station_name is not null 
group by end_station_name
having count(end_station_name) < 100

-- What days do users usually use the services?
select 
	count(week_day) as count_day_of_week,
	case
	WHEN week_day = 1 THEN 'Sunday'
	WHEN week_day = 2 THEN 'Monday'
	WHEN week_day = 3 THEN 'Tuesday'
	WHEN week_day = 4 THEN 'Wednesday'
	WHEN week_day = 5 THEN 'Thursday'
	WHEN week_day = 6 THEN 'Friday'
	else 'Saturday'
	end as day_of_week
from cyclist..yearly_cyclist
group by week_day
order by week_day desc

-- At what time of day do users usually start using bikes?
select 
	DATEPART(HOUR, started_at) as start_time, count(DATEPART(HOUR, started_at)) as start_time_count
from cyclist..yearly_cyclist
where cast(datediff(s, '00:00',ride_length) as bigint) between 60 and 43200
group by DATEPART(HOUR, started_at)
order by count(DATEPART(HOUR, started_at)) desc

select 
	DATEPART(HOUR, ended_at) as end_time, count(DATEPART(HOUR, ended_at)) as end_time_count
from cyclist..yearly_cyclist
where cast(datediff(s, '00:00',ride_length) as bigint) between 60 and 43200
group by DATEPART(HOUR, ended_at)
order by count(DATEPART(HOUR, ended_at)) desc
-- Explore about rideable types
select 
	rideable_type, count(rideable_type) as rideable_type_count
from cyclist..yearly_cyclist
where cast(datediff(s, '00:00',ride_length) as bigint) between 60 and 43200
group by rideable_type
order by count(rideable_type) desc;

-- Add member type as a filter in order to explore the difference
select 
	member_casual,count(member_casual) as member_type_count
from cyclist..yearly_cyclist
group by member_casual;

select
	member_casual,
	CONVERT(NUMERIC(18, 2), avg(cast(datediff(s, '00:00',ride_length) as bigint))/ 60 + (avg(cast(datediff(s, '00:00',ride_length) as bigint))% 60) / 100.0) as avg_ride_length,
	CONVERT(NUMERIC(18, 2), max(cast(datediff(s, '00:00',ride_length) as bigint))/ 60 + (max(cast(datediff(s, '00:00',ride_length) as bigint))% 60) / 100.0) as max_ride_length, 
	CONVERT(NUMERIC(18, 2), min(cast(datediff(s, '00:00',ride_length) as bigint))/ 60 + (min(cast(datediff(s, '00:00',ride_length) as bigint))% 60) / 100.0) as min_ride_length
from cyclist..yearly_cyclist
where cast(datediff(s, '00:00',ride_length) as bigint) between 60 and 43200
group by member_casual;

select 
	member_casual,DATEPART(HOUR, started_at) as start_time, count(DATEPART(HOUR, started_at)) as start_time_count
from cyclist..yearly_cyclist
where cast(datediff(s, '00:00',ride_length) as bigint) between 60 and 43200
group by member_casual,DATEPART(HOUR, started_at)
order by member_casual,count(DATEPART(HOUR, started_at)) desc

select 
	DATEPART(HOUR, ended_at) as end_time, count(DATEPART(HOUR, ended_at)) as end_time_count
from cyclist..yearly_cyclist
where cast(datediff(s, '00:00',ride_length) as bigint) between 60 and 43200
group by member_casual,DATEPART(HOUR, ended_at)
order by member_casual,count(DATEPART(HOUR, ended_at)) desc

select 
	member_casual,count(week_day) as count_day_of_week,
	case
	WHEN week_day = 1 THEN 'Sunday'
	WHEN week_day = 2 THEN 'Monday'
	WHEN week_day = 3 THEN 'Tuesday'
	WHEN week_day = 4 THEN 'Wednesday'
	WHEN week_day = 5 THEN 'Thursday'
	WHEN week_day = 6 THEN 'Friday'
	else 'Saturday'
	end as day_of_week
from cyclist..yearly_cyclist
group by member_casual,week_day
order by member_casual,week_day desc

select 
	member_casual,rideable_type, count(rideable_type) as rideable_type_count
from cyclist..yearly_cyclist
where cast(datediff(s, '00:00',ride_length) as bigint) between 60 and 43200
group by member_casual,rideable_type
order by member_casual,count(rideable_type) desc