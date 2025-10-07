
/*--------------- Perform Basic Analysis ---------------*/
/* overview */
select * from university_rankings limit 10;

/* datatype */
-- broad_impact (null/1 ~ )
select max(broad_impact) as broad_impact_max
,min(broad_impact) as broad_impact_min
,count(*) as total_count
,sum(case when broad_impact = '' then 1 else 0 end) as null_count
,round(100.0 * sum(case when broad_impact = '' then 1 else 0 end) / count(*), 2) AS null_percentage
from university_rankings;

-- score (low ~ 100)
select max(score) as score_max
,min(score) as score_min
from university_rankings;

-- ranks (1 ~ )
select year
,max(world_rank) as max_world
,max(quality_of_education) as max_edu
,max(alumni_employment) as max_alu
,max(quality_of_faculty) as max_fac
,max(publications) as max_pub
,max(influence) as max_inf
,max(citations) as max_cit
,max(patents) as max_pat
from university_rankings 
group by 1
order by 1;

/* distribution */
-- year
select year, count(*) as cnt
from university_rankings
group by 1
order by 1;

2012	100
2013	100
2014	1000
2015	1000

-- country
select country, count(*) as cnt
from university_rankings
where year = 2015
group by 1
order by 2 desc
limit 20;

-- national_rank top 5 (in top 10 countires)
with top_countries as (
	select country, round(avg(score),2) as score_avg
	from university_rankings
	where year = 2015
	group by 1
	order by avg(score) desc 
	limit 10
)
,ranked_universities as(
	select t1.country, t2.score_avg, institution, national_rank, score, year
	,dense_rank() over(partition by t1.country order by national_rank) as rank_ds
	from university_rankings t1
	inner join top_countries t2
	on t1.country = t2.country
	where year = 2015
)

select country, score_avg, institution, national_rank, score, year
from ranked_universities
where rank_ds <= 5 
order by score_avg desc;


/*--------------- CRUD Operations ---------------*/

--1) Create
-- select count(*) from university_rankings; --2200

insert into university_rankings (institution, country, world_rank, score, year)
values ('Duke Tech', 'USA', 350, 60.5, 2014);

-- select count(*) from university_rankings; --2201
-- select institution, country, world_rank, score, year from university_rankings where institution = 'Duke Tech';

--2) Read
select count(*) as cnt
from university_rankings
where country = 'Japan'
  and year = 2013
  and world_rank <= 200;

--3) Update
select institution, country, year, score, world_rank
from university_rankings
where institution = 'University of Oxford'
  and year = 2014;

update university_rankings
set score = score + 1.2
where institution = 'University of Oxford'
  and year = 2014;

--4) Delete
select count(*) as total,
    count(case when score < 45  then 1 end) as delet,
    count(case when score >= 45 then 1 end) as remain
from university_rankings
where year = 2015;

select year, institution, score
from university_rankings
where year = 2015
  and score < 45;

delete from university_rankings
where year = 2015
  and score < 45;

select count(*) from university_rankings where year = 2015;

select year, institution, score
from university_rankings
where year = 2015
  and institution = 'University of Dayton';
