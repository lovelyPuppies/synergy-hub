##### ⚙️ from /opt/nanopb/extra/nanopb.mk
CC := clang
# This is an include file for Makefiles. It provides rules for building
# .pb.c and .pb.h files out of .proto, as well the path to nanopb core.


# Path to the nanopb root directory
# NANOPB_DIR := $(patsubst %/,%,$(dir $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))))
NANOPB_DIR := /opt/nanopb
NANOPB_INCLUDE_DIR := $(NANOPB_DIR)/include

# Files for the nanopb core
NANOPB_CORE = $(NANOPB_INCLUDE_DIR)/pb_encode.c $(NANOPB_INCLUDE_DIR)/pb_decode.c $(NANOPB_INCLUDE_DIR)/pb_common.c


# Check whether to use binary version of nanopb_generator or the
# system-supplied python interpreter.
PROTOC := nanopb_generator


## ❔ Is it required?
# CALLER_DIR := $(dir $(abspath  $(word $(shell echo $$(($(words $(MAKEFILE_LIST)) - 1))), $(MAKEFILE_LIST))))
# PROTOC_OPTS := $(CALLER_DIR)
# --options-path=$(PROTOC_OPTS)

# Rule for building .pb.c and .pb.h
%.pb.c %.pb.h: %.proto %.options
	@echo $(CALLER_DIR)
	$(PROTOC) --output-dir=. $<

%.pb.c %.pb.h: %.proto
	@echo $(CALLER_DIR)
	$(PROTOC) --output-dir=. $<

