# Dotfiles

My dotfiles.

## Neovim

Having installed [neovim][1], we need python interfaces for various vim
plugins.

```bash
sudo apt-get install python-pip # Install pip2
pip2 install neovim
pip2 install --upgrade neovim # Upgrade with this if you need to

sudo apt-get install python3-pip # Install pip3
pip3 install neovim
pip3 install --upgrade neovim # Upgrade with this if you need to
```

## Fonts

I use `DejaVu Sans Mono for Powerline`. You first have to install poweline fonts
as follows:

```bash
git clone --depth 1 https://github.com/powerline/fonts.git /tmp/fonts
/tmp/fonts/install.sh
```

If you are using a terminal, don't forget to create a new terminal profile with
a powerline font you like.

## Other Dependencies

Other dependencies for various plugins.

```bash
sudo apt-get install clang silversearcher-ag xsel
```

## Setup

```bash
git clone https://github.com/gokhanettin/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
make clean # Clean up all old setups
make vim # Vim setup only
make git # Git setup only
make     # Setup all
```

[1]: https://github.com/neovim/neovim/wiki/Installing-Neovim
