# LaTeX CV

This repository contains a LaTeX source file that reproduces the curriculum vitae found in the provided `CV_original.pdf`.

> **Note:** The included `CV_original.pdf` was not generated from `src/CV.tex`; it is an existing PDF used purely as a reference. The LaTeX source is an independent recreation that you can compile to compare against the reference PDF.

## Layout

- `src/` – LaTeX source (`CV.tex`)
- `CV_original.pdf` – reference PDF for comparison
- `build/` – generated build artefacts (ignored by git)

## Prerequisites

Install a LaTeX distribution such as [TeX Live](https://www.tug.org/texlive/) or MiKTeX. On Debian/Ubuntu systems the required packages can be installed with:

```sh
sudo apt-get install texlive-latex-base texlive-latex-extra
```

Ensure that `pdflatex` is available on your `PATH` after installation before attempting to build.

## Building

Compile the document using the included `Makefile`:

```sh
make pdf
```

The `pdflatex` command runs twice so that cross references (like page numbers in the footer) are resolved. The resulting PDF will be written to `build/CV.pdf`.

After compilation you can compare the generated PDF to the reference `CV_original.pdf` to ensure they match.

## Cleaning

Remove the `build/` directory with:

```sh
make clean
```
