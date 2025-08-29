#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR=$(cd "$(dirname "$0")/.." && pwd)
CMP_DIR="$ROOT_DIR/compare"
ORIG_DIR="$CMP_DIR/original"
METH_DIR="$CMP_DIR/methods"
OUT_JSON="$CMP_DIR/scores.json"

if command -v compare >/dev/null 2>&1; then COMPARE_CMD=(compare); elif command -v magick >/dev/null 2>&1; then COMPARE_CMD=(magick compare); else echo "compare not found" >&2; exit 1; fi

declare -a METHODS
[ -d "$METH_DIR/latex" ] && METHODS+=(latex)
[ -d "$METH_DIR/pandoc-docxlike" ] && METHODS+=(pandoc-docxlike)
[ -d "$METH_DIR/pandoc-classic" ] && METHODS+=(pandoc-classic)
[ -d "$METH_DIR/pandoc-alt" ] && METHODS+=(pandoc-alt)

pages=()
while IFS= read -r f; do b=$(basename "$f"); n=${b#page-}; n=${n%.png}; pages+=("$n"); done < <(find "$ORIG_DIR" -type f -name 'page-*.png' | sort)

printf '{\n  "totals": {\n' > "$OUT_JSON"
first=1
# Bash on macOS may not support associative arrays without bash 4+; avoid them
for m in "${METHODS[@]}"; do
  total=0
  for p in "${pages[@]}"; do
    left="$ORIG_DIR/page-$p.png"
    right="$METH_DIR/$m/page-$p.png"
    [ -f "$right" ] || continue
    ae=$("${COMPARE_CMD[@]}" -metric AE "$left" "$right" null: 2>&1 || true)
    ae=${ae%% *}
    [[ "$ae" =~ ^[0-9]+$ ]] && total=$((total + ae))
  done
  if [ $first -eq 0 ]; then printf ',\n' >> "$OUT_JSON"; fi
  first=0
  printf '    "%s": %s' "$m" "$total" >> "$OUT_JSON"
done
printf '\n  },\n  "pages": {\n' >> "$OUT_JSON"

page_first=1
for p in "${pages[@]}"; do
  # Per-page scores block
  [ $page_first -eq 0 ] && printf ',\n' >> "$OUT_JSON"
  page_first=0
  printf '    "%s": {\n' "$p" >> "$OUT_JSON"
  mfirst=1
  for m in "${METHODS[@]}"; do
    left="$ORIG_DIR/page-$p.png"; right="$METH_DIR/$m/page-$p.png"
    [ -f "$right" ] || continue
    ae=$("${COMPARE_CMD[@]}" -metric AE "$left" "$right" null: 2>&1 || true)
    ae=${ae%% *}
    [[ "$ae" =~ ^[0-9]+$ ]] || ae=0
    [ $mfirst -eq 0 ] && printf ',\n' >> "$OUT_JSON"
    mfirst=0
    printf '      "%s": %s' "$m" "$ae" >> "$OUT_JSON"
  done
  printf '\n    }' >> "$OUT_JSON"
done

printf '\n  }\n}\n' >> "$OUT_JSON"

echo "Scores written to $OUT_JSON"
