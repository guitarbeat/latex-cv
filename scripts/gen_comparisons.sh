#!/usr/bin/env bash
set -euo pipefail

# Generate labeled side-by-side and diff images comparing the original PDF pages
# against multiple variants: src (LaTeX), classic, alt, docxlike.

ROOT_DIR=$(cd "$(dirname "$0")/.." && pwd)
IMG_DIR="$ROOT_DIR/images"
NEW_DIR="$IMG_DIR/new"
CMP_DIR="$IMG_DIR/compare"

mkdir -p "$NEW_DIR/src" "$NEW_DIR/classic" "$NEW_DIR/alt" "$NEW_DIR/docxlike" "$CMP_DIR"

# Detect ImageMagick tools
if command -v magick >/dev/null 2>&1; then
  CONVERT_CMD=(magick)
  COMPARE_CMD=(magick compare)
elif command -v convert >/dev/null 2>&1; then
  CONVERT_CMD=(convert)
  if command -v compare >/dev/null 2>&1; then
    COMPARE_CMD=(compare)
  else
    COMPARE_CMD=()
  fi
else
  echo "ImageMagick not found (magick/convert). Please install to generate comparisons." >&2
  exit 1
fi

# Export PDFs to PNGs at 200 DPI
echo "Exporting PDFs to PNGs (200 DPI)..."
pdftoppm -png -r 200 "$ROOT_DIR/build/CV.pdf"          "$NEW_DIR/src/page"
pdftoppm -png -r 200 "$ROOT_DIR/build/CV_classic.pdf"   "$NEW_DIR/classic/page"
pdftoppm -png -r 200 "$ROOT_DIR/build/CV_alt.pdf"       "$NEW_DIR/alt/page"
pdftoppm -png -r 200 "$ROOT_DIR/build/CV_docxlike.pdf"  "$NEW_DIR/docxlike/page"

label_image() {
  local in="$1"; shift
  local label="$1"; shift
  local out="$1"; shift
  # Add a 48px band at top and annotate the label
  "${CONVERT_CMD[@]}" "$in" -gravity north -background white -splice 0x48 \
    -pointsize 22 -fill black -annotate +0+10 "$label" "$out"
}

title_case() {
  # Capitalize first letter, lower the rest
  printf '%s' "$1" | awk '{print toupper(substr($0,1,1)) tolower(substr($0,2))}'
}

make_side_and_diff() {
  local page="$1"; shift
  local variant="$1"; shift
  local left="$IMG_DIR/original/page-$page.png"
  local right="$NEW_DIR/$variant/page-$page.png"
  local left_labeled="$CMP_DIR/_tmp_left_${variant}_${page}.png"
  local right_labeled="$CMP_DIR/_tmp_right_${variant}_${page}.png"
  local side="$CMP_DIR/side-${page}-${variant}.png"
  local diff="$CMP_DIR/diff-${page}-${variant}.png"

  [ -f "$left" ] || { echo "Missing original: $left" >&2; return; }
  [ -f "$right" ] || { echo "Missing variant ($variant): $right" >&2; return; }

  label_image "$left"  "Original"            "$left_labeled"
  label_image "$right" "$(title_case "$variant")" "$right_labeled"
  "${CONVERT_CMD[@]}" "$left_labeled" "$right_labeled" +append "$side"

  if [ ${#COMPARE_CMD[@]} -gt 0 ]; then
    # Absolute error metric; ignore non-zero exit for differences
    "${COMPARE_CMD[@]}" -metric AE "$left" "$right" "$diff" 2>/dev/null || true
  fi
  rm -f "$left_labeled" "$right_labeled"
}

echo "Generating labeled side-by-sides and diffs..."
pages=()
while IFS= read -r f; do
  b=$(basename "$f")
  n=${b#page-}; n=${n%.png}
  pages+=("$n")
done < <(find "$IMG_DIR/original" -type f -name 'page-*.png' | sort)

for p in "${pages[@]}"; do
  for v in src classic alt docxlike; do
    make_side_and_diff "$p" "$v"
  done
done

echo "Done. See $CMP_DIR for side-<page>-<variant>.png and diff-<page>-<variant>.png."
