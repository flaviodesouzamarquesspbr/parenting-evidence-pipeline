SELECT
    topic,
    year,
    COUNT(*) AS total_articles,
    AVG(citations) AS avg_citations
FROM {{ ref('stg_research_data') }}
WHERE year != -1
GROUP BY topic, year
ORDER BY year
