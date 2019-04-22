#!/bin/bash

WORKING_DIR=`pwd`
SCRIPT_DIR=`basename "$0"`

type curl &> /dev/null
if [ $? -ne 0 ]; then
	sudo apt-get install -y curl
fi

type python &> /dev/null
if [ $? -ne 0 ]; then
	sudo apt-get install -y python
fi

cd ${SCRIPT_DIR}

#pathogen apt-vim
#./install_apt-vim.sh

#source ~/.bashrc || source ~/.bash_profile

#apt-vim install -y https://github.com/scrooloose/nerdtree.git


git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

echo "set nocompatible" >> ~/.vimrc
echo "filetype off" >> ~/.vimrc
echo "set rtp+=~/.vim/bundle/Vundle.vim" >> ~/.vimrc
echo "call vundle#begin()" >> ~/.vimrc
echo "\" PLUGINS_BEGIN" >> ~/.vimrc

echo "Plugin 'https://github.com/scrooloose/nerdtree.git'" >> ~/.vimrc
echo "Plugin 'https://github.com/Valloric/YouCompleteMe.git'" >> ~/.vimrc
echo "\" PLUGINS_END" >> ~/.vimrc
echo "call vundle#end()" >> ~/.vimrc
echo "filetype plugin indent on" >> ~/.vimrc
#echo "filetype plugin on" >> ~/.vimrc

vim +PluginInstall +qall

echo "finishing setup of YouCompleteMe plugin"
sudo apt-get install -y build-essential cmake python3-dev clang-tools

cd ~/.vim/bundle/YouCompleteMe
python3 install.py --clangd-completer --clang-completer

