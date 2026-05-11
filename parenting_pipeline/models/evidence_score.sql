WITH base AS (
    SELECT *
    FROM {{ ref('stg_research_data') }}
),

aggregated AS (
    SELECT
        topic,
        COUNT(*) AS total_articles,
        AVG(citations) AS avg_citations,
        MAX(year) - MIN(year) AS year_span
    FROM base
    WHERE year != -1
    GROUP BY topic
),

score AS (
    SELECT
        topic,
        total_articles,
        avg_citations,
        year_span,

        -- Score simples (ajustável)
        (total_articles * 0.4) +
        (avg_citations * 0.3) +
        (year_span * 0.3) AS evidence_score

    FROM aggregated
)

SELECT *
FROM score
ORDER BY evidence_score DESC
