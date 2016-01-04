MAINDOC=manual

LC=pdflatex
LFLAGS=-interaction=nonstopmode

HTMLC=htlatex
HTMLFLAGS= "" "" "" "--interaction=nonstopmode"

SRC= $(wildcard *.tex)

all: pdf

pdf: $(MAINDOC).pdf

html: $(MAINDOC).html

$(MAINDOC).toc: $(SRC) wave.pdf ../../version.txt ../gpstudio_doc.tex
	$(LC) $(LFLAGS) $(MAINDOC).tex > /dev/null

$(MAINDOC).pdf: $(SRC) $(MAINDOC).toc ../../version.txt ../gpstudio_doc.tex
	$(LC) $(LFLAGS) $(MAINDOC).tex > /dev/null
	cp $(MAINDOC).pdf ../../doc/

$(MAINDOC).html: $(SRC) ../../version.txt ../gpstudio_doc.tex
	$(HTMLC) $(MAINDOC).tex $(HTMLFLAGS) > /dev/null
	cp $(MAINDOC).html $(MAINDOC).css ../../doc/

clean:
	rm -rf *.log *.aux *.synctex.gz $(MAINDOC).pdf *.4ct *.4tc *.dvi *.html *.css *.idv *.lg *.log *.tmp *.xref *.man *.cfg *.xml *-fig*.tex *-fig*.dot *.cache *.toc *.out 

