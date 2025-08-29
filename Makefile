OUT=build

# Methods
LATEX_TEX=methods/latex/CV.tex
PANDOC_META=methods/pandoc-common/cv.yaml
PANDOC_FILTER=methods/pandoc-common/render_cv.lua
TPL_CLASSIC=methods/pandoc-classic/template.tex
TPL_DOCX=methods/pandoc-docxlike/template.tex

.PHONY: all
all: latex pandoc-docx

# LaTeX method (hand-written)
.PHONY: latex
latex: $(OUT)/latex/CV.pdf

$(OUT)/latex:
	mkdir -p $@

$(OUT)/latex/CV.pdf: $(LATEX_TEX) | $(OUT)/latex
	xelatex -output-directory=$(OUT)/latex $(LATEX_TEX)
	xelatex -output-directory=$(OUT)/latex $(LATEX_TEX)

# Pandoc methods
.PHONY: pandoc-docx
pandoc-docx:    $(OUT)/pandoc-docxlike/CV.pdf

$(OUT)/pandoc-docxlike:
	mkdir -p $@

$(OUT)/pandoc-docxlike/CV.pdf: $(PANDOC_META) $(PANDOC_FILTER) $(TPL_DOCX) | $(OUT)/pandoc-docxlike
	pandoc --standalone \
	  --metadata-file=$(PANDOC_META) \
	  --lua-filter=$(PANDOC_FILTER) \
	  --template=$(TPL_DOCX) \
	  -t latex \
	  --pdf-engine=xelatex \
	  -o $@ </dev/null

# Comparison images (requires ImageMagick and pdftoppm)
.PHONY: compare
compare: all
	./scripts/gen_comparisons.sh

.PHONY: score
score: compare
	./scripts/score_methods.sh

.PHONY: context extract validate
context: extract validate

extract:
	./scripts/context_tools.sh extract

validate: all
	./scripts/context_tools.sh validate

.PHONY: clean
clean:
	rm -rf $(OUT)
