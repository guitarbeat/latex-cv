SRC=src
OUT=build
TEX=$(SRC)/CV.tex
PDF=$(OUT)/CV.pdf

pdf: $(PDF)

$(OUT):
	mkdir -p $(OUT)

$(PDF): $(TEX) | $(OUT)
	pdflatex -output-directory=$(OUT) $(TEX)
	pdflatex -output-directory=$(OUT) $(TEX)

.PHONY: clean
clean:
	rm -rf $(OUT)

.PHONY: pdf_xe
pdf_xe: $(OUT)
	xelatex -output-directory=$(OUT) $(TEX)
	xelatex -output-directory=$(OUT) $(TEX)
