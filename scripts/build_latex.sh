#!/usr/bin/env bash
set -euo pipefail

OUT_DIR="$1"
SRC="$2"
LOG="$OUT_DIR/$(basename "$SRC" .tex).log"

# Function to run xelatex
run_xelatex() {
  xelatex -output-directory="$OUT_DIR" "$SRC"
}

# Run 1
run_xelatex

# Check for rerun requirements in the log file
# Common messages that indicate a rerun is needed:
# "Rerun to get /PageLabels entry" (hyperref)
# "Rerun to get outlines right" (rerunfilecheck/hyperref)
# "Label(s) may have changed. Rerun to get cross-references right."
# "Package natbib Warning: Citation(s) may have changed. Rerun to get citations right."
if grep -E -q "(Rerun to get|Rerun to get outlines right|Label\(s\) may have changed|Citation\(s\) may have changed)" "$LOG"; then
  echo "Latex log indicates rerun required. Running pass 2..."
  run_xelatex
fi
