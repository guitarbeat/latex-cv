#!/bin/bash
set -e

TEX_FILE="$1"
OUT_DIR="$2"
JOB_NAME=$(basename "$TEX_FILE" .tex)

# Ensure output directory exists
mkdir -p "$OUT_DIR"

# Function to run xelatex
run_xelatex() {
    xelatex -halt-on-error -interaction=nonstopmode -output-directory="$OUT_DIR" "$TEX_FILE"
}

# Run first pass
echo "Running XeLaTeX (Pass 1)..."
run_xelatex

LOG_FILE="$OUT_DIR/$JOB_NAME.log"

# Check for rerun requirements
# Common patterns for rerun:
# "Rerun to get cross-references right"
# "Rerun to get citations right"
# "Label(s) may have changed. Rerun to get cross-references right"
# "Package rerunfilecheck Warning: File ... has changed."

if grep -E "Rerun to get|Please rerun|Label\(s\) may have changed" "$LOG_FILE" > /dev/null; then
    echo "References or outlines changed. Running XeLaTeX (Pass 2)..."
    run_xelatex
else
    echo "No rerun needed."
fi
