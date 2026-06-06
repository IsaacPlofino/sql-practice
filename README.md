SQL Practice — Isaac Plofino

Self-directed SQL and ETL study sprint targeting Data Engineer roles.

---

Stack

SQL (MySQL 8.4) · Python (coming Week B) · ETL Pipeline Development (coming Week B–C) · IBM Cloud Essentials (coming Week C)

---

Sprint Structure

21 study days across 4 weeks — 6 days per week, Sunday rest.

| Phase | Dates | Focus |
|-------|-------|-------|
| Week A (3 days) | June 4–6 | SQL Foundation Reinforcement — Framework + Missed Topics |
| Week B (6 days) | June 8–13 | SQL Lock-In + ETL Concepts + Python Basics |
| Week C (6 days) | June 15–20 | ETL Pipeline Project + IBM Cert + Interview Prep |
| Week D (6 days) | June 22–27 | Portfolio Polish + Application Submission |


---

Repository Contents

Phase 0 — SQL Foundations (Original Week 1)

> These files were completed during the initial SQL week. All queries are written against `sprint_db` in MySQL 8.4.

| File | Topics Covered | Score |
|------|---------------|-------|
| `day01_basics.sql` | SELECT, WHERE, ORDER BY, LIMIT, DISTINCT, basic JOINs, NULL handling | 9/10 |
| `day02_joins.sql` | INNER JOIN, LEFT JOIN, RIGHT JOIN, FULL OUTER JOIN (UNION simulation), NULL behavior, multi-table JOINs | 13/15 |
| `day03_aggregations.sql` | COUNT, SUM, AVG, MIN, MAX, GROUP BY, HAVING, WHERE vs HAVING, multi-table aggregations | 11/15 |
| `day04_subqueries.sql` | Subquery in WHERE, NOT IN with NULL guard, scalar subquery in SELECT, derived table in FROM, correlated subquery, second-highest value, top spender per group | 15/15 |
| `day05_window_functions.sql` | ROW_NUMBER, RANK, DENSE_RANK, LAG, LEAD, PARTITION BY, running totals, CTEs (WITH clause), top-N per group with tie handling | 11/15 |

---

Phase A — SQL Reinforcement + Missed Topics (Week A)

> Rebuilds SQL fundamentals using the 5-Question Problem Decomposition Framework. Addresses core weakness: reading comprehension and problem breakdown under complexity.

| File | Topics Covered | Score |
|------|---------------|-------|
| `day_A1_framework_practice.sql` | 5-Question Framework applied to JOINs and Aggregations — JOIN type selection, COUNT vs SUM, WHERE vs HAVING, LIMIT vs HAVING | 10/10 |
| `day_A2_subqueries_casewhen.sql` | Subqueries re-practice with framework + CASE WHEN + conditional aggregation | — |
| `day_A3_windowfn_datestring.sql` | Window Functions re-practice with framework + Date functions (DATEDIFF, DATE_FORMAT, YEAR, MONTH) + String functions (CONCAT, TRIM, SUBSTRING) | — |

---

Phase B — SQL Lock-In + ETL Concepts (Week B)

| File | Topics Covered | Score |
|------|---------------|-------|
| `mock_test_01.sql` | SQL Mock Test 1 — timed, no notes, all topics | — |
| `leetcode_medium.sql` | LeetCode SQL Medium — 10 problems (Rank Scores, Second Highest Salary, Department Top 3, Consecutive Numbers) | — |
| `etl_basics.py` | Python basics for ETL scripting — read CSV, clean data, write CSV | — |
| `mock_test_02.sql` | SQL Mock Test 2 — weak area drill from Mock Test 1 | — |

---

Phase C — ETL Pipeline Project (Week C)

> End-to-end ETL pipeline demonstrating Extract, Transform, Load logic — the core skill set of the IBM DataStage track.

| File | Description |
|------|-------------|
| `pipeline.py` | Full ETL pipeline: raw data → cleaning → validation → clean output |
| `pipeline_summary.txt` | Auto-generated run log: input rows, output rows, nulls removed, run timestamp |
| `requirements.txt` | Python dependencies |
| `README.md` (ETL repo) | Pipeline architecture, data quality issues found and fixed, how to run |

---

Schema — sprint_db

All SQL files query against `sprint_db` — a custom MySQL 8.4 schema built for this sprint.

```
customers   (customer_id, customer_name, country)
orders      (order_id, customer_id, product_id, quantity, order_date, status)
products    (product_id, product_name, category, price)
```

Schema stats:
- 10 customers across Philippines, Singapore, and Malaysia
- 10 products across Electronics, Furniture, and Supplies
- 24 orders across January–May 2024 with mixed statuses

Intentional edge cases built into the schema:
- Customer with zero orders → LEFT JOIN behavior
- Product never ordered → RIGHT JOIN behavior
- Order with NULL customer_id → NULL JOIN drop behavior
- Duplicate prices across products → RANK vs DENSE_RANK tie behavior
- Multiple customers per country → PARTITION BY demos

---

 The 5-Question Framework

Every query in this repo is preceded by a framework comment block:

```sql
-- 1. SHOW: what columns to return
-- 2. LIVE: which tables + JOIN type (INNER or LEFT)
-- 3. WANT: WHERE conditions
-- 4. COLLAPSE: GROUP BY columns
-- 5. POST-FILTER: HAVING conditions
```

---

Profile

Degree: BSIT-Business Analytics, Cum Laude — Bulacan State University SJDM
Awards: Gold Gear Award (Dean's List all 4 years)
GitHub: github.com/IsaacPlofino/sql-practice
Target: Data Engineer roles — DataStage/Cloud track
