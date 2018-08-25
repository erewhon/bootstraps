#!/bin/bash
#
# debian and ubuntu
#
echo "Installing packages"

sudo apt install \
        ack \
        autossh \
        expect \
        git-svn \
        golang \
        htop \
        jq \
        mc \
        mosh \
        net-tools \
        rlwrap \
	tmux -y

#     git-p4 \
#     the_silver_searcher \

sudo apt install -y \
     cowsay \
     fortune-mod \
     git \
     glances \
     httpie \
     lolcat \
     neofetch \
     netcat \
     zsh

# todo:
# - pygments
# - node
#   - lolcatjs
#   - vtop
#   - yarn
# - emacs from source
# - rustup, cargo
# - ocaml
# - alacritty

chsh --shell /usr/bin/zsh $(whoami)

wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k || true

# Set up config files (based on
# https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/)

alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

git clone --bare git@github.com:erewhon/dotfiles.git $HOME/.cfg
   
mkdir -p .config-backup && \
    config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
    xargs -I{} mv {} .config-backup/{}

config checkout

# Local binaries

echo "Setting up NodeJS"

sudo apt install gcc g++ make -y

# mkdir -p ~/.local/node 
# tar xJvf ~/Downloads/node-v10.9.0-linux-x64.tar.xz -C ~/.local/node
# ln -sv ~/.local/node/node-v10.9.0-linux-x64 ~/.local/node/current
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get install -y nodejs


echo "installing yarn"
## To install the Yarn package manager, run:
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get install yarn -y




echo "Installing Emacs"

# libtiff4-dev libungif4-dev libxtrap-dev   x-dev xlibs-static-dev

sudo apt install -y \
     libc6-dev libjpeg62-dev libncurses5-dev \
     libpng-dev  xaw3dg-dev zlib1g-dev \
     libice-dev libsm-dev libx11-dev libxext-dev libxi-dev libxmu-dev \
     libxmuu-dev libxpm-dev libxrandr-dev libxt-dev  \
     libxtst-dev libxv-dev

sudo apt install -y stow autoconf giflib-tools libtiff-tools \
     libgnutls30 libgnutls28-dev mailutils \
     curl


mkdir -p ~/src && cd ~/src

git clone git://git.savannah.gnu.org/emacs.git

sudo mkdir -p /usr/local/stow && sudo chown erewhon /usr/local/stow

cd emacs
./autogen.sh
./configure --without-makeinfo --with-gif=no --with-tiff=no
make
make install prefix=/usr/local/stow/emacs
cd /usr/local/stow
stow emacs

###
### Rust
###
echo "Installing Rust"

curl https://sh.rustup.rs -sSf | sh

###
### Alacritty
###
echo "Installing Alacritty"

sudo apt install -y cmake \
     libfreetype6-dev \
     libfontconfig1-dev \
     xclip

cd ~/src

git clone https://github.com/jwilm/alacritty.git
cd alacritty
cargo install cargo-deb
cargo deb --install

###
### OCaml
###
echo "Installing OCAML"

sudo apt install ocaml opam

###
### Nerd fonts
###
cd ~/src

git clone --depth 1 git@github.com:ryanoasis/nerd-fonts.git

cd nerd-fonts
./install.sh Meslo
./install.sh FiraCode

###
### OpenSSH
###
sudo apt install libssl-dev
cd ~/src
wget https://cloudflare.cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-7.7p1.tar.gz
cd openssh-7.7p1

./configure 
make 
make install prefix=/usr/local/stow/openssh
cd /usr/local/stow
sudo stow openssh

###
### tmux
###
sudo apt install -y libevent-dev

cd ~/src
# or download and extract
git clone https://github.com/tmux/tmux.git
cd tmux
sh autogen.sh
./configure
make
make install prefix=/usr/local/stow/tmux
cd /usr/local/stow
sudo stow tmux
