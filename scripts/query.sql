
/* overview */
select * from university_rankings limit 10;

-- distribution
select year, count(*) as cnt
from university_rankings
group by 1
order by 1

2012	100
2013	100
2014	1000
2015	1000

-- datatype
-- broad_impact (null/1)
select max(broad_impact) as broad_impact_max
,min(broad_impact) as broad_impact_min
from university_rankings

-- score (low ~ 100)
select max(score) as score_max
,min(score) as score_min
from university_rankings

-- patents (1 ~ 871)
select max(patents) as var_max
,min(patents) as var_min
from university_rankings