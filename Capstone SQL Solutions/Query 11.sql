-- step 1: medal count by country per olympic year
with country_year_medals as (
    select
        og.year,
        oab.country,
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
        og.year, oab.country ),

-- step 2: top 20 countries per olympic year
country_year_rankings as (
    select
        year,
        country,
        total_medals,
        rank() over (partition by year order by total_medals desc) as medal_rank
    from
        country_year_medals
)

-- step 3: flagging emerging countries
select distinct
    recent.country
from
    country_year_rankings recent
where
    recent.year >= 2010 -- recent olympics: e.g., London 2012, Rio 2016, Tokyo 2020
    and recent.medal_rank <= 20 -- entered top 20
    and recent.country not in (
        select
            past.country
        from
            country_year_rankings past
        where
            past.year between 2000 and 2008 -- previous decade
            and past.medal_rank <= 20
    )
order by
    recent.country;