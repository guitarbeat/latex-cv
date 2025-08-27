# LaTeX CV

This repository contains a LaTeX source file that reproduces the curriculum vitae found in the provided `CV.pdf`.

To compile the document to PDF, ensure that you have a working LaTeX distribution (e.g. TeX Live or MiKTeX).

Compile the document with `pdflatex` as follows:

```sh
pdflatex CV.tex
```

You may need to run the command twice so that all cross references (such as page numbers in the footer) are resolved.

The resulting `CV.pdf` will closely follow the formatting, sections and styling of the original CV while being completely editable in LaTeX.
