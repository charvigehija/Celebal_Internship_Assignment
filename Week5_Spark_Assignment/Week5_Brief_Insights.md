# Week 5 Spark Assignment — Brief Insights
**Dataset:** Superstore (Kaggle) | 9,994 rows | 21 columns | PySpark on Databricks Free Edition  
**Internship:** Celebal Technologies | Week 5

---

## Q3: Remove Duplicate Rows Based on Specific Columns

| Metric | Value |
|---|---|
| Original Row Count | 9,994 rows |
| After Deduplication | 5,009 rows |
| Duplicates Removed | 4,985 rows |
| Columns Used | Order ID + Order Date |

**Insight:**
The dataset had 9,994 line items but only 5,009 unique orders — meaning nearly half the rows were multiple products within the same order. Deduplication using Order ID and Order Date correctly identified and removed all 4,985 duplicate line items, leaving one record per unique order.

---

## Q4: Filter Region = West, GroupBy Category, Avg Sale Amount

| Metric | Value |
|---|---|
| Technology (West) | Avg Sale: $422.64 |
| Furniture (West) | Avg Sale: $360.60 |
| Office Supplies (West) | Avg Sale: $117.49 |
| Invalid Sales Values Found | 300 rows fixed using try_cast |

**Insight:**
Technology products have the highest average sale value in the West region at $422.64 — nearly 4x higher than Office Supplies. This suggests Technology drives premium purchases in the West. Notably, 300 rows had corrupted Sales values (e.g., 'Sand"') which were handled using try_cast() to prevent pipeline failures.

---

## Q5: Difference Between .na.drop() and .na.fill()

| Metric | Value |
|---|---|
| Original Row Count | 9,994 rows |
| After .na.drop() | 9,694 rows (300 removed) |
| After .na.fill(Sales=0) | 9,994 rows (all kept) |
| Null Sales Values | 300 rows filled with 0 |

**Insight:**
.na.drop() permanently removes rows with nulls — useful when incomplete records would distort analysis. .na.fill() preserves all rows by replacing nulls with a default value — better when every record matters. For sales data, filling with 0 is safer than dropping, as dropping 300 rows (3% of data) could skew regional or category summaries.

---

## Q6: Total Count per City — Only Cities with Count > 100

| Metric | Value |
|---|---|
| Total Unique Cities | 531 cities in dataset |
| Cities with Count > 100 | 13 cities |
| #1 City | New York City — 915 records |
| #2 City | Los Angeles — 747 records |
| Lowest Qualifying City | Detroit — 115 records |

**Insight:**
Only 13 out of 531 cities (just 2.4%) account for a disproportionately large share of orders — a classic Pareto distribution in retail data. New York City alone contributes 915 records (9% of total), confirming it as the store's most active market. This insight is critical for targeted marketing and inventory decisions.

---

## Q7: Immutability of Spark DataFrames

| Metric | Value |
|---|---|
| Original DataFrame | 21 columns, 9,994 rows — unchanged |
| After 4 Transformations | 20 columns, 1,611 rows (new DF) |
| Operations Chained | drop → rename → dropDuplicates → filter |
| Key Proof | Original df.count() still returns 9,994 |

**Insight:**
Spark's immutability was clearly demonstrated — applying 4 transformations (drop, rename, dedup, filter) to the original DataFrame produced a completely new DataFrame without modifying the source. This design enables fault tolerance: if any step fails, Spark can recompute from the original lineage without data loss.

---

## Q8: Filter Age 18-30 AND Subscription = Premium

| Metric | Value |
|---|---|
| Sample Data Created | 10 rows with age and subscription |
| Rows Matching Filter | 5 rows |
| Rows Excluded | 5 rows (age out of range or Basic plan) |
| Filter Logic Used | between(18,30) AND col == 'Premium' |

**Insight:**
The compound filter using & (AND) operator correctly applied both conditions simultaneously. Diana (age 17) was excluded for being underage, Grace (age 45) for being over range, and Bob, Eve, Henry for having Basic subscriptions. This demonstrates that Spark evaluates both conditions together — not sequentially — making it efficient for multi-condition filtering.

---

## Q9: Why Handle Nulls Before Mathematical Aggregations

| Metric | Value |
|---|---|
| Avg Sales (nulls ignored) | $234.42 — using 9,694 rows |
| Avg Sales (nulls as 0) | $227.38 — using 9,994 rows |
| Difference | $7.04 — caused by 300 null rows |
| Risk | Spark silently ignores nulls in avg() |

