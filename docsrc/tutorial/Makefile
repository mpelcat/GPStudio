include ../../gpstudio.mk

TUTORIALS_PATH = $(sort $(dir $(wildcard */Makefile)))
TUTORIALS = $(patsubst %/,%,$(TUTORIALS_PATH))

all: $(addsuffix -build, $(TUTORIALS))

clean: $(addsuffix -clean, $(TUTORIALS))

%-clean: FORCE
	@echo "$(GREEN)cleaning tutorial $* ...$(RESET)"
	cd $*/ && make clean -f Makefile

%-build: FORCE
	@echo "$(GREEN)building tutorial $* ...$(RESET)"
	cd $*/ && make -f Makefile

FORCE:
