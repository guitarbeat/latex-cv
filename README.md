CV Recreation (Reference vs Methods)

Goal: reproduce the original CV (from Microsoft Word) using LaTeX/Pandoc. The repo clearly separates the reference from each build method and provides labeled visual comparisons.

Layout

- reference/
  - original.pdf: the ground truth PDF (from Word)
  - original.docx: the original document (for reference)
- methods/
  - latex/: hand-written LaTeX attempt (CV.tex)
  - pandoc-common/: shared metadata and filter (cv.yaml, render_cv.lua)
  - pandoc-docxlike/: Word-like Pandoc template (template.tex)
- build/: per-method PDFs under build/<method>/CV.pdf
- compare/: generated comparisons (PNGs)
  - original/page-*.png: pages exported from reference/original.pdf
  - methods/<method>/page-*.png: pages exported from each method’s PDF
  - side/side-<page>.png: labeled montage Original | LaTeX | Classic | Alt | Docxlike
  - diffs/<method>/diff-<page>.png: per-method pixel diffs vs original
- scripts/: comparison generator (gen_comparisons.sh)

Prerequisites

- LaTeX (TeX Live or MiKTeX) with pdflatex and xelatex
- Pandoc
- Poppler (pdftoppm) and ImageMagick (convert or magick)

Build

- Build every method:
  make all

Outputs:
- build/latex/CV.pdf
- build/pandoc-docxlike/CV.pdf

Compare

- Ensure the original is at reference/original.pdf
- Generate comparisons (side-by-sides + diffs):
  make compare

Results:
- compare/side/side-<page>.png (5-up montage)
- compare/diffs/<method>/diff-<page>.png

Clean

  make clean
