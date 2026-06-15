# SQL Practice — Isaac Plofino

Self-directed SQL and ETL study sprint targeting IBM Consulting Associates — DataStage/Cloud track.

**Stack:** SQL (MySQL 8.4) · Python · ETL Pipeline Development · IBM Cloud Essentials  
**GitHub:** [github.com/IsaacPlofino/sql-practice](https://github.com/IsaacPlofino/sql-practice)  
**Application target:** IBM Consulting Associates — DataStage/Cloud track (June 23–27, 2026)

---

## Sprint Structure

21 study days across 4 weeks — 6 days per week, Sunday rest.

| Phase | Dates | Focus |
|-------|-------|-------|
| Phase 0 — SQL Foundations | May 2026 | Core SQL: SELECT through Window Functions |
| Week A (3 days) | June 4–6 | SQL Reinforcement — Framework + Missed Topics |
| Week B (6 days) | June 8–15 | SQL Lock-In + ETL Concepts + Python Basics |
| Week C (6 days) | June 15–20 | ETL Pipeline Build + IBM Cert + Interview Prep |
| Week D (6 days) | June 22–27 | Portfolio Polish + Application Submission |

---

## The 5-Question Problem Decomposition Framework

Every query in this repo is preceded by a framework comment block. Introduced after self-identifying reading comprehension and problem breakdown as core weaknesses.

```sql
-- 1. SHOW: what columns to return            → SELECT
-- 2. LIVE: which tables + JOIN type          → FROM + JOINs
-- 3. WANT: row-level conditions              → WHERE
-- 4. COLLAPSE: grouping needed?              → GROUP BY
-- 5. POST-FILTER: filter after grouping?     → HAVING

-- For WINDOW FUNCTIONS, add:
-- 6. What calculation per row?               → RANK, SUM, LAG...
-- 7. What group resets it?                   → PARTITION BY
-- 8. What order does it need?                → ORDER BY inside OVER()

-- For SUBQUERIES, ask:
-- Is it a FILTER?   → WHERE or HAVING
-- Is it a TABLE?    → FROM (derived table)
-- Is it a VALUE?    → SELECT (scalar subquery)
```

---

## Repository Contents

### Phase 0 — SQL Foundations (Original Week 1)

All queries written against `sprint_db` in MySQL 8.4.

| File | Topics Covered |
|------|---------------|
| `day01_basics.sql` | SELECT, WHERE, ORDER BY, LIMIT, DISTINCT, basic JOINs, NULL handling |
| `day02_joins.sql` | INNER JOIN, LEFT JOIN, RIGHT JOIN, FULL OUTER JOIN (UNION simulation), NULL behavior, multi-table JOINs |
| `day03_aggregations.sql` | COUNT, SUM, AVG, MIN, MAX, GROUP BY, HAVING, WHERE vs HAVING, multi-table aggregations |
| `day04_subqueries.sql` | Subquery in WHERE, NOT IN with NULL guard, scalar subquery in SELECT, derived table in FROM, correlated subquery |
| `day05_window_functions.sql` | ROW_NUMBER, RANK, DENSE_RANK, LAG, LEAD, PARTITION BY, running totals, CTEs |

---

### Phase A — SQL Reinforcement (Week A)

Rebuilds SQL fundamentals using the 5-Question Framework. Targets core weakness: reading comprehension and problem breakdown under complexity.

| File | Topics Covered |
|------|---------------|
| `day_A1_framework_practice.sql` | Framework applied to JOINs and Aggregations — JOIN type selection, COUNT vs SUM, WHERE vs HAVING |
| `day_A2_subqueries_casewhen.sql` | Subqueries re-practice + CASE WHEN + conditional aggregation |
| `day_A3_windowfn_datestring.sql` | Window Functions re-practice + Date functions (DATE_FORMAT, YEAR, MONTH) + String functions |

**Recurring weakness identified:** LEFT JOIN + WHERE trap — status filter on LEFT JOINed tables must go in ON, not WHERE.

---

### Phase B — SQL Lock-In + ETL Concepts (Week B)

| File | Topics Covered |
|------|---------------|
| `day_B1_mock_test_01.sql` | SQL Mock Test 1 — timed, no AI — JOINs, aggregations, subqueries, window functions, CASE WHEN, date functions |
| `day_B2_leetcode_medium.sql` | LeetCode SQL Medium — 7 problems scoped for DataStage track — derived tables, DENSE_RANK, conditional aggregation, rolling windows |
| `day_B6_mock_test_02.sql` | SQL Mock Test 2 — weak area drill — LEFT JOIN trap, PARTITION BY, DATE_FORMAT, derived table + LIMIT 1 pattern |

> ETL theory notes (B3), Python basics (B4), and the modular ETL pipeline (B5) live in the companion repo:  
> [github.com/IsaacPlofino/etl-pipeline-project](https://github.com/IsaacPlofino/etl-pipeline-project)

---

## Schema — sprint_db

All SQL files query against `sprint_db` — a custom MySQL 8.4 schema built for this sprint.

```sql
customers  (customer_id, customer_name, country)
orders     (order_id, customer_id, product_id, quantity, order_date, status)
products   (product_id, product_name, category, price)
```

**Schema stats:**
- 10 customers across Philippines, Singapore, and Malaysia
- 10 products across Electronics, Furniture, and Supplies
- 24 orders across January–May 2024 with mixed statuses

**Intentional edge cases built in:**
- Customer with zero orders → LEFT JOIN behavior
- Product never ordered → RIGHT JOIN behavior
- Order with NULL customer_id → NULL JOIN drop behavior
- Duplicate prices across products → RANK vs DENSE_RANK tie behavior
- Multiple customers per country → PARTITION BY demos

---

## Key Weaknesses Tracked and Fixed

| Weakness | Identified | Resolution |
|---------|-----------|------------|
| LEFT JOIN + WHERE trap — status filter drops NULL rows | Week A, repeated in B1 | Moved filter to ON clause — locked in by B6 Q2 |
| Missing ORDER BY on explicitly sorted queries | B1 | Added sort column to framework Step 1 as standard |
| Missing DESC inside OVER() for ranking functions | A3, B6 | Added explicit direction check to window function checklist |
| Skipping framework on complex problems | B6 | Identified pattern — framework non-negotiable on hard questions |
| DATE_FORMAT pattern recall under pressure | B6 | Re-drilled after test — connected to LeetCode P6 pattern |

---

## Profile

**Degree:** BSIT-Business Analytics, Cum Laude — Bulacan State University SJDM  
**Awards:** Gold Gear Award (Dean's List all 4 years)  
**Target:** IBM Consulting Associates — DataStage/Cloud track  
**Companion repo:** [etl-pipeline-project](https://github.com/IsaacPlofino/etl-pipeline-project)
