stow = stow -t "${HOME}"
# We ignore SC1071 since it is just a warning about not supporting zsh.
# Zsh features aren't really used, so it's not a big problem
shell_linter = shellcheck -e SC1071

install:
	${stow} bash
	${stow} zsh
	${stow} git
	${stow} emacs
	${stow} mbsync
	${stow} neomutt
	${stow} ssh
	${stow} sway
	${stow} termite
	${stow} tmux
	${stow} syncthing
	${stow} mpd
	${stow} ncmpcpp

lint: lint_zsh lint_bash lint_sh

# Lint every shellscript I have here
lint_sh:
	find . -type f -regex '*.sh' -exec ${shell_linter} {} +

# Lint everything that belongs to bash
lint_bash:
	${shell_linter} bash/.bashrc

# Lint everything that belongs to zsh
lint_zsh:
	${shell_linter} zsh/.zshrc
	${shell_linter} zsh/.zsh/aliases.zsh
