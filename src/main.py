import requests
import pandas as pd
import time

# =========================
# CONFIG
# =========================
url = "https://api.openalex.org/works"

topics = [
    ("screen time children", "screen_time"),
    ("child nutrition", "nutrition")
]

MAX_PAGES = 5  # 5 páginas x 50 = 250 por tema

# =========================
# EXTRACTION (API + PAGINAÇÃO)
# =========================
all_rows = []

for search_term, topic_name in topics:
    print(f"\n🔍 Collecting: {search_term}")

    for page in range(1, MAX_PAGES + 1):

        params = {
            "search": search_term,
            "per_page": 50,
            "page": page
        }

        response = requests.get(url, params=params)
        data = response.json()

        for work in data["results"]:
            row = {
                "title": work.get("title"),
                "year": work.get("publication_year"),
                "citations": work.get("cited_by_count"),
                "country": (
                    work.get("authorships")[0].get("countries")[0]
                    if work.get("authorships") and work["authorships"][0].get("countries")
                    else None
                ),
                "topic": topic_name
            }

            all_rows.append(row)

        print(f"Page {page} collected")

        time.sleep(1)

# =========================
# DATAFRAME
# =========================
df = pd.DataFrame(all_rows)

print("\n=== RAW DATA ===")
print(df.head())
print("Total rows (raw):", len(df))


# =========================
# CLEANING / NORMALIZATION
# =========================

# ---- Year (manter dado, preencher com -1)
df["year"] = df["year"].fillna(-1)

# ---- Citations (preencher com 0)
df["citations"] = df["citations"].fillna(0)

# ---- Country (preencher com unknown)
df["country"] = df["country"].fillna("unknown")

# ---- Normalizar países
country_map = {
    "US": "USA",
    "GB": "UK",
    "UK": "UK",
    "CA": "Canada",
    "AU": "Australia"
}

df["country"] = df["country"].replace(country_map)

# ---- Tipos
df["year"] = df["year"].astype(int)
df["citations"] = df["citations"].astype(int)

# ---- Remover duplicados
df = df.drop_duplicates()

print("\nTotal rows (cleaned):", len(df))


# =========================
# METRICS (ANÁLISE INICIAL)
# =========================

print("\n=== ARTICLES BY TOPIC ===")
print(df["topic"].value_counts())

print("\n=== AVG CITATIONS BY TOPIC ===")
print(df.groupby("topic")["citations"].mean())

print("\n=== ARTICLES PER YEAR ===")
print(df.groupby(["topic", "year"]).size())


# =========================
# SAVE DATA
# =========================

df.to_csv("data_cleaned.csv", index=False)

print("\n✅ Data saved as data_cleaned.csv")