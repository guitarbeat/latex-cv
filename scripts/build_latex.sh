#!/bin/bash
set -e

OUT_DIR="$1"
SRC="$2"
BASENAME=$(basename "$SRC" .tex)
LOG="$OUT_DIR/$BASENAME.log"

# Function to run xelatex
run_xelatex() {
    xelatex -output-directory="$OUT_DIR" "$SRC"
}

# First run
echo "Running xelatex (pass 1)..."
run_xelatex

# Check if a rerun is needed
if grep -q "Rerun to get" "$LOG" || grep -q "Rerun to get outlines right" "$LOG"; then
    echo "Rerun required. Running xelatex (pass 2)..."
    run_xelatex
else
    echo "No rerun required."
fi
