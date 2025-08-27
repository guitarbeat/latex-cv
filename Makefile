.RECIPEPREFIX = >

SRC=src
OUT=build
TEX=$(SRC)/CV.tex
PDF=$(OUT)/CV.pdf

pdf: $(PDF)

$(OUT):
> mkdir -p $(OUT)

$(PDF): $(TEX) | $(OUT)
> pdflatex -output-directory=$(OUT) $(TEX)
> pdflatex -output-directory=$(OUT) $(TEX)

clean:
> rm -rf $(OUT)
