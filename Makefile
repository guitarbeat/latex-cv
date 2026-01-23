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
	xelatex -output-directory=$(OUT)/latex $(LATEX_TEX)
	@if grep -E "Rerun to get|Please rerun|Label\(s\) may have changed|Table widths have changed" $(OUT)/latex/CV.log > /dev/null; then \
		echo "⚡ Bolt: Rerunning XeLaTeX for reference resolution..."; \
		xelatex -output-directory=$(OUT)/latex $(LATEX_TEX); \
	else \
		echo "⚡ Bolt: Single pass sufficient. Skipping second run."; \
	fi

.PHONY: context extract validate
context: extract validate

extract:
	./scripts/context_tools.sh extract

validate: latex
	./scripts/context_tools.sh validate

.PHONY: clean
clean:
	rm -rf $(OUT)
