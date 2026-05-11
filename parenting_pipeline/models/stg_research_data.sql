SELECT
    title,
    year,
    citations,
    country,
    topic
FROM `parenting-data-project.parenting_data.research_data`
WHERE year != -1
