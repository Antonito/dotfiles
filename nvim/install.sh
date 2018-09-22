#!/usr/bin/env bash

mkdir -p $HOME/.config/nvim/config/
mkdir -p $HOME/.config/nvim/plugged/

cp init.vim $HOME/.config/nvim/init.vim
cp -r config/ $HOME/.config/nvim/config/

nvim -E -c PlugInstall -c qa!
nvim -E -c UpdateRemotePlugins -c qa!
