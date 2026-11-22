# Second-Hand Marketplace Analytics (Synthetic Dataset)

An independent portfolio case study exploring how listing prices, categories and engagement relate to observed sales in a **simulated** second-hand marketplace. **Not affiliated with Vinted. No real Vinted or customer data are used.**

## Questions
1. Which categories show the highest observed sell-through rate?
2. How do listing prices and engagement vary by category?
3. Which sellers have the most observed sales (with a minimum-listing filter)?
4. How do listing volumes vary across listing-month cohorts?

## Tools
- Python 3.10+, pandas, matplotlib
- PostgreSQL for SQL practice

## Quick start
```bash
python -m pip install -r requirements.txt
python src/analyze.py
```
This produces CSV summaries and a bar chart in `outputs/`. To run PostgreSQL queries, create the table using `sql/marketplace_analysis.sql`, import `data/listings.csv` using the commented `\copy` command and execute the SELECT statements.

## Data dictionary
Each row is one simulated listing. `sold` is 1 if the listing is marked as sold at the snapshot date; `sale_price_eur` is populated for sold listings. `created_at` records listing creation, not a sale date. `days_to_snapshot` is synthetic and is not used as a sales duration.

## Limitations
- All data are synthetic, generated for teaching and demonstration. No causal conclusions can be drawn.
- This is a single cross-sectional snapshot: sell-through is not a true time-based conversion metric.
- Engagement and sales relationships are built into the simulation and are not empirical marketplace findings.
- No experiment assignment or actual transaction timestamp is available.

## Next extensions
- Add unit tests and an interactive Streamlit dashboard.
- Add a documented star schema and repeatable PostgreSQL ETL flow.
- Test a separate A/B experiment dataset with statistical inference.

## Repository structure
- `data/`: synthetic sample listings
- `src/`: Python analysis script
- `sql/`: PostgreSQL analysis queries
- `outputs/`: generated tables and visualization
