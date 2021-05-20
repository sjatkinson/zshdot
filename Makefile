all : ${HOME}/.zshenv ./.zprofile ./.zshrc
.PHONY: all

${HOME}/.zshenv: zshenv
	ln -s zshenv ${HOME}/.zshenv

./.zprofile: zprofile
	ln -s zprofile .zprofile

./.zshrc: zshrc
	ln -s zshrc .zshrc
