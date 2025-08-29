#!/usr/bin/env bash
set -euo pipefail

# Usage: scripts/convert_docx.sh input.docx output.pdf
in_docx=${1:-}
out_pdf=${2:-}

if [[ -z "$in_docx" || -z "$out_pdf" ]]; then
  echo "Usage: $0 input.docx output.pdf" >&2
  exit 2
fi

mkdir -p "$(dirname "$out_pdf")"

# 1) LibreOffice / soffice path
if command -v soffice >/dev/null 2>&1; then
  soffice --headless --convert-to pdf --outdir "$(dirname "$out_pdf")" "$in_docx"
  # Move/rename if needed
  cand="$(dirname "$out_pdf")/$(basename "${in_docx%.docx}").pdf"
  if [[ -f "$cand" && "$cand" != "$out_pdf" ]]; then mv -f "$cand" "$out_pdf"; fi
  echo "Converted via LibreOffice: $out_pdf"
  exit 0
fi

# 2) Python docx2pdf (requires MS Word on macOS or Windows)
if command -v python3 >/dev/null 2>&1; then
  if python3 - << 'PY' >/dev/null 2>&1
import importlib; import sys
sys.exit(0 if importlib.util.find_spec('docx2pdf') else 1)
PY
  then
    python3 -m docx2pdf "$in_docx" "$out_pdf"
    echo "Converted via python docx2pdf: $out_pdf"
    exit 0
  fi
fi

# 3) AppleScript with Microsoft Word on macOS (if installed)
if command -v osascript >/dev/null 2>&1; then
  osascript <<OSA || true
on run argv
  set inPath to POSIX file (item 1 of argv) as alias
  set outPath to (item 2 of argv)
  tell application "Microsoft Word"
    activate
    set theDoc to open inPath
    save as theDoc file name outPath file format format PDF
    close theDoc saving no
  end tell
end run
OSA
  if [[ -f "$out_pdf" ]]; then
    echo "Converted via Microsoft Word AppleScript: $out_pdf"
    exit 0
  fi
fi

echo "No supported converter found. Options:" >&2
echo " - Install LibreOffice: soffice --headless --convert-to pdf" >&2
echo " - Install python docx2pdf (pip install docx2pdf) with MS Word available" >&2
echo " - Use Microsoft Word GUI: File > Save As PDF" >&2
exit 1

