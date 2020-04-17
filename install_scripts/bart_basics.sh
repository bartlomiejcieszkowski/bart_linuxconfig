#!/bin/bash
#set -x

STEP_NAME="[vim]"
if command -v vim >/dev/null 2>&1 ; then
	echo "${STEP_NAME}[OK] vim is installed"
else
	echo "${STEP_NAME}[FAIL] vim is not installed"
	sudo apt-get install vim || exit 1
fi

echo "${STEP_NAME}Customizing vim"
if [ ! -d ~/.vim/colors ]; then
	mkdir -p ~/.vim/colors
fi

if [ ! -f ~/.vim/colors/monokai.vim ]; then
	echo "${STEP_NAME}Getting monokai theme"
	wget -O ~/.vim/colors/monokai.vim https://raw.githubusercontent.com/sickill/vim-monokai/master/colors/monokai.vim
fi

if [ ! -f ~/.vim/colors/material-monokai.vim ]; then
	echo "${STEP_NAME}Getting material-monokai theme"
	wget -O ~/.vim/colors/material-monokai.vim https://raw.githubusercontent.com/skielbasa/vim-material-monokai/master/colors/material-monokai.vim
fi

touch ~/.vimrc
if ! grep -F "syntax" ~/.vimrc; then
	echo "${STEP_NAME}Enabling syntax highlighting"
	echo "syntax enable" >> ~/.vimrc
fi

#if ! grep -Fx "colorscheme monokai" ~/.vimrc; then
#	echo "colorscheme monokai" >> ~/.vimrc
#fi

#if ! grep -Fx "set background=dark" ~/.vimrc; then
#	echo "set background=dark" >> ~/.vimrc
#fi

#if ! grep -Fx "set termguicolors" ~/.vimrc; then
#	echo "set termguicolors" >> ~/.vimrc
#fi

if ! grep -Fx "colorscheme material-monokai" ~/.vimrc; then
	echo "${STEP_NAME}Setting colorscheme to material-monokai"
	echo "colorscheme material-monokai" >> ~/.vimrc
fi

STEP_NAME="[tmux]"
if command -v tmux >/dev/null 2>&1 ; then
	echo "${STEP_NAME}[OK] tmux is installed"
else
	echo "${STEP_NAME}[FAIL] tmux is not installed"
	sudo apt-get install tmux || exit 1
fi

if [ ! -f ~/.tmux.conf ]; then
	echo "${STEP_NAME}settings some sane defaults in tmux"
	echo 'set -g default-terminal "tmux-256color"' > ~/.tmux.conf
	echo 'bind r source-file ~/.tmux.conf' >> ~/.tmux.conf
	echo '# switch panes using Alt-arrow without prefix' >> ~/.tmux.conf
	echo 'bind -n M-Left select-pane -L' >> ~/.tmux.conf
	echo 'bind -n M-Right select-pane -R' >> ~/.tmux.conf
	echo 'bind -n M-Up select-pane -U' >> ~/.tmux.conf
	echo 'bind -n M-Down select-pane -D' >> ~/.tmux.conf
	echo '# Enable mouse mode (tmux 2.1 and above)' >> ~/.tmux.conf
	echo '#set -g mouse on' >> ~/.tmux.conf
else
	echo "${STEP_NAME}tmux.conf already exists, skipping"
fi
