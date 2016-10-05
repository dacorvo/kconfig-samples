# Override default output directory with OUT=/path/to/output on the command line
OUT ?= ./output

# Create output dir
OUT := $(shell mkdir -p $(OUT) && cd $(OUT) > /dev/null && pwd)

# We have to reference the 'all' rule to make it the default
all:

# Generic rules
all: build
	@echo "Done"

clean:
	rm -rf $(OUT)/built-in.o $(OUT)/src

mrproper:
	rm -rf $(OUT)

build: src
	time $(MAKE) -C .. -f Makefile.build 	\
		DIR=benchmark/src				\
		INC_ROOT=benchmark/src			\
		OUT=$(OUT)
