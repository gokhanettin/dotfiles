# Dotfiles

My dotfiles.

## Vim & Neovim

I use [neovim](https://github.com/neovim/neovim/wiki/Installing-Neovim) most of
the time, but vim should also work with my configuration.

## Install dependecies

Instal setup and plugin dependecies.

```bash
$ sudo apt-get install git curl cmake silversearcher-ag xsel python-dev \
    python-pip python3-dev python3-pip zathura xdotool
$ pip install neovim
$ pip3 install neovim
```

Install powerline fonts.

```bash
$ git clone --depth 1 https://github.com/powerline/fonts.git /tmp/fonts
$ /tmp/fonts/install.sh
```

If you are using a terminal emulator you may want to create a new profile with
your favorite powerline font.

## Setup

```bash
$ git clone https://github.com/gokhanettin/dotfiles.git ~/.dotfiles
$ cd ~/.dotfiles
$ bash setup.sh --all
```

Here are all the possible options:

```bash
$ bash setup.sh -h
Usage: setup.sh [OPTIONS]

OPTIONS
   -h, --help           Print this help message
   --git                Setup git
   --vim                Setup vim
   --all                Setup all
   --refresh            Refresh all links
   --rm                 Remove all links
```

## C/C++ Notes

[ycm_extra_conf.py](./nvim/ycm_extra_conf.py) feeds various compilation flags
to [YouCompleteMe](https://github.com/Valloric/YouCompleteMe). It is capable of
parsing the nearest `.clang_complete`  file to the current compilation unit
(i.e. a source file such as *.c, *.cpp). It can also retrieve compilation flags
from a [compilation
database](http://clang.llvm.org/docs/JSONCompilationDatabase.html). You can get
CMake to generate this database by adding `set(CMAKE_EXPORT_COMPILE_COMMANDS
ON)` to your `CMakeLists.txt` file.

Here is how you can dump default include directories given in
[clang_complete](./nvim/clang_complete).

```bash
$ # For C
$ g++ -E -xc - -v < /dev/null
$ clang++ -E -xc - -v < /dev/null
$ # For C++
$ g++ -E -xc++ - -v < /dev/null
$ clang++ -E -xc++ - -v < /dev/null
```
