MAINDOC=manual

LC=pdflatex
LFLAGS=-interaction=nonstopmode

HTMLC=htlatex
HTMLFLAGS= "" "" "" "--interaction=nonstopmode"

SRC= $(wildcard *.tex)

all: pdf

pdf: ../../doc/$(MAINDOC).pdf

html: ../../doc/$(MAINDOC).html ../../doc/$(MAINDOC).css

$(MAINDOC).toc: $(SRC) wave.pdf ../../version.txt ../gpstudio_doc.tex
	$(LC) $(LFLAGS) $(MAINDOC).tex > /dev/null

$(MAINDOC).pdf: $(SRC) $(MAINDOC).toc ../../version.txt ../gpstudio_doc.tex
	$(LC) $(LFLAGS) $(MAINDOC).tex > /dev/null

../../doc/$(MAINDOC).pdf: $(MAINDOC).pdf
	cp $(MAINDOC).pdf ../../doc/

$(MAINDOC).html: $(SRC) ../../version.txt ../gpstudio_doc.tex
	$(HTMLC) $(MAINDOC).tex $(HTMLFLAGS) > /dev/null

../../doc/$(MAINDOC).html: $(MAINDOC).html
	cp $(MAINDOC).html ../../doc/
../../doc/$(MAINDOC).css: $(MAINDOC).css
	cp $(MAINDOC).css ../../doc/

clean:
	rm -rf *.log *.aux *.synctex.gz $(MAINDOC).pdf *.4ct *.4tc *.dvi *.html *.css *.idv *.lg *.log *.tmp *.xref *.man *.cfg *.xml *-fig*.tex *-fig*.dot *.cache *.toc *.out 

