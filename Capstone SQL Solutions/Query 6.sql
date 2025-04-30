-- step 1: participation counts (male vs female per year)
with participation as (
    select
        og.year,
        oab.sex,
        count(distinct oab.athlete_id) as number_of_athletes
    from
        olympic_athlete_event_results oae
    join
        olympic_athlete_bio oab
    on
        oae.athlete_id = oab.athlete_id
    join
        olympics_games og
    on
        oae.edition_id = og.edition_id
    group by
        og.year, oab.sex
),

-- step 2: medal counts (male vs female per year)
medals as (
    select
        og.year,
        oab.sex,
        count(*) as number_of_medals
    from
        olympic_athlete_event_results oae
    join
        olympic_athlete_bio oab
    on
        oae.athlete_id = oab.athlete_id
    join
        olympics_games og
    on
        oae.edition_id = og.edition_id
    where
        oae.medal is not null
        and oae.medal != ''
    group by
        og.year, oab.sex
)

-- step 3: final comparison
select
    p.year,
    p.sex,
    p.number_of_athletes,
    m.number_of_medals
from
    participation p
left join
    medals m
on
    p.year = m.year
    and p.sex = m.sex
order by
    p.year, p.sex;