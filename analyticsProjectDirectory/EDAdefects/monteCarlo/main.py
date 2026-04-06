# =============================================================================
# Manufacturing Process Defect Simulation
# Monte Carlo Simulation | Python + Power BI
# =============================================================================

import numpy as np
import pandas as pd

# =============================================================================
# 1. CONFIGURATION
# =============================================================================

np.random.seed(42)
N_ITERATIONS = 10_000

# Current process failure probabilities per stage
# Estimates derived from manufacturing defect records analysis
current_stages = {
    "Stage 1: Raw Material Intake":  0.03,
    "Stage 2: Machining":            0.07,
    "Stage 3: Assembly":             0.10,  # highest risk stage
    "Stage 4: Inline Inspection":    0.04,
    "Stage 5: Rework":               0.06,
    "Stage 6: Final Inspection":     0.02,
}

# Improved process — targeted intervention at Stage 3
# Recommendation: inline QC check reduces assembly failure rate from 10% to 4%
improved_stages = {
    "Stage 1: Raw Material Intake":  0.03,
    "Stage 2: Machining":            0.07,
    "Stage 3: Assembly":             0.04,  # improved
    "Stage 4: Inline Inspection":    0.04,
    "Stage 5: Rework":               0.06,
    "Stage 6: Final Inspection":     0.02,
}

stage_names = list(current_stages.keys())

# =============================================================================
# 2. SIMULATION FUNCTION
# =============================================================================

def run_simulation(stage_probs: dict, n: int, scenario_label: str) -> pd.DataFrame:
    """
    Runs Monte Carlo simulation over n iterations.
    Each iteration randomly samples pass/fail at each production stage.
    Returns a DataFrame with one row per simulated unit.
    """
    probs = list(stage_probs.values())
    results = []

    for i in range(n):
        unit = {"iteration": i + 1, "scenario": scenario_label}
        unit_failed = False

        for stage, prob in zip(stage_names, probs):
            failed = np.random.random() < prob
            unit[stage] = int(failed)
            if failed:
                unit_failed = True

        unit["any_defect"] = int(unit_failed)
        unit["total_defects"] = sum(unit[s] for s in stage_names)
        results.append(unit)

    return pd.DataFrame(results)

# =============================================================================
# 3. RUN SIMULATIONS
# =============================================================================

print("Running simulations...")
df_current  = run_simulation(current_stages,  N_ITERATIONS, "Current Process")
df_improved = run_simulation(improved_stages, N_ITERATIONS, "Improved Process")
df_combined = pd.concat([df_current, df_improved], ignore_index=True)
print(f"Complete — {len(df_combined):,} total records generated\n")

# =============================================================================
# 4. SUMMARY STATISTICS
# =============================================================================

def build_summary(df: pd.DataFrame, scenario_label: str) -> pd.DataFrame:
    return pd.DataFrame({
        "stage":        stage_names,
        "defect_rate":  df[stage_names].mean().values,
        "defect_count": df[stage_names].sum().values.astype(int),
        "scenario":     scenario_label
    })

summary_current  = build_summary(df_current,  "Current Process")
summary_improved = build_summary(df_improved, "Improved Process")
summary_combined = pd.concat([summary_current, summary_improved], ignore_index=True)

# Print key findings
for label, df_, summary in [
    ("Current Process",  df_current,  summary_current),
    ("Improved Process", df_improved, summary_combined)
]:
    rate = df_["any_defect"].mean()
    top  = summary.loc[summary["scenario"] == label].nlargest(1, "defect_rate")["stage"].values[0]
    print(f"{label}")
    print(f"  Overall defect rate : {rate:.2%}")
    print(f"  Highest risk stage  : {top}\n")

# Improvement delta
delta = df_current["any_defect"].mean() - df_improved["any_defect"].mean()
print(f"Projected defect rate reduction from intervention: {delta:.2%}\n")

# =============================================================================
# 5. EXPORT TO CSV FOR POWER BI
# =============================================================================

# Raw simulation results — KPI cards, overall defect rate
df_combined.to_csv("simulation_raw.csv", index=False)

# Stage-level summary — bar chart, current vs improved comparison
summary_combined.to_csv("simulation_stage_summary.csv", index=False)

# Histogram data — defect count distribution across iterations
df_combined[["iteration", "total_defects", "scenario"]].to_csv(
    "simulation_histogram.csv", index=False
)

print("Exports complete:")
print("  simulation_raw.csv")
print("  simulation_stage_summary.csv")
print("  simulation_histogram.csv")

