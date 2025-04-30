-- step 1: count distinct athletes per country
with country_athletes as (
    select
        oab.country,
        count(distinct oab.athlete_id) as total_athletes
    from
        olympic_athlete_event_results oae
    join
        olympic_athlete_bio oab
    on
        oae.athlete_id = oab.athlete_id
    group by
        oab.country
),

-- step 2: count total medals per country
country_medals as (
    select
        oab.country,
        count(*) as total_medals
    from
        olympic_athlete_event_results oae
    join
        olympic_athlete_bio oab
    on
        oae.athlete_id = oab.athlete_id
    where
        oae.medal is not null
        and oae.medal != ''
    group by
        oab.country
)

-- step 3: calculate medal conversion efficiency
select
    ca.country,
    ca.total_athletes,
    cm.total_medals,
    round((cm.total_medals / ca.total_athletes) * 100, 2) as medals_per_100_athletes
from
    country_athletes ca
left join
    country_medals cm
on
    ca.country = cm.country
where
    ca.total_athletes > 0
order by
    medals_per_100_athletes desc;