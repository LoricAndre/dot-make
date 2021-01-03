build_template: DIR = $(DOTFILES)/template
build_template: FILE = config
build_template: parse_template

link_template: build_template
	ln $(LN_FLAGS) $(DOTFILES)/template/parsed/config $(HOME)/.config/template
