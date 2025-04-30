-- step 1: calculate medal conversion rate percentage
SELECT 
    country_noc, country,
    COUNT(DISTINCT CASE WHEN medal IS NOT NULL THEN a.athlete_id END) AS athletes_with_medals,
    COUNT(DISTINCT a.athlete_id) AS total_athletes,
    ROUND(
        (COUNT(DISTINCT CASE WHEN medal IS NOT NULL THEN a.athlete_id END) / COUNT(DISTINCT a.athlete_id)) * 100,
        2
    ) AS medal_conversion_rate_percentage
FROM 
    olympic_athlete_event_results a
    
-- step 2: join to group by country and country noc
JOIN  
    olympics_country c ON country_noc = noc
GROUP BY 
 country, country_noc
ORDER BY 
    medal_conversion_rate_percentage DESC;