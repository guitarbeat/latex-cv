# LaTeX CV (clean setup)

This repo builds a single LaTeX CV from `src/CV.tex`.

## Build (default)

```sh
make pdf
```

Outputs `build/CV.pdf` using pdfLaTeX and standard LaTeX fonts.

## Exact font match to the original (Calibri)

The original DOCX/PDF uses Calibri (body) and Calibri Light (headings).
To match that exactly:

1) Install the fonts system‑wide (e.g., via Microsoft Office):
   - Calibri.ttf (and Bold/Italic)
   - Calibri Light.ttf

2) Build with XeLaTeX:

```sh
make pdf_xe
```

If fonts are missing, the XeLaTeX build will fail and instruct you to install them.

## Clean

```sh
make clean
```

Removes the `build/` directory.
