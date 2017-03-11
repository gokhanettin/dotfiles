# Dotfiles

My dotfiles.

## Neovim

I use [Linuxbrew][1] to install the latest [neovim][2]. I run the follow
commands to start using Linuxbrew on my Ubuntu machine.

```bash
echo 'export PATH="$HOME/.linuxbrew/bin:$PATH"' >> ~/.profile
source ~/.profile
```

We also need python interfaces for various plugins.

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
sudo apt-get install clang silversearcher-ag
```

## Setup

```bash
git clone https://github.com/gokhanettin/dotfiles.git ~/.dotfiles
make clean # Clean all old setups
make vim # Vim setup only
make git # Git setup only
make     # Setup all
```

[1]: http://linuxbrew.sh
[2]: https://github.com/neovim/neovim/wiki/Installing-Neovim
