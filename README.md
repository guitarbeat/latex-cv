CV Recreation (Reference vs Methods)


This repository contains a LaTeX source file that reproduces the curriculum vitae found in the provided `CV_original.pdf`.

> **Note:** The included `CV_original.pdf` was not generated from `src/CV.tex`; it is an existing PDF used purely as a reference. The LaTeX source is an independent recreation that you can compile to compare against the reference PDF.

Goal: reproduce the original CV (from Microsoft Word) using LaTeX/Pandoc. The repo clearly separates the reference from each build method and provides labeled visual comparisons.

Layout

- `src/` – LaTeX source (`CV.tex`)
- `CV_original.pdf` – reference PDF for comparison
- `build/` – generated build artefacts (ignored by git)

- reference/
  - original.pdf: the ground truth PDF (from Word)
  - original.docx: the original document (for reference)
- methods/
  - latex/: hand-written LaTeX attempt (CV.tex)
  - pandoc-common/: shared metadata and filter (cv.yaml, render_cv.lua)
  - pandoc-classic/: Pandoc template with classic LaTeX look (template.tex)
  - pandoc-alt/: Pandoc template with alternate look (template.tex)
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

- Outputs:
  - build/latex/CV.pdf
  - build/pandoc-classic/CV.pdf
  - build/pandoc-alt/CV.pdf
  - build/pandoc-docxlike/CV.pdf

Compare

- Ensure the original is at reference/original.pdf
- Generate comparisons (side-by-sides + diffs):
  make compare

Results:
- compare/side/side-<page>.png (5-up montage)
- compare/diffs/<method>/diff-<page>.png

After compilation you can compare the generated PDF to the reference `CV_original.pdf` to ensure they match.

Clean

  make clean
