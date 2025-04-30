-- step 1: calculate total medals per country per year
with country_year_medals as (
    select
        ogmt.year,
        ogmt.country,
        sum(ogmt.gold + ogmt.silver + ogmt.bronze) as total_medals
    from
        olympic_games_medal_tally ogmt
    group by
        ogmt.year, ogmt.country
),

-- step 2: rank countries by medals each year
ranked_countries as (
    select
        cym.year,
        cym.country,
        cym.total_medals,
        row_number() over (partition by cym.year order by cym.total_medals desc) as rank_in_year
    from
        country_year_medals cym
),

-- step 3: get top 10 countries each year
top_10_countries as (
    select
        rc.year,
        rc.country,
        rc.total_medals
    from
        ranked_countries rc
    where
        rc.rank_in_year <= 10
),

-- step 4: self join to find previous year's medals
medal_growth as (
    select
        curr.year,
        curr.country,
        curr.total_medals as current_year_medals,
        prev.total_medals as previous_year_medals,
        case
            when prev.total_medals is not null and prev.total_medals != 0 then
                round(((curr.total_medals - prev.total_medals) / prev.total_medals) * 100, 2)
            else
                null
        end as medal_growth_percentage
    from
        top_10_countries curr
    left join
        top_10_countries prev
    on
        curr.country = prev.country
        and curr.year = prev.year + 4  -- olympics are usually every 4 years
)
-- step 5: final output
select
    year,
    country,
    current_year_medals,
    previous_year_medals,
    medal_growth_percentage
from
    medal_growth
order by
    year, medal_growth_percentage desc;