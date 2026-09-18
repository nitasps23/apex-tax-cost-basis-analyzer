# Standard Operating Procedure
## Tax & Cost Basis Data Quality Review
**Version:** 1.0  
**Last Updated:** 09/17/2026  
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

## Process Steps

### Step 1 — Run Data Quality Checks (Day 1-2 of month)
- Execute data_quality_checks.sql against current month data
- Document issue counts in the Data Quality Log
- Flag any variance > $0.01 between calculated and recorded amounts

### Step 2 — Triage Issues By Priority
**Priority 1 — Immediate Action Required:**
- Missing cost basis on tax reports
- Gain/loss calculation variances
- ERROR status transactions above $10,000

**Priority 2 — Resolve Within 5 Business Days:**
- PENDING transactions older than 3 days
- Discrepancies in tax reporting status
- Missing price data on transactions

**Priority 3 — Monitor:**
- Zero quantity transactions
- Unreported records approaching IRS deadline

### Step 3 — Generate Management Report
- Run analysis.py to produce summary statistics
- Run ai_analysis.py to generate executive summary
- Distribute to Operations Manager by Day 3

### Step 4 — Resolution Tracking
- Log all issues in the Exception Tracking Report
- Update status daily until resolved
- Escalate unresolved Priority 1 items to team lead after 24 hours

### Step 5 — Month End Sign-Off
- Confirm all Priority 1 issues resolved
- Validate IRS reporting status for all SELL transactions
- Archive monthly report with issue log

---

## Key Contacts
- Operations Manager: [Name]
- Tax Reporting Lead: [Name]
- Product Team: [Name]

---

## Related Documents
- Data Quality Check SQL Scripts
- Exception Tracking Report Template
- IRS 1099-B Filing Guidelines