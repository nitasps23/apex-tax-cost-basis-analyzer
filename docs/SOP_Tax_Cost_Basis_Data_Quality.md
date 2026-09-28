# Standard Operating Procedure
## Tax & Cost Basis Data Quality Review
**Version:** 2.0  
**Last Updated:** 09/27/2026  
**Owner:** Tax & Cost Basis Operations Team

---

## Purpose
This SOP defines the standard process for conducting monthly data quality 
reviews of securities transaction data to ensure accurate cost basis 
calculation and IRS tax reporting compliance.

---

## Scope
Applies to all transaction data processed through the Tax & Cost Basis 
platform including BUY/SELL transactions, cost basis lot assignments, 
and 1099-B tax reporting records.

---

## Pipeline Overview

This process runs in two phases:

**Phase 1 — Data Setup (Run once per data refresh)**
```bash
bash setup_data.sh
```
Generates synthetic transaction data and loads all three tables 
into PostgreSQL (apex_tax_db).

**Phase 2 — Analysis Pipeline (Run monthly or on demand)**
```bash
bash run_pipeline.sh
```
Executes all SQL checks, advanced analysis, visualizations, 
and AI-generated management reports in sequence.

---

## Data Model

Three tables support the full review process:

- **transactions** — BUY/SELL events across tracked securities
- **cost_basis_lots** — acquisition cost per lot 
  (FIFO / LIFO / Specific Identification)
- **tax_reporting** — realized gain/loss output 
  feeding 1099-B reporting

---

## Process Steps

### Step 1 — Run Data Quality Checks (Day 1-2 of month)
- Execute `sql/03_data_quality_checks.sql` via PSQL or 
  `run_pipeline.sh`
- Results auto-saved to `reports/quality_check_results.txt`
- Six checks covering: null detection, calculation validation, 
  status exceptions, discrepancy analysis, gain/loss validation, 
  monthly trend analysis
- Flag any variance > $0.01 between calculated and recorded amounts
- **Note:** PostgreSQL requires `::numeric` casting on financial 
  calculations — applied throughout all SQL files

### Step 2 — Run Advanced Analysis (Day 2)
- Execute `sql/04_advanced_analysis.sql` via PSQL or 
  `run_pipeline.sh`
- Results auto-saved to 
  `reports/advanced_analysis_results.txt`
- Covers: running totals, price deviation outlier detection, 
  FIFO cost basis simulation, account-level exception scoring, 
  month-over-month trend analysis

### Step 3 — Triage Issues By Priority
**Priority 1 — Immediate Action Required:**
- Missing cost basis on tax reports
- Gain/loss calculation variances
- ERROR status transactions above $10,000
- Price outliers flagged by z-score deviation > 2.0

**Priority 2 — Resolve Within 5 Business Days:**
- PENDING transactions older than 3 days
- Discrepancies in tax reporting status
- Missing price data on transactions

**Priority 3 — Monitor:**
- Zero quantity transactions
- Unreported records approaching IRS deadline
- Accounts flagged as HIGH PRIORITY in exception scoring

### Step 4 — Generate Management Report (Day 3)
- `run_pipeline.sh` executes notebooks automatically
- `notebooks/03_analysis.ipynb` — produces Plotly 
  visualizations saved to `visualizations/`
- `notebooks/04_ai_analysis.ipynb` — generates executive 
  summary via Claude AI API saved to 
  `reports/management_report.md`
- `notebooks/05_ai_deep_analysis.ipynb` — generates deep-dive 
  analysis on highest-risk areas saved to 
  `reports/management_report_detailed.md`
- Distribute reports to Operations Manager by end of Day 3

### Step 5 — Resolution Tracking
- Log all issues in the Exception Tracking Report
- Update status daily until resolved
- Escalate unresolved Priority 1 items to team lead 
  after 24 hours
- Cross-reference account-level exception scores to 
  prioritize remediation order

### Step 6 — Month End Sign-Off
- Confirm all Priority 1 issues resolved
- Validate IRS reporting status for all SELL transactions
- Verify holding period classifications 
  (SHORT vs LONG term — tax rate implications)
- Archive monthly reports and issue log to `reports/` folder

---

## Key Technical Notes

- All SQL files use explicit `::numeric` casting for 
  financial calculations
- Date columns require `::DATE` casting when loaded 
  via pandas to avoid text/DATE type mismatches
- Pipeline runs from project root — all outputs route 
  to correct subfolders automatically
- AI reports use multi-turn Claude API conversations 
  for deeper analysis beyond summary reporting
- Shell scripts use `set -e` — pipeline stops 
  automatically if any step fails

---

## Key Contacts
- Operations Manager: [Name]
- Tax Reporting Lead: [Name]
- Product Team: [Name]

---

## Related Documents
- `sql/03_data_quality_checks.sql`
- `sql/04_advanced_analysis.sql`
- `setup_data.sh` — data setup pipeline
- `run_pipeline.sh` — analysis pipeline
- IRS 1099-B Filing Guidelines