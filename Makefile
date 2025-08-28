OUT=build

# Methods
LATEX_TEX=methods/latex/CV.tex
PANDOC_META=methods/pandoc-common/cv.yaml
PANDOC_FILTER=methods/pandoc-common/render_cv.lua
TPL_CLASSIC=methods/pandoc-classic/template.tex
TPL_ALT=methods/pandoc-alt/template.tex
TPL_DOCX=methods/pandoc-docxlike/template.tex

.PHONY: all
all: latex pandoc-classic pandoc-alt pandoc-docx

# LaTeX method (hand-written)
.PHONY: latex
latex: $(OUT)/latex/CV.pdf

$(OUT)/latex:
	mkdir -p $@

$(OUT)/latex/CV.pdf: $(LATEX_TEX) | $(OUT)/latex
	pdflatex -output-directory=$(OUT)/latex $(LATEX_TEX)
	pdflatex -output-directory=$(OUT)/latex $(LATEX_TEX)

# Pandoc methods
.PHONY: pandoc-classic pandoc-alt pandoc-docx
pandoc-classic: $(OUT)/pandoc-classic/CV.pdf
pandoc-alt:     $(OUT)/pandoc-alt/CV.pdf
pandoc-docx:    $(OUT)/pandoc-docxlike/CV.pdf

$(OUT)/pandoc-classic:
	mkdir -p $@
$(OUT)/pandoc-alt:
	mkdir -p $@
$(OUT)/pandoc-docxlike:
	mkdir -p $@

$(OUT)/pandoc-classic/CV.pdf: $(PANDOC_META) $(PANDOC_FILTER) $(TPL_CLASSIC) | $(OUT)/pandoc-classic
	pandoc --standalone \
	  --metadata-file=$(PANDOC_META) \
	  --lua-filter=$(PANDOC_FILTER) \
	  --template=$(TPL_CLASSIC) \
	  -t latex \
	  -o $@ </dev/null

$(OUT)/pandoc-alt/CV.pdf: $(PANDOC_META) $(PANDOC_FILTER) $(TPL_ALT) | $(OUT)/pandoc-alt
	pandoc --standalone \
	  --metadata-file=$(PANDOC_META) \
	  --lua-filter=$(PANDOC_FILTER) \
	  --template=$(TPL_ALT) \
	  -t latex \
	  -o $@ </dev/null

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

.PHONY: clean
clean:
	rm -rf $(OUT)
