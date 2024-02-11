#!/bin/sh

# Clone home from github into ~ then execute this script to setup up links

cd ~
ln -sf home/.gitconfig ./
ln -sf home/.bashrc ./
ln -sf home/.profile ./
ln -sf home/.bash_aliases ./
