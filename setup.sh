#!/bin/bash
# Simple setup.sh for configuring Ubuntu 12.04 LTS EC2 instance
# for headless setup. 

# Install nvm: node-version manager
# https://github.com/creationix/nvm
sudo apt-get install -y git-core
curl https://raw.github.com/creationix/nvm/master/install.sh | sh

# Load nvm and install latest production node
source $HOME/.nvm/nvm.sh
nvm install v0.10.12
nvm use v0.10.12

# Install jshint to allow checking of JS code within emacs
# http://jshint.com/
npm install -g jshint

# Install rlwrap to provide libreadline features with node
# See: http://nodejs.org/api/repl.html#repl_repl
sudo apt-get install -y rlwrap

# Install emacs24
# https://launchpad.net/~cassou/+archive/emacs
sudo apt-add-repository -y ppa:cassou/emacs
sudo apt-get update
sudo apt-get install -y emacs24 emacs24-el emacs24-common-non-dfsg

# Install tmux.
sudo apt-get install -y tmux

# git pull and install dotfiles as well
cd $HOME
if [ -d ./dotfiles/ ]; then
    mv dotfiles dotfiles.old
fi
if [ -d .emacs.d/ ]; then
    mv .emacs.d .emacs.d~
fi
git clone https://github.com/vakaras/ec2-dotfiles.git dotfiles
ln -sb dotfiles/.tmux.conf .
ln -sb dotfiles/.bash_profile .
ln -sb dotfiles/.bashrc .
ln -sb dotfiles/.bashrc_custom .
ln -sb dotfiles/.vimrc
#ln -sf dotfiles/.emacs.d .

# Install heroku.
wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh

# Set up heroku
heroku login
ssh-keygen -t rsa
heroku keys:add

# Init bitstarter project.
git clone https://github.com/vakaras/bitstarter.git
cd bitstarter
heroku create
git push heroku master

# Set up git.
git config --global user.name "Vytautas Astrauskas"
git config --global user.email vastrauskas@gmail.com
