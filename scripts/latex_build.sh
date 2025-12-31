#!/usr/bin/env bash
set -e

# Usage: ./latex_build.sh <output_dir> <source_file>

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <output_dir> <source_file>"
    exit 1
fi

OUT_DIR="$1"
SRC="$2"
JOBNAME=$(basename "$SRC" .tex)
LOG_FILE="$OUT_DIR/$JOBNAME.log"

echo "⚡ Bolt: Building $SRC..."

# First run
xelatex -output-directory="$OUT_DIR" "$SRC"

# Check if rerun is needed
# We look for standard LaTeX rerun messages in the log file
if grep -qE "Rerun to get|Label\(s\) may have changed|Package hyperref Warning: Rerun" "$LOG_FILE"; then
  echo "⚡ Bolt: Rerunning LaTeX to resolve references..."
  xelatex -output-directory="$OUT_DIR" "$SRC"
else
  echo "⚡ Bolt: No rerun needed."
fi