**Insight:**
A $7.04 difference in average sale value was caused purely by 300 null rows — Spark's avg() silently skips nulls, making the result appear higher than reality. In a real business context, this could lead to inflated revenue forecasts. Always handle nulls explicitly before aggregation to ensure calculations reflect the true state of data.

---

## Q10: Cast and Rename Column — raw_timestamp to event_time

| Metric | Value |
|---|---|
| Original Column | Ship Date — DateType |
| New Column | event_time — TimestampType |
| Sample Value | 2016-11-11 → 2016-11-11 00:00:00 |
| Method Used | withColumn + cast(TimestampType()) + drop |

**Insight:**
Casting from DateType to TimestampType adds time precision (HH:MM:SS) to date-only values, defaulting to 00:00:00 when no time exists in source data. This is essential for time-series analysis and event tracking systems where millisecond precision matters. The original column was cleanly removed after renaming to avoid column duplication.

---

## Q11: Shuffle Process in groupBy — Wide Transformation

| Metric | Value |
|---|---|
| East Region | 2,848 records, 674 unique customers |
| West Region | 3,203 records, 686 unique customers |
| Central Region | 2,323 records, 629 unique customers |
| South Region | 1,620 records, 512 unique customers |
| Shuffle Proof | PhotonShuffleExchangeSink found in plan |

**Insight:**
The execution plan confirmed a real shuffle occurred — data was physically moved across partitions using hashpartitioning(Region, 16). West has the most orders (3,203) while South has the fewest (1,620). The shuffle is unavoidable for groupBy operations since all records with the same Region key must be co-located on the same executor before aggregation can happen.

---

## Q12: Remove Rows with Null Email OR Empty Username

| Metric | Value |
|---|---|
| Sample Rows Created | 7 rows |
| Rows Removed | 4 rows |
| Clean Rows Remaining | 3 rows |
| Conditions Applied | email.isNotNull() AND trim(username) != '' |

**Insight:**
Using isNotNull() and trim() together is critical — isNotNull() catches database nulls while trim() catches whitespace-only strings that look empty but aren't truly null. Without trim(), a username containing only spaces would pass the filter incorrectly. This combination ensures robust data quality checks for string columns in real-world dirty datasets.

---

## Q13: Using .agg() for Multiple Statistics at Once

| Metric | Value |
|---|---|
| Min Sales | $0.44 |
| Max Sales | $22,638.48 |
| Mean Sales | $234.42 |
| Technology Total Sales | $835,900 (highest) |
| Office Supplies Total | $703,503 (lowest) |

**Insight:**
A single .agg() call computed 5 statistics simultaneously in one data pass — far more efficient than running 5 separate queries. The massive range between min ($0.44) and max ($22,638.48) indicates highly varied product pricing. Technology dominates total sales despite having fewer orders than Office Supplies — confirming it drives the highest value per transaction.

---

## Q14: Risk of inferSchema=True with Inconsistent Date Formats

| Metric | Value |
|---|---|
| Sample Rows | 5 rows with 4 different date formats |
| Wrong Approach NULLs | 3 out of 5 rows lost silently |
| Correct Approach NULLs | 0 rows lost — all parsed |
| Fix Used | try_to_date() with coalesce() for fallback |

**Insight:**
Using a single date format with inferSchema caused 60% of rows to silently become NULL — a catastrophic data loss with no error or warning. The correct approach using try_to_date() with coalesce() across multiple formats recovered all 5 rows successfully. In production pipelines, always define schemas explicitly and use try_ functions to handle malformed data gracefully.

---

## Q15: Final End-to-End Processing Pipeline

| Metric | Value |
|---|---|
| Step 1 — Deduplication | 9,994 → 5,009 rows (4,985 removed) |
| Step 2 — Null Handling | 300 Sales + 149 Quantity values fixed |
| Furniture Total Revenue | $1,957,951 (highest) |
| Technology Total Revenue | $1,823,107 (second) |
| Office Supplies Revenue | $1,701,982 (third) |
| Pipeline Status | Completed successfully — all results saved |

**Insight:**
The complete pipeline revealed that Furniture generates the highest total revenue ($1.96M) despite Technology having the highest average sale price — meaning Furniture sells in higher quantities. Office Supplies has the most orders (3,043) but lowest average sale ($110.98), suggesting it is high-volume, low-margin. A total of 449 corrupted values (300 Sales + 149 Quantity) were silently fixed using try_cast, demonstrating the importance of defensive data cleaning in production pipelines.

---

*— End of Brief Insights Document —*
