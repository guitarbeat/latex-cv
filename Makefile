SRC=src
OUT=build
TEX=$(SRC)/CV.tex
PDF=$(OUT)/CV.pdf

# New content-driven build pipeline
CONTENT=content/cv.yaml
FILTER=filters/render_cv.lua
TEMPLATE_CLASSIC=templates/latex_classic.tex
TEMPLATE_ALT=templates/latex_alt.tex

pdf: $(PDF)

$(OUT):
	mkdir -p $(OUT)

$(PDF): $(TEX) | $(OUT)
	pdflatex -output-directory=$(OUT) $(TEX)
	pdflatex -output-directory=$(OUT) $(TEX)

clean:
	rm -rf $(OUT)

.PHONY: pdf_xe
pdf_xe: $(OUT)
	xelatex -output-directory=$(OUT) $(TEX)
	xelatex -output-directory=$(OUT) $(TEX)

.PHONY: cv_classic cv_alt compare_text

cv_classic: $(CONTENT) $(FILTER) $(TEMPLATE_CLASSIC) | $(OUT)
	pandoc --standalone \
	  --metadata-file=$(CONTENT) \
	  --lua-filter=$(FILTER) \
	  --template=$(TEMPLATE_CLASSIC) \
	  -t latex \
	  -o $(OUT)/CV_classic.pdf </dev/null

cv_alt: $(CONTENT) $(FILTER) $(TEMPLATE_ALT) | $(OUT)
	pandoc --standalone \
	  --metadata-file=$(CONTENT) \
	  --lua-filter=$(FILTER) \
	  --template=$(TEMPLATE_ALT) \
	  -t latex \
	  -o $(OUT)/CV_alt.pdf </dev/null

compare_text: cv_classic cv_alt
	pdftotext -layout $(OUT)/CV_classic.pdf $(OUT)/classic.txt
	pdftotext -layout $(OUT)/CV_alt.pdf $(OUT)/alt.txt
	diff -u $(OUT)/classic.txt $(OUT)/alt.txt || true

.PHONY: compare_content
compare_content: cv_classic cv_alt
	# Extract text
	pdftotext -layout $(OUT)/CV_classic.pdf $(OUT)/classic.txt
	pdftotext -layout $(OUT)/CV_alt.pdf $(OUT)/alt.txt
	# Normalize: drop header/contact lines, section headings, and footers
	awk 'BEGIN{IGNORECASE=1} \
	  /A\.L\. Woods,/ {next} \
	  /^\s*$/ {next} \
	  /^\s*[A-Z][A-Z &\-]+\s*$/ {next} \
	  /^\s*Education\s*$/ {next} \
	  /^\s*Research Experience\s*$/ {next} \
	  /^\s*Research Funding\s*$/ {next} \
	  /^\s*Academic Appointments\s*$/ {next} \
	  /^\s*Teaching Experience\s*$/ {next} \
	  /^\s*Honors/ {next} \
	  /^\s*Poster Presentations\s*$/ {next} \
	  /^\s*Academic Service\s*$/ {next} \
	  /^\s*Professional Experience\s*$/ {next} \
	  /^\s*Conference Participation\s*$/ {next} \
	  /@utexas\.edu/ {next} \
	  /aaronwoods\.info/ {next} \
	  /^\s*Department of Biomedical Engineering/ {next} \
	  /^\s*Cockrell School of Engineering/ {next} \
	  /^\s*The University of Texas at Austin/ {next} \
	  /^\s*Austin, TX/ {next} \
	  {print}' $(OUT)/classic.txt > $(OUT)/classic.norm.txt
	awk 'BEGIN{IGNORECASE=1} \
	  /A\.L\. Woods,/ {next} \
	  /^\s*$/ {next} \
	  /^\s*[A-Z][A-Z &\-]+\s*$/ {next} \
	  /^\s*Education\s*$/ {next} \
	  /^\s*Research Experience\s*$/ {next} \
	  /^\s*Research Funding\s*$/ {next} \
	  /^\s*Academic Appointments\s*$/ {next} \
	  /^\s*Teaching Experience\s*$/ {next} \
	  /^\s*Honors/ {next} \
	  /^\s*Poster Presentations\s*$/ {next} \
	  /^\s*Academic Service\s*$/ {next} \
	  /^\s*Professional Experience\s*$/ {next} \
	  /^\s*Conference Participation\s*$/ {next} \
	  /@utexas\.edu/ {next} \
	  /aaronwoods\.info/ {next} \
	  /^\s*Department of Biomedical Engineering/ {next} \
	  /^\s*Cockrell School of Engineering/ {next} \
	  /^\s*The University of Texas at Austin/ {next} \
	  /^\s*Austin, TX/ {next} \
	  {print}' $(OUT)/alt.txt > $(OUT)/alt.norm.txt
	# Diff normalized content
	diff -u $(OUT)/classic.norm.txt $(OUT)/alt.norm.txt || true

.PHONY: cv_docx
cv_docx: $(CONTENT) $(FILTER) templates/latex_docxlike.tex | $(OUT)
	pandoc --standalone \
	  --metadata-file=$(CONTENT) \
	  --lua-filter=$(FILTER) \
	  --template=templates/latex_docxlike.tex \
	  -t latex \
	  --pdf-engine=xelatex \
	  -o $(OUT)/CV_docxlike.pdf </dev/null

.PHONY: compare_images
compare_images: pdf cv_classic cv_alt cv_docx
	./scripts/gen_comparisons.sh
