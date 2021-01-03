.ONESHELL:
# DOTFILES is you dotfiles directory.
DOTFILES = $(HOME)/dotfiles
# _INCL is the name of all the dependencies (the directories in your dotfiles root)
_INCL = bin misc deps

# Set ln flags as -sf, meaning softlinks and force (alternaatively, you can use -si for a prompt before overwriting)
ifndef LN_FLAGS
  LN_FLAGS = -sf
endif

PARTS = $(patsubst %, %/Makefile, $(_INCL))
LINKS = $(patsubst %, link_%, $(_INCL))

.DEFAULT_GOAL = dotfiles

# VAR_FILE should be a file with a list of variable definitions. These will then be used for parsing.
ifndef VAR_FILE
  VAR_FILE = $(DOTFILES)/deps/vars.sh
endif

# The parse target, this essentially replaces all occurences of `%{{var}}` by the value of `var` in FILE of DIR
parse_%:
	@set -a
	@. $(VAR_FILE)
	@set +a
	@perl -p -e 's/%\{\{(\w+)\}\}/(exists $$ENV{$$1}?$$ENV{$$1}:"missing variable $$1")/eg' \
	  < $(DIR)/$(FILE) > $(DIR)/parsed/$(FILE)
	@echo "$@ done"


# This will include all level-2 makefiles
include $(PARTS)

# Default target, builds and links all dependencies
dotfiles: $(LINKS)
