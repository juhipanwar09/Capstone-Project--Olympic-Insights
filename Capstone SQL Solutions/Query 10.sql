-- step 1: total medals by country and season
with country_season_medals as (
    select
        oab.country,
        og.edition,
        count(medal) as total_medals
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
        oab.country, og.edition ),

-- step 2: average medals by country for each season
average_medals as (
    select
        edition,
        avg(total) as avg_medals_per_country
    from
        olympic_games_medal_tally
    group by
        edition
)

-- step 3: final output
select
    edition,
    round(avg_medals_per_country, 2) as avg_medals_per_country
from
    average_medals
order by
    edition;