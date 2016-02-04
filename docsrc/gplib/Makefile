MAINDOC=gplib

LC=pdflatex
LFLAGS=-interaction=nonstopmode

HTMLC=htlatex
HTMLFLAGS= "" "" "" "--interaction=nonstopmode"

all: pdf

pdf: $(MAINDOC).pdf

html: $(MAINDOC).html

$(MAINDOC).pdf: $(MAINDOC).tex ../../version.txt ../gpstudio_doc.tex
	$(LC) $(LFLAGS) $(MAINDOC).tex > /dev/null
	cp $(MAINDOC).pdf ../../doc/

$(MAINDOC).html: $(MAINDOC).tex ../../version.txt ../gpstudio_doc.tex
	$(HTMLC) $(MAINDOC).tex > /dev/null
	cp $(MAINDOC).html $(MAINDOC).css ../../doc/

clean:
	rm -rf *.log *.aux *.synctex.gz $(MAINDOC).pdf *.4ct *.4tc *.dvi *.html *.css *.idv *.lg *.log *.tmp *.xref *.man *.cfg *.xml *-fig*.tex *-fig*.dot *.cache *.out

