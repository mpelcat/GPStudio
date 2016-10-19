GREEN := $(shell tput setaf 2)
RESET := $(shell tput sgr0)

all: docip

IPSPATH=$(dir $(wildcard process/*/*.proc))
IPSTEXFILE=$(wildcard $(addsuffix doc/*.tex,$(IPSPATH)))
IPSPDFFILE=$(IPSTEXFILE:.tex=.pdf)

LC=pdflatex
LFLAGS=-interaction=nonstopmode

docip: $(IPSPDFFILE)

%.pdf : %.tex
	@echo
	@echo "$(GREEN)building doc $* ...$(RESET)"
	@cd $(dir $<) && $(LC) $(LFLAGS) $(notdir $<) > /dev/null
	@echo "$(GREEN)done.$(RESET)"
