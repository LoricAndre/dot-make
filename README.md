# Dot-Make

dot-make is a minimailstic dotfiles management tool using makefiles.

# Dependencies :
 - Make
 - Perl

# Configuration & structure :
 - The root Makefile should mostly be left untouched, apart from some variables:
  - `DOTFILES` is your dotfiles dir.
  - `_DEPS` is a list of your dependencies.
  - `LN_FLAGS` is the options used when linking files. By default, this is set to `-sf`,
  - `VAR_FILE` is a shell file defining the variables used when parsing.
  meaning it forcefullty creates softlinks. For a safer alternative, use `-si` for a prompt before overwriting files.
 - Each dependency is represented by either a directory or a file in `misc/`.
 - Each directory contains a level-2 Makefile, defining :
  - The `link_xxxx` target, linking the files at the right place. This one should look like this :
  ```make
  link_xxxx:
    ln $(LN_FLAGS) $(DOTFILES)/xxxx/config $(HOME)/.config/xxxx/
  ```
  - (Optional) The `build_xxxx` target. This target should be called by `link_xxxx`. The syntax is as follows :
  ```make
  build_xxxx: DIR = $(DOTFILES)/xxxx
  build_xxxx: FILE = config
  build_xxxx: parse_xxxx
  ```
  - If using `build_xxxx`, the `link_xxxx` target should resemble this :
  ```make
  link_xxxx: build_xxxx
          ln $(LN_FLAGS) $(DOTFILES)/xxxx/parsed/config $(HOME)/.config/xxxx
  ```

# Parsing :
dot-make supports parsing of config files, via the `build_xxxx` target (calling `parse_xxxx`).
This is done using perl, replacing all occurences of `%{{var}}` by the value of `var`.
`var` can be either an environment variable or a variable defined in `VAR_FILE`.
If you want a file to be parsed, you need :
 - To create the according target,
 - To create a `parsed` directory in the directory designated by the `DIR` variable of the target.

# Usage :
Simply call `make` to build and link your config files.

# TODO :
 - Add install target
 - Add backup target
 - Add command to automatically create Makefile based on existing config file
