import csv

input_file = r'c:\Users\USER\Downloads\XT - INFO BO TLS & CRM - CRM.csv'
output_file = r'c:\Users\USER\Downloads\XT - INFO BO TLS & CRM - CRM_standard.csv'

def merge_multiline_header(header_lines):
    # Merge multi-line headers into a single line
    merged = []
    col = ''
    for line in header_lines:
        parts = line.strip().split('","')
        if not merged:
            merged = parts
        else:
            merged = [a + ' ' + b for a, b in zip(merged, parts)]
    # Remove any remaining quotes and extra spaces
    merged = [h.replace('"', '').replace('\n', ' ').strip() for h in merged]
    return merged

with open(input_file, encoding='utf-8') as f:
    lines = f.readlines()

# Find header lines (until the first line that starts with a digit)
header_lines = []
data_start = 0
for i, line in enumerate(lines):
    if line[0].isdigit():
        data_start = i
        break
    header_lines.append(line.strip())

header = merge_multiline_header(header_lines)

# Write to standard CSV
with open(output_file, 'w', newline='', encoding='utf-8') as f_out:
    writer = csv.writer(f_out)
    writer.writerow(header)
    for line in lines[data_start:]:
        # Remove trailing newlines and split by comma, but keep quoted fields together
        row = next(csv.reader([line]))
        writer.writerow(row)

print(f"Converted CSV saved to: {output_file}")