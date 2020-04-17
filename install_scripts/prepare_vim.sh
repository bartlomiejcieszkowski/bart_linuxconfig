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


#git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
# version with shallow clone
git clone --depth 1 https://github.com/bartlomiejcieszkowski/Vundle.vim.git ~/.vim/bundle/Vundle.vim

if ! grep -Fx "call vundle#begin()" ~/.vimrc; then
	echo "set nocompatible" >> ~/.vimrc
	echo "filetype off" >> ~/.vimrc
	echo "set rtp+=~/.vim/bundle/Vundle.vim" >> ~/.vimrc
	echo "call vundle#begin()" >> ~/.vimrc
	echo "\" PLUGINS_BEGIN" >> ~/.vimrc
	echo "Plugin 'https://github.com/bartlomiejcieszkowski/Vundle.vim.git'" >> ~/.vimrc
	echo "Plugin 'https://github.com/scrooloose/nerdtree.git'" >> ~/.vimrc
	echo "Plugin 'https://github.com/Valloric/YouCompleteMe.git'" >> ~/.vimrc
	echo "\" PLUGINS_END" >> ~/.vimrc
	echo "call vundle#end()" >> ~/.vimrc
	echo "filetype plugin indent on" >> ~/.vimrc
else
	echo "vundle is already added to vimrc? are you reruning script?"
fi

vim +PluginInstall +qall

echo "finishing setup of YouCompleteMe plugin"
MISSING_PACKAGES=0
MISSING_PACKAGES_LIST=""
dpkg-query -l build-essential
if [ $? -ne 0 ]; then
	MISSING_PACKAGES=1
	MISSING_PACKAGES_LIST="${MISSING_PACKAGES_LIST} build-essential"
fi

dpkg-query -l cmake
if [ $? -ne 0 ]; then
	type cmake &> /dev/null
	if [ $? -ne 0 ]; then
		MISSING_PACKAGES=1
		MISSING_PACKAGES_LIST="${MISSING_PACKAGES_LIST} cmake"
	else
		echo "cmake is instaled, but not from apt "
	fi
fi

dpkg-query -l python3-dev
if [ $? -ne 0 ]; then
	MISSING_PACKAGES=1
	MISSING_PACKAGES_LIST="${MISSING_PACKAGES_LIST} python3-dev"
fi

dpkg-query -l clang-tools
if [ $? -ne 0 ]; then
	MISSING_PACKAGES=1
	MISSING_PACKAGES_LIST="${MISSING_PACKAGES_LIST} clang-tools"
fi

if [ $MISSING_PACKAGES -ne 0 ]; then
	echo "missing ${MISSING_PACKAGES_LIST} - trying to install"
	sudo apt-get install -y ${MISSING_PACKAGES_LIST}
fi

cd ~/.vim/bundle/YouCompleteMe
python3 install.py --clangd-completer --clang-completer
cd -

echo "Extra config"
if ! grep -Fx "\" BART part2" ~/.vimrc; then
	echo "\" BART part2" >> ~/.vimrc
	echo "set number" >> ~/.vimrc
	echo ":nmap <C-n><C-n> :set invnumber<CR>" >> ~/.vimrc
	echo "autocmd StdinReadPre * let s:std_in=1" >> ~/.vimrc
	echo "autocmd VimEnter * if argc() == 0 && !exists(\"s:std_in\") | NERDTree | endif" >> ~/.vimrc
	echo "autocmd VimEnter * NERDTree" >> ~/.vimrc
	echo "autocmd VimEnter * wincmd p" >> ~/.vimrc
	echo "autocmd BufEnter * if (winnr(\"$\") == 1 && exists(\"b:NERDTree\") && b:NERDTree.isTabTree()) | q | endif" >> ~/.vimrc
	echo "set pastetoggle=<F2>"
	echo "\" BART part2 end"
fi

echo "Done"
