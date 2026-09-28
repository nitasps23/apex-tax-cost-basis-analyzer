# Tax & Cost Basis Data Quality Analyzer

> Built specifically to explore the workflows of a Tax & Cost Basis
> operations team at a fintech company.

---

## What This Project Does

Simulates the core data operations of a securities fintech 
platform - generating synthetic transaction data, running SQL 
data quality checks, analyzing cost basis and gain/loss 
reporting, and producing an AI-generated executive summary 
using the Claude API.

---

## Tech Stack

SQL · Python · PostgreSQL · Claude AI · Pandas · 
Plotly · Power BI · Jupyter Notebook · Shell (Bash) · PSQL

---

## Project Structure

```
apex-tax-cost-basis-analyzer/
├── data/           — CSV files
├── docs/           — SOP documentation
├── notebooks/      — data generator + analysis scripts + 
│                     Claude AI reporting
├── reports/        — AI management reports + 
│                     Power BI dashboard
├── sql/            — data quality validation queries
├── visualizations/ — Plotly HTML charts
├── setup_data.sh   — data setup pipeline (run once)
└── run_pipeline.sh — analysis pipeline (run anytime)
```

---

## How To Run

**Phase 1 — Data Setup (run once):**
```bash
bash setup_data.sh
```

**Phase 2 — Analysis Pipeline (run anytime):**
```bash
bash run_pipeline.sh
```

---

## What's Covered

- Synthetic securities transaction data across 3 tables
  (transactions, cost basis lots, tax reporting)
- Six SQL data quality checks - null detection, calculation 
  validation, exception tracking, discrepancy analysis
- Advanced SQL analysis — window functions, FIFO cost basis 
  simulation, outlier detection, exception priority scoring
- Python analysis with Plotly visualizations
- Claude AI API integration for automated management reporting
  and deep-dive analysis
- Power BI dashboard for operational stakeholder reporting
- Shell pipeline automating the full workflow end to end
- SOP document for monthly data quality review process

---

## Key Technical Notes

- PostgreSQL requires explicit `::numeric` casting for ROUND() 
  on financial calculations - critical for tax and cost basis 
  precision
- Date columns loaded via pandas need explicit dtype declaration 
  to avoid text/DATE type mismatches
- File paths in notebooks use `os.path.dirname(
  os.path.abspath(''))` to resolve project root reliably 
  regardless of where the script is called from — ensures 
  outputs always save to the correct subfolder
- PSQL long output routed to files using the `-o` flag 
  rather than scrolling through the terminal pager
- Synthetic data intentionally seeded with real-world quality 
  issues - null prices, zero quantities, status errors, 
  reporting discrepancies

---

## What I Would Improve With More Time

- Connect Power BI directly to PostgreSQL for live refresh
  (currently loads from CSV) and fine-tune reports
- Seed calculation variances into synthetic data so 
  gain/loss validation checks return exceptions
- Expand README with setup instructions and full findings

---

## BI Report

[View Power BI Dashboard →](https://app.powerbi.com/view?r=eyJrIjoiZGYwM2YwN2EtMTQ5Yi00MDM1LTlkOTMtYzI3ZDJlYzFjMzgwIiwidCI6IjQ1ZDU0MDVhLWIwOTUtNDIwZS1hM2NhLWYzMzk1YWViMzY1NCIsImMiOjF9)

---

## Author

**Nita Sokphoodsa**  
Data & BI Analyst  
*Project developed with Claude AI assistance*
