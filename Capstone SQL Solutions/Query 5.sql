-- step 1: find number of unique sports per athlete
with athlete_sports as (
    select
        oae.athlete_id,
        count(distinct oae.sport) as number_of_sports
    from
        olympic_athlete_event_results oae
    group by
        oae.athlete_id
)

-- step 2: join with athlete bio and filter athletes with more than one sport
select
    asports.athlete_id,
    oab.name,
    asports.number_of_sports
from
    athlete_sports asports
join
    olympic_athlete_bio oab
on
    asports.athlete_id = oab.athlete_id
where
    asports.number_of_sports > 1
order by
    asports.number_of_sports desc, oab.name;