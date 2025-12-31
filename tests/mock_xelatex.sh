#!/bin/bash
# Mock xelatex
# Usage: mock_xelatex -output-directory=DIR FILE

OUT_DIR=""
for arg in "$@"; do
  if [[ $arg == -output-directory=* ]]; then
    OUT_DIR="${arg#*=}"
  fi
done

FILE="${!#}" # Last argument
BASENAME=$(basename "$FILE" .tex)

if [ -z "$OUT_DIR" ]; then
    echo "Error: No output dir"
    exit 1
fi

LOG="$OUT_DIR/$BASENAME.log"
RUN_COUNT_FILE="$OUT_DIR/run_count"

# Initialize run count if not exists
if [ ! -f "$RUN_COUNT_FILE" ]; then
    echo "0" > "$RUN_COUNT_FILE"
fi

# Increment run count
CURRENT_COUNT=$(<"$RUN_COUNT_FILE")
NEW_COUNT=$((CURRENT_COUNT + 1))
echo "$NEW_COUNT" > "$RUN_COUNT_FILE"

# Simulate creating a PDF
touch "$OUT_DIR/$BASENAME.pdf"

# If environment variable FORCE_RERUN is set to 1, write the rerun message to log
# But only on the FIRST run.
if [ "$NEW_COUNT" -eq 1 ] && [ "${FORCE_RERUN:-0}" -eq 1 ]; then
    echo "LaTeX Warning: Label(s) may have changed. Rerun to get cross-references right." > "$LOG"
else
    echo "No rerun needed." > "$LOG"
fi
