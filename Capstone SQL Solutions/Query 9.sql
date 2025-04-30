-- Step 1: find first and last year each athlete participated
WITH athlete_career_span AS (
    SELECT
        oab.athlete_id,
        oab.name,
        MIN(og.year) AS first_year,
        MAX(og.year) AS last_year,
        MAX(og.year) - MIN(og.year) AS career_span_years
    FROM
        olympic_athlete_event_results oae
    JOIN
        olympic_athlete_bio oab
        ON oae.athlete_id = oab.athlete_id
    JOIN
        olympics_games og
        ON oae.edition_id = og.edition_id
    GROUP BY
        oab.athlete_id, oab.name
)

-- Step 2: select athletes with the longest careers
SELECT
    athlete_id,
    name,
    first_year,
    last_year,
    career_span_years
FROM
    athlete_career_span
ORDER BY
    career_span_years DESC,
    first_year ASC
LIMIT 20;