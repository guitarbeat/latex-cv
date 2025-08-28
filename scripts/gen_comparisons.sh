#!/usr/bin/env bash
set -euo pipefail

# Generate labeled side-by-side and diff images comparing the original PDF pages
# against multiple variants: src (LaTeX), classic, alt, docxlike.

ROOT_DIR=$(cd "$(dirname "$0")/.." && pwd)
REF_DIR="$ROOT_DIR/reference"
BUILD_DIR="$ROOT_DIR/build"
CMP_DIR="$ROOT_DIR/compare"
ORIG_DIR="$CMP_DIR/original"
METH_DIR="$CMP_DIR/methods"
SIDE_DIR="$CMP_DIR/side"
DIFF_DIR="$CMP_DIR/diffs"

mkdir -p "$ORIG_DIR" "$METH_DIR/latex" "$METH_DIR/pandoc-classic" "$METH_DIR/pandoc-alt" "$METH_DIR/pandoc-docxlike" "$SIDE_DIR" "$DIFF_DIR/latex" "$DIFF_DIR/pandoc-classic" "$DIFF_DIR/pandoc-alt" "$DIFF_DIR/pandoc-docxlike"

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

ORIG_PDF="$REF_DIR/original.pdf"
if [ ! -f "$ORIG_PDF" ]; then
  echo "Missing reference/original.pdf; please add your original PDF." >&2
  exit 1
fi

# Export PDFs to PNGs at 200 DPI
echo "Exporting PDFs to PNGs (200 DPI)..."
rm -f "$ORIG_DIR"/page-*.png
pdftoppm -png -r 200 "$ORIG_PDF" "$ORIG_DIR/page"

# Export only if the method PDF exists
[ -f "$BUILD_DIR/latex/CV.pdf" ] && pdftoppm -png -r 200 "$BUILD_DIR/latex/CV.pdf"            "$METH_DIR/latex/page" || true
[ -f "$BUILD_DIR/pandoc-classic/CV.pdf" ] && pdftoppm -png -r 200 "$BUILD_DIR/pandoc-classic/CV.pdf"   "$METH_DIR/pandoc-classic/page" || true
[ -f "$BUILD_DIR/pandoc-alt/CV.pdf" ] && pdftoppm -png -r 200 "$BUILD_DIR/pandoc-alt/CV.pdf"       "$METH_DIR/pandoc-alt/page" || true
[ -f "$BUILD_DIR/pandoc-docxlike/CV.pdf" ] && pdftoppm -png -r 200 "$BUILD_DIR/pandoc-docxlike/CV.pdf"  "$METH_DIR/pandoc-docxlike/page" || true

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
  local left="$ORIG_DIR/page-$page.png"
  local right="$METH_DIR/$variant/page-$page.png"
  local left_labeled="$CMP_DIR/_tmp_left_${variant}_${page}.png"
  local right_labeled="$CMP_DIR/_tmp_right_${variant}_${page}.png"
  local diff="$DIFF_DIR/$variant/diff-${page}.png"

  [ -f "$left" ] || { echo "Missing original: $left" >&2; return; }
  [ -f "$right" ] || { echo "Missing variant ($variant): $right" >&2; return; }

  label_image "$left"  "Original"            "$left_labeled"
  label_image "$right" "$(title_case "$variant")" "$right_labeled"
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
done < <(find "$ORIG_DIR" -type f -name 'page-*.png' | sort)

for p in "${pages[@]}"; do
  for v in latex pandoc-classic pandoc-alt pandoc-docxlike; do
    make_side_and_diff "$p" "$v"
  done
  # Build a single montage per page: include whichever variants exist
  LBL_FILES=()
  L1="$CMP_DIR/_tmp_L1_$p.png"; label_image "$ORIG_DIR/page-$p.png" "Original" "$L1"; LBL_FILES+=("$L1")
  if [ -f "$METH_DIR/latex/page-$p.png" ]; then L2="$CMP_DIR/_tmp_L2_$p.png"; label_image "$METH_DIR/latex/page-$p.png" "LaTeX" "$L2"; LBL_FILES+=("$L2"); fi
  if [ -f "$METH_DIR/pandoc-classic/page-$p.png" ]; then L3="$CMP_DIR/_tmp_L3_$p.png"; label_image "$METH_DIR/pandoc-classic/page-$p.png" "Pandoc Classic" "$L3"; LBL_FILES+=("$L3"); fi
  if [ -f "$METH_DIR/pandoc-alt/page-$p.png" ]; then L4="$CMP_DIR/_tmp_L4_$p.png"; label_image "$METH_DIR/pandoc-alt/page-$p.png" "Pandoc Alt" "$L4"; LBL_FILES+=("$L4"); fi
  if [ -f "$METH_DIR/pandoc-docxlike/page-$p.png" ]; then L5="$CMP_DIR/_tmp_L5_$p.png"; label_image "$METH_DIR/pandoc-docxlike/page-$p.png" "Pandoc Docxlike" "$L5"; LBL_FILES+=("$L5"); fi
  "${CONVERT_CMD[@]}" "${LBL_FILES[@]}" +append "$SIDE_DIR/side-$p.png"
  rm -f "${LBL_FILES[@]}"
done

echo "Done. See:"
echo "  - $SIDE_DIR/side-<page>.png (all methods)"
echo "  - $DIFF_DIR/<method>/diff-<page>.png"
