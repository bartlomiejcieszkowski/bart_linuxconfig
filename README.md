# bart_linuxconfig

Basic setup is:

move:
mv .* ~/
(make a backup if you have some own config)
.tmux.conf is a must, and .bash_aliases to get 256color tmux session


go to install_scripts
./bart_basics.sh
this downloads theme for vim, sets color, and creates (if not present) tmux conf

./prepare_vim.sh
this will install vundle and basic plugins for vim
also it will add YouCompleteMe plugin and compile it
