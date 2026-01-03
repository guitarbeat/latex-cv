OUT=build

# LaTeX CV source
LATEX_TEX=methods/latex/CV.tex

.PHONY: all
all: latex

# LaTeX method (hand-written)
.PHONY: latex
latex: $(OUT)/latex/CV.pdf

$(OUT)/latex:
	mkdir -p $@

$(OUT)/latex/CV.pdf: $(LATEX_TEX) | $(OUT)/latex
	# Optimization: Use latexmk to automatically handle dependencies and minimize recompilation passes.
	# It replaces the previous unconditional double-run of xelatex.
	latexmk -xelatex -output-directory=$(OUT)/latex -interaction=nonstopmode $(LATEX_TEX)

.PHONY: context extract validate
context: extract validate

extract:
	./scripts/context_tools.sh extract

validate: latex
	./scripts/context_tools.sh validate

.PHONY: clean
clean:
	rm -rf $(OUT)
