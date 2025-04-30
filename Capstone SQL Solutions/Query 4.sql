-- step 1: count medals per country per event
with event_country_medals as (
    select
        oae.event,
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
        oae.event, oab.country
),

-- step 2: rank countries per event based on medal count
event_country_ranked as (
    select
        ecm.event,
        ecm.country,
        ecm.total_medals,
        row_number() over (partition by ecm.event order by ecm.total_medals desc) as rank_in_event
    from
        event_country_medals ecm
)

-- step 3: get top country per event
select
    event,
    country,
    total_medals
from
    event_country_ranked
where
    rank_in_event = 1
order by
    event;