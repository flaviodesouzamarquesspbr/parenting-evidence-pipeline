# 📊 Evidence-Based Parenting Data Pipeline

## 🚀 Overview
This project builds a complete data pipeline to analyze global research trends on:

- Screen time in children
- Child nutrition

The goal is to transform raw academic data into actionable insights using modern data tools.

---

## 🧠 Architecture

API → Python → BigQuery → dbt → Analytics Models

---

## ⚙️ Tech Stack

- Python (API ingestion)
- BigQuery (Data warehouse)
- dbt (Data transformation)
- GitHub (Version control)

---

## 📊 Data Models

### 🟫 Raw
- `research_data`: raw dataset from OpenAlex API

### 🟪 Staging
- `stg_research_data`: cleaned and standardized data

### 🟨 Mart (Analytics)

- `articles_by_topic`: research volume and impact
- `articles_by_year`: trend analysis
- `evidence_score`: custom scoring model

---

## 🔥 Key Insight

A custom Evidence Score was designed combining:

- Research volume
- Citation impact
- Time coverage

---

## 📈 Example Insight

Screen time research shows higher volume and citation impact compared to nutrition topics.

---

## 📌 Future Improvements

- Add Airflow for orchestration
- Build dashboard (Power BI / Tableau)
- Improve scoring model
