-- step 1: find medal counts per athlete
with athlete_medals as (
    select
        oae.athlete_id,
        count(*) as total_medals
    from
        olympic_athlete_event_results oae
    where
        oae.medal is not null
        and oae.medal != ''
    group by
        oae.athlete_id
)

-- step 2: join with athlete bio for names
select
    amb.athlete_id,
    oab.name,
    amb.total_medals
from
    athlete_medals amb
join
    olympic_athlete_bio oab
on
    amb.athlete_id = oab.athlete_id
order by
    amb.total_medals desc
limit 20;