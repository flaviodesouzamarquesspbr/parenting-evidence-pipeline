WITH base AS (
    SELECT *
    FROM {{ ref('stg_research_data') }}
    WHERE year != -1
),

agg AS (
    SELECT
        topic,
        COUNT(*) AS total_articles,
        AVG(citations) AS avg_citations,
        MAX(year) - MIN(year) AS year_span
    FROM base
    GROUP BY topic
),

norm AS (
    SELECT
        topic,
        total_articles,
        avg_citations,
        year_span,

        -- normalização simples min-max por coluna
        SAFE_DIVIDE(
            total_articles - MIN(total_articles) OVER(),
            NULLIF(MAX(total_articles) OVER() - MIN(total_articles) OVER(), 0)
        ) AS vol_norm,

        SAFE_DIVIDE(
            avg_citations - MIN(avg_citations) OVER(),
            NULLIF(MAX(avg_citations) OVER() - MIN(avg_citations) OVER(), 0)
        ) AS cit_norm,

        SAFE_DIVIDE(
            year_span - MIN(year_span) OVER(),
            NULLIF(MAX(year_span) OVER() - MIN(year_span) OVER(), 0)
        ) AS span_norm
    FROM agg
),

score AS (
    SELECT
        topic,
        total_articles,
        avg_citations,
        year_span,

        -- score 0–100
        ROUND((
            (vol_norm * 0.4) +
            (cit_norm * 0.3) +
            (span_norm * 0.3)
        ) * 100, 2) AS evidence_score
    FROM norm
)

SELECT
    *,
    CASE
        WHEN evidence_score >= 70 THEN 'high'
        WHEN evidence_score >= 40 THEN 'medium'
        ELSE 'low'
    END AS evidence_level
FROM score
ORDER BY evidence_score DESC