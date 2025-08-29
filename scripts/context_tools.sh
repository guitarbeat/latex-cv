#!/usr/bin/env bash
set -euo pipefail

# Tools to extract content from the DOCX reference and validate method PDFs
ROOT_DIR=$(cd "$(dirname "$0")/.." && pwd)
REF_DOCX="$ROOT_DIR/reference/original.docx"
REF_PDF="$ROOT_DIR/reference/original.pdf"
OUT_DIR="$ROOT_DIR/reference"
BUILD_DIR="$ROOT_DIR/build"
TMP_DIR="$ROOT_DIR/.context-tmp"

mkdir -p "$TMP_DIR"

extract_from_docx() {
  if [ ! -f "$REF_DOCX" ]; then
    echo "Missing $REF_DOCX" >&2; return 1
  fi
  echo "Extracting DOCX -> Markdown and text"
  pandoc "$REF_DOCX" -t markdown -o "$OUT_DIR/original.md"
  pandoc "$REF_DOCX" -t plain    -o "$OUT_DIR/original.txt"
}

validate_against_original() {
  if [ ! -f "$REF_PDF" ]; then
    echo "Missing $REF_PDF" >&2; return 1
  fi
  if ! command -v pdftotext >/dev/null 2>&1; then
    echo "pdftotext not found" >&2; return 1
  fi
  echo "Extracting text from method PDFs"
  mkdir -p "$TMP_DIR"
  # Original reference text (layout-preserving)
  pdftotext -layout "$REF_PDF" "$TMP_DIR/original.txt"
  for m in latex pandoc-classic pandoc-alt pandoc-docxlike; do
    pdf="$BUILD_DIR/$m/CV.pdf"
    [ -f "$pdf" ] || continue
    pdftotext -layout "$pdf" "$TMP_DIR/$m.txt"
  done
  echo "Computing unified diffs vs original (normalized)"
  # Normalize whitespace lines for a lighter diff
  for f in "$TMP_DIR"/*.txt; do
    awk '{gsub(/[ \t]+$/,"",$0); print}' "$f" > "$f.norm"
  done
  for m in latex pandoc-classic pandoc-alt pandoc-docxlike; do
    [ -f "$TMP_DIR/$m.txt.norm" ] || continue
    echo "--- Diff: $m vs original ---"
    diff -u "$TMP_DIR/original.txt.norm" "$TMP_DIR/$m.txt.norm" || true
  done
  echo "Summarizing line counts"
  wc -l "$TMP_DIR"/*.txt 2>/dev/null || true
}

case "${1:-}" in
  extract)
    extract_from_docx
    ;;
  validate)
    validate_against_original
    ;;
  *)
    echo "Usage: $0 {extract|validate}" >&2
    exit 2
    ;;
esac
