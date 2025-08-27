# LaTeX CV

This repository contains LaTeX and Pandoc sources to build a curriculum vitae.

## Layout

- `src/`: LaTeX source (`CV.tex`).
- `content/`: YAML content for Pandoc builds.
- `templates/`: LaTeX templates for Pandoc (`latex_classic.tex`, `latex_alt.tex`).
- `filters/`: Pandoc Lua filters (`render_cv.lua`).
- `build/`: Generated PDFs (ignored by git). Aux/log files are cleaned.
- `CV.pdf`: Reference PDF for comparison (checked in).
- `experiments/`: Previous conversion experiments (moved from `convert/`).
- `reference/`: Original docx and scratch text files for reference.

## Prerequisites

Install a LaTeX distribution such as TeX Live or MiKTeX. Ensure `pdflatex` is on your `PATH`. For Debian/Ubuntu:

```sh
sudo apt-get install texlive-latex-base texlive-latex-extra
```

Install Pandoc if you want to use the template-based builds:

```sh
sudo apt-get install pandoc
```

## Building

Using the LaTeX source:

```sh
make pdf
```

This produces `build/CV.pdf` (LaTeX). The command runs twice to resolve references.

Using the Pandoc templates:

```sh
make cv_classic
make cv_alt
```

These produce `build/CV_classic.pdf` and `build/CV_alt.pdf`.

Compare the two Pandoc outputs as text:

```sh
make compare_text
```

## Cleaning

Remove the build directory and all generated files:

```sh
make clean
```
