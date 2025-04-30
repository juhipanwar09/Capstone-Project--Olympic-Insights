-- Step 1: Create a temp table with one entry per athlete per sport and minimum age
create temporary table temp_medalists as
select
    oab.athlete_id,
    oab.name,
    oab.country,
    oae.sport,
    min(og.year - oab.born) as age
from
    olympic_athlete_event_results oae
join
    olympic_athlete_bio oab on oae.athlete_id = oab.athlete_id
join
    olympics_games og on oae.edition_id = og.edition_id
where
    oae.medal is not null
    and oae.medal != ''
    and oab.born is not null
group by
    oab.athlete_id, oae.sport;

-- Step 2: Assign row numbers to youngest and oldest athletes per sport
with ranked as (
    select *,
        row_number() over (partition by sport order by age asc) as youngest_rank,
        row_number() over (partition by sport order by age desc) as oldest_rank
    from temp_medalists
)
-- Step 3: Pick only top 1 youngest and top 1 oldest per sport
select
    sport,
    name as athlete_name,
    country,
    age,
    case 
        when youngest_rank = 1 then 'youngest'
        when oldest_rank = 1 then 'oldest'
    end as type
from ranked
where youngest_rank = 1 or oldest_rank = 1
order by sport, type;