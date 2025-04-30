-- step 1: medals won by each country each year
with country_year_medals as (
    select
        og.year,
        oab.country,
        count(*) as total_medals
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
        og.year, oab.country
),

-- step 2: find host country for each olympic year
host_countries as (
    select
        og.year,
        oc.country as host_country
    from
        olympics_games og
    join
        olympics_country oc
    on
        og.country_noc = oc.noc
)

-- step 3: medals by host country in host year
select
    hc.year,
    hc.host_country,
    cym.total_medals as medals_when_hosting
from
    host_countries hc
left join
    country_year_medals cym
on
    hc.year = cym.year
    and hc.host_country = cym.country
order by
    hc.year;