# Tax Reporting Data Quality Brief
**Prepared for: Operations Management**

---

## 1. Executive Summary

Our tax reporting portfolio shows **meaningful data quality concerns that require prompt action before filing deadlines.** Of 200 total reports, **30% carry either discrepancies or missing cost basis data**, and **58.5% remain unfiled with the IRS**. With $76,310.34 in realized gains/losses split across 93 short-term and 107 long-term positions, accurate cost basis integrity is critical to ensure correct tax treatment and avoid regulatory exposure.

---

## 2. Top 3 Issues Requiring Immediate Attention

| Priority | Issue | Scope | Risk Level |
|----------|-------|-------|------------|
| 🔴 **#1** | Reports Not Filed with IRS | 117 of 200 | **Critical** |
| 🟠 **#2** | Reports with Discrepancies | 32 of 200 (16%) | **High** |
| 🟡 **#3** | Missing Cost Basis Data | 28 of 200 (14%) | **High** |

---

## 3. Recommended Actions

### 🔴 Priority 1 — 117 Unfiled Reports
- **Immediately triage** the 117 reports into two buckets: *ready to file* vs. *blocked by data issues*
- Identify which overlap with the 32 discrepancy and 28 missing cost basis reports — these are likely blockers
- Set an internal filing deadline **5 business days ahead** of IRS deadlines to create buffer
- Assign owner accountability per report batch

### 🟠 Priority 2 — 32 Discrepancy Reports
- Pull a discrepancy detail report; categorize by type *(e.g., price mismatches, lot misalignments, wash sale adjustments)*
- Escalate any discrepancies affecting **gain/loss classification** (short vs. long term) immediately — these directly impact tax liability
- Resolve or document overrides with supporting rationale before filing

### 🟡 Priority 3 — 28 Missing Cost Basis Reports
- Initiate **cost basis recovery workflow**: check custodian feeds, transfer statements, and legacy records
- For positions where cost basis is unrecoverable, apply default methodology per IRS rules *(e.g., FIFO)* and flag for client notification
- Prioritize any missing basis tied to **short-term positions** — these carry higher tax rates and greater client impact

---

## 4. Compliance Risks to Flag

> ⚠️ **Late Filing Penalties** — 117 unfiled reports create direct IRS penalty exposure. Penalties begin at **$60–$310 per return** depending on latency.

> ⚠️ **Incorrect Gain/Loss Reporting** — Unresolved discrepancies risk misclassifying short-term vs. long-term gains, potentially **understating client tax liability.**

> ⚠️ **Missing Cost Basis = IRS Default** — If cost basis is not established before filing, the IRS may treat proceeds as **100% gain**. This is a significant client harm risk.

> ⚠️ **Overlap Risk** — If any reports carry *both* a discrepancy *and* missing cost basis, those are your **highest-risk filings** and should be isolated immediately.

---

**Recommended Next Step:** Schedule a 30-minute triage call with the tax ops and data teams this week to assign ownership and set resolution deadlines by report category.