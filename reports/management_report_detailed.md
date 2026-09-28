TAX & COST BASIS DATA QUALITY REPORT
Generated: 2026-09-27 22:12

==================================================
EXECUTIVE SUMMARY
==================================================
# Monthly Data Quality Report
**Tax & Cost Basis Operations | Senior Analyst Review**

---

## 1. Executive Summary

This month's data quality posture is materially concerning, with an **8.2% error rate across 500 transactions** — a threshold that typically triggers regulatory scrutiny and warrants immediate remediation before month-end close. The most critical exposure is **117 transactions unreported to the IRS**, representing potential penalties that could far exceed the operational cost of resolution, particularly given the **$76,310.34 net gain/loss position** that regulators will expect to reconcile cleanly. Concentrated exceptions in **TSLA (7 discrepancies), META (5), and MSFT (5)** suggest systemic processing failures in specific security workflows rather than random data noise, pointing to a root-cause issue that must be diagnosed at the pipeline level.

---

## 2. Top 3 Issues Requiring Immediate Attention

### 🔴 Priority 1: 117 Unreported Transactions to the IRS
- **117 out of 500 transactions (23.4%)** have not been reported to the IRS.
- This is a **hard compliance deadline risk**, not a data quality preference. Late or missing 1099-B filings carry penalties of **$310 per form** (2024 IRS schedule) for intentional disregard, with no cap in egregious cases.
- **Immediate action:** Freeze any affected account closures or transfers, assign a dedicated analyst to triage which transactions fall within the current reporting window, and escalate to Legal/Compliance within **24 hours**.

---

### 🔴 Priority 2: 28 Transactions with Missing Cost Basis
- Missing cost basis on **28 transactions** means gain/loss calculations are either estimated, zeroed out, or defaulted — all of which create **incorrect tax lot reporting**.
- The MSFT position alone carries a **-$169,044.15 total loss** with 5 discrepancies, and TSLA shows **+$161,783.53 in gains** with 7 discrepancies. If cost basis is absent or wrong on these high-value positions, the tax impact misstatement could be **six figures**.
- **Immediate action:** Cross-reference custodian records (DTC, DTCC) and broker confirms for all 28 transactions. Prioritize by absolute gain/loss magnitude — start with MSFT and TSLA. Set a **48-hour resolution SLA** with the data sourcing team.

---

### 🟠 Priority 3: 32 Discrepancies Concentrated in Top Exception Tickers
- **32 discrepancies across the portfolio**, but **17 of them (53%)** are concentrated in just 3 tickers: TSLA (7), MSFT (5), and META (5).
- This concentration pattern strongly suggests a **ticker-specific data feed issue** — potentially a corporate action (split, merger, dividend reinvestment) being processed incorrectly — rather than isolated human error.
- **Immediate action:** Pull the full transaction history for TSLA, MSFT, and META. Check for unprocessed corporate actions in the lookback window. Engage the data vendor to validate feed integrity for these securities specifically.

---

## 3. Compliance Risks to Flag for Leadership

| Risk | Severity | Detail |
|---|---|---|
| **IRS Underreporting Exposure** | 🔴 Critical | 117 unreported transactions create direct regulatory liability. If any fall under covered security rules (post-2011 equities), broker is legally obligated to report. Non-compliance is not discretionary. |
| **Gain/Loss Misstatement Risk** | 🔴 Critical | GOOGL (+$88,162) and NVDA (+$101,711) show significant gains with 2–3 discrepancies each. Even small cost basis errors on these positions produce **material tax misstatements** for clients. |
| **MSFT Loss Integrity** | 🟠 High | -$169,044.15 is the largest single-ticker loss on the book. With 5 discrepancies and an avg loss of -$7,349/transaction, this position needs **independent reconciliation** before any tax-loss harvesting strategies are communicated to clients. |
| **Short

==================================================
DEEP DIVE: TSLA DISCREPANCY ANALYSIS
==================================================
# TSLA Discrepancy Root Cause Analysis
**7 Discrepancies — Highest Exception Count in Portfolio**

---

## Why TSLA Is Structurally Prone to Cost Basis Errors

Before running any checks, it helps to understand **why TSLA specifically** tends to generate more cost basis complexity than a typical equity. Three characteristics make it unusually error-prone in retail brokerage environments:

1. **Extreme price volatility** — Large intraday swings increase the likelihood that lot-matching logic (FIFO, specific ID, average cost) produces materially different results depending on which method was applied or defaulted, and small timing errors in trade capture have outsized dollar impact.
2. **High retail trading frequency** — TSLA is one of the most actively traded retail names, meaning accounts often hold **multiple open lots simultaneously** across different acquisition dates and prices, making lot identification and wash sale tracking significantly more complex.
3. **Corporate action history** — TSLA executed a **5-for-1 stock split (August 2020)** and a **3-for-1 stock split (August 2022)**. Any positions with acquisition dates predating either split require adjusted cost basis, and systems that did not correctly propagate those adjustments will carry silent errors forward indefinitely.

---

## Most Likely Root Causes, Ranked by Probability

---

### 🔴 1. Stock Split Adjustment Failures *(Highest Probability)*

**What happens:** When TSLA split 5-for-1 in 2020 and 3-for-1 in 2022, every pre-split tax lot needed two things applied simultaneously — **share quantity multiplied** and **per-share cost basis divided** by the split factor. If the corporate action processing system applied one without the other, or applied them to the wrong lot layer, the cost basis is wrong in a way that is not immediately visible until reconciliation.

**Why it's common in retail:** Many retail brokerage platforms process corporate actions through a batch overnight job. If any lot was in a pending, transferred, or margin state at the time of the split record date, it may have been **excluded from the batch** and never corrected.

**The silent risk:** A pre-2020 TSLA lot with an unadjusted cost basis would reflect the pre-split per-share price — roughly **15x too high** after both splits are applied. This would generate a phantom loss on paper that is entirely a data artifact.

---

### 🔴 2. Wash Sale Rule Misapplication or Non-Application

**What happens:** A wash sale occurs when a security is sold at a loss and the **same or substantially identical security is purchased within 30 days** before or after the sale. The disallowed loss must be added to the cost basis of the replacement lot. TSLA's volatility and high retail trading frequency make wash sale triggering events extremely common.

**Why it's common in retail:** Wash sale tracking is computationally intensive across accounts — especially when the same client holds TSLA in **multiple accounts** (taxable, IRA, spouse's account). Many retail systems only track wash sales within a single account, missing cross-account triggers entirely. When the disallowed loss adjustment is not carried into the replacement lot's cost basis, every downstream gain/loss calculation on that lot is wrong.

**What this looks like in your data:** A transaction showing a realized loss on TSLA that should have been fully or partially disallowed, with no offsetting cost basis adjustment on the replacement lot.

---
