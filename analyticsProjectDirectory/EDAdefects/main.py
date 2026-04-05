import pandas as pd

path = "C:/Users/lando/.cache/kagglehub/datasets/fahmidachowdhury/manufacturing-defects/versions/1/defects_data.csv"
df = pd.read_csv(path)

# Change to desired directory for output Excel file
output_directory = "C:/Users/lando/Documents/VSCODE-Working/analyticsProj/EDAdefects/dashboard_data.xlsx"

# Parse dates
df['defect_date'] = pd.to_datetime(df['defect_date'])
df['month'] = df['defect_date'].dt.to_period('M').astype(str)
df['week'] = df['defect_date'].dt.isocalendar().week

# Defect rate over time (monthly) - total defects, average repair cost, critical defect rate
defect_over_time = df.groupby('month').agg(
    total_defects=('defect_id', 'count'),
    avg_repair_cost=('repair_cost', 'mean'),
    critical_count=('severity', lambda x: (x == 'Critical').sum())
).reset_index()
defect_over_time['critical_rate'] = (
    defect_over_time['critical_count'] / defect_over_time['total_defects'] * 100
).round(2)

# Defect type breakdown - count, average cost, critical defect count
defect_type = df.groupby('defect_type').agg(
    count=('defect_id', 'count'),
    avg_cost=('repair_cost', 'mean'),
    critical=('severity', lambda x: (x == 'Critical').sum())
).reset_index()

# Workload by inspection method (team proxy) - defect count, total cost
workload = df.groupby(['month', 'inspection_method']).agg(
    defect_count=('defect_id', 'count'),
    total_cost=('repair_cost', 'sum')
).reset_index()

# Severity distribution by location - count of each severity level by defect location
severity_location = df.groupby(['defect_location', 'severity']).agg(
    count=('defect_id', 'count')
).reset_index()

# Export all to one Excel file with multiple sheets
with pd.ExcelWriter(output_directory, engine='openpyxl') as writer:
    defect_over_time.to_excel(writer, sheet_name='Defect_Over_Time', index=False)
    defect_type.to_excel(writer, sheet_name='Defect_Type', index=False)
    workload.to_excel(writer, sheet_name='Workload_By_Team', index=False)
    severity_location.to_excel(writer, sheet_name='Severity_By_Location', index=False)
    df.to_excel(writer, sheet_name='Raw_Data', index=False)

print("Done... Open dashboard_data.xlsx and load into Tableau.")

