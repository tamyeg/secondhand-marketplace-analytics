"""Marketplace exploratory analysis on synthetic listing-level data."""
from pathlib import Path
import pandas as pd
import matplotlib.pyplot as plt

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data" / "listings.csv"
OUT = ROOT / "outputs"
OUT.mkdir(exist_ok=True)

def main():
    df = pd.read_csv(DATA, parse_dates=["created_at"])
    assert df.listing_id.is_unique
    assert df.sold.isin([0, 1]).all()
    assert (df.listing_price_eur > 0).all()
    summary = df.groupby("category").agg(listings=("listing_id", "size"), sold=("sold", "sum"), median_price_eur=("listing_price_eur", "median"), avg_views=("views", "mean"))
    summary["sell_through_rate"] = (summary.sold / summary.listings).round(3)
    summary.sort_values("sell_through_rate", ascending=False).round(2).to_csv(OUT / "category_summary.csv")
    print(summary.sort_values("sell_through_rate", ascending=False).round(2))
    ax = summary.sort_values("sell_through_rate")["sell_through_rate"].plot(kind="barh", title="Observed sell-through rate by category (synthetic)")
    ax.set_xlabel("Sold listings / total listings")
    plt.tight_layout()
    plt.savefig(OUT / "category_sell_through.png", dpi=150)
    plt.close()
    df.assign(price_band=pd.cut(df.listing_price_eur, [0, 10, 20, 40, 80, float("inf")], labels=["0–10", "10–20", "20–40", "40–80", "80+"])).groupby("price_band", observed=True).sold.agg(["mean", "size"]).to_csv(OUT / "price_band_summary.csv")

if __name__ == "__main__":
    main()
