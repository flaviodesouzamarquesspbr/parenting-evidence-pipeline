SELECT
    topic,
    COUNT(*) AS total_articles,
    AVG(citations) AS avg_citations,
    MAX(citations) AS max_citations,
    MIN(citations) AS min_citations
FROM {{ ref('stg_research_data') }}
GROUP BY topic
