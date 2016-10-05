GREEN := $(shell tput setaf 2)
RESET := $(shell tput sgr0)

TUTORIALS_PATH = $(sort $(dir $(wildcard */Makefile)))
TUTORIALS = $(patsubst %/,%,$(TUTORIALS_PATH))

all: $(addsuffix -build, $(TUTORIALS))

clean: $(addsuffix -clean, $(TUTORIALS))

%-clean: FORCE
	@echo
	@echo "$(GREEN)cleaning tutorial $* ...$(RESET)"
	cd $*/ && make clean -f Makefile

%-build: FORCE
	@echo
	@echo "$(GREEN)building tutorial $* ...$(RESET)"
	cd $*/ && make -f Makefile

FORCE:
