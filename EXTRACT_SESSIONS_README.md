# Extract Common Sessions Script

This script extracts and matches common session files from two WhatsApp session zip archives (`seller1.zip` and `buyer_report.zip`).

## What it does

The script:
1. Extracts both `seller1.zip` and `buyer_report.zip`
2. Identifies phone numbers that exist in both archives
3. Creates individual zip files for each matched phone number containing:
   - `.json` files from both archives (prefixed with `seller1_` and `buyer_`)
   - `.session` files from both archives (prefixed with `seller1_` and `buyer_`)
   - `tdata` directory from buyer_report (if it exists, prefixed with `buyer_`)

## Requirements

- Node.js 18 or higher
- `unzip` command-line tool (usually pre-installed on Linux/macOS)
- `zip` command-line tool (usually pre-installed on Linux/macOS)

## Usage

1. Ensure `seller1.zip` and `buyer_report.zip` are in the root directory of the project

2. Run the script:
   ```bash
   node extract-common-sessions.js
   ```

3. The script will create a `matched_sessions/` directory containing individual zip files for each matched phone number

## Output

- Output directory: `matched_sessions/`
- Output file naming: `+{phone_number}_matched.zip`
- Example: `+380639103827_matched.zip`

### Output Zip Structure

Each matched zip file contains:
```
+380671029936_matched.zip
├── seller1_+380671029936.json
├── seller1_+380671029936.session
├── buyer_+380671029936.json
├── buyer_+380671029936.session
└── buyer_380671029936_tdata/      (if tdata exists in buyer_report)
    ├── key_datas
    ├── D877F783D5D3EF8Cs
    └── D877F783D5D3EF8C/
        └── maps
```

## Example Output

```
=== Session File Matcher ===

Extracting seller1.zip...
Extracting buyer_report.zip...

Analyzing phone numbers...
Seller1 has 1361 phone numbers
Buyer report has 953 phone numbers
Found 60 common phone numbers

Creating matched zip files...

Creating zip for +380639103827...
Created +380639103827_matched.zip
...

=== Complete ===
Created 60 matched session zip files in 'matched_sessions' directory
```

## Notes

- The script uses temporary directories (`temp_extraction/`) which are automatically cleaned up after execution
- Both temporary and output directories are excluded from git (see `.gitignore`)
- The script will overwrite existing matched zip files if run multiple times
