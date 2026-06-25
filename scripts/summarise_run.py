#!/usr/bin/env python3
"""Extract LAMMPS thermo data and create a compact run summary."""
from __future__ import annotations
import argparse
import csv
from pathlib import Path

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--log", type=Path, required=True)
    parser.add_argument("--output-dir", type=Path, required=True)
    return parser.parse_args()

def read_thermo(path):
    header, rows, active = [], [], False
    for raw_line in path.read_text(errors="replace").splitlines():
        fields = raw_line.split()
        if fields and fields[0] == "Step":
            header, active = fields, True
            continue
        if active and fields:
            try: row = [float(value) for value in fields]
            except ValueError:
                active = False
                continue
            if len(row) == len(header): rows.append(row)
    if not header or not rows: raise ValueError(f"No thermo table found in {path}")
    return header, rows

def main():
    args = parse_args(); args.output_dir.mkdir(parents=True, exist_ok=True)
    header, rows = read_thermo(args.log)
    with (args.output_dir / "thermo.csv").open("w", newline="") as handle:
        writer = csv.writer(handle); writer.writerow(header); writer.writerows(rows)
    try:
        import matplotlib.pyplot as plt
    except ImportError:
        print(f"Parsed {len(rows)} thermo records"); return
    columns = {name: index for index, name in enumerate(header)}
    time_key = "Time" if "Time" in columns else "Step"
    x = [row[columns[time_key]] for row in rows]
    fig, axes = plt.subplots(2, 1, figsize=(8, 6), sharex=True)
    if "Temp" in columns:
        axes[0].plot(x, [row[columns["Temp"]] for row in rows], color="#e26d3f"); axes[0].set_ylabel("Temperature / K")
    if "TotEng" in columns:
        axes[1].plot(x, [row[columns["TotEng"]] for row in rows], color="#16697a"); axes[1].set_ylabel("Total energy / eV")
    axes[1].set_xlabel(time_key); fig.tight_layout(); fig.savefig(args.output_dir / "thermo_summary.png", dpi=180); plt.close(fig)
    print(f"Parsed {len(rows)} thermo records")

if __name__ == "__main__": main()
