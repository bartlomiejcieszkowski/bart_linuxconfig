#!/bin/bash
set -x

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install tmux
sudo apt-get install vim

echo "Customizing vim"
if [ ! -d ~/.vim/colors ]; then
	mkdir -p ~/.vim/colors
fi

if [ ! -f ~/.vim/colors/monokai.vim ]; then
	echo "Getting monokai theme"
	wget -O ~/.vim/colors/monokai.vim https://raw.githubusercontent.com/sickill/vim-monokai/master/colors/monokai.vim
fi

if [ ! -f ~/.vim/colors/material-monokai.vim ]; then
	echo "Getting material-monokai theme"
	wget -O ~/.vim/colors/material-monokai.vim https://raw.githubusercontent.com/skielbasa/vim-material-monokai/master/colors/material-monokai.vim
fi

touch ~/.vimrc
if ! grep -F "syntax" ~/.vimrc; then
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
	echo "colorscheme material-monokai" >> ~/.vimrc
fi

if [ ! -f ~/.tmux.conf ]; then
	echo 'set -g default-terminal "tmux-256color"' > ~/.tmux.conf
	echo 'bind r source-file ~/.tmux.conf' >> ~/.tmux.conf
	echo '# switch panes using Alt-arrow without prefix' >> ~/.tmux.conf
	echo 'bind -n M-Left select-pane -L' >> ~/.tmux.conf
	echo 'bind -n M-Right select-pane -R' >> ~/.tmux.conf
	echo 'bind -n M-Up select-pane -U' >> ~/.tmux.conf
	echo 'bind -n M-Down select-pane -D' >> ~/.tmux.conf
	echo '# Enable mouse mode (tmux 2.1 and above)' >> ~/.tmux.conf
	echo '#set -g mouse on' >> ~/.tmux.conf
fi
