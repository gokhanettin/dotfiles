#!/bin/bash

usage() {
  echo "Usage: `basename $0` [OPTIONS]"
  echo
  echo "OPTIONS"
  echo "   -h, --help           Print this help message"
  echo "   --git                Setup git"
  echo "   --vim                Setup vim"
  echo "   --all                Setup all"
  echo "   --refresh            Refresh all links"
  echo "   --rm                 Remove all links"
}

setup_git() {
  rm -f $HOME/.gitconfig && ln -sv $PWD/gitconfig $HOME/.gitconfig
}

setup_vim() {
  rm -rf $HOME/.vim && ln -sv $PWD/nvim $HOME/.vim
  rm -f $HOME/.vimrc && ln -sv $PWD/nvim/init.vim $HOME/.vimrc
  rm -rf $HOME/.config/nvim && ln -sv $PWD/nvim $HOME/.config/nvim
  rm -f $HOME/.clang_complete && ln -sv $PWD/nvim/clang_complete $HOME/.clang_complete
  curl --insecure -fLo $PWD/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  vim +PlugInstall +qall
}

refresh() {
  remove
  test -e $HOME/.gitconfig || ln -sv $PWD/gitconfig $HOME/.gitconfig
  test -e $HOME/.vim || ln -sv $PWD/nvim $HOME/.vim
  test -e $HOME/.vimrc || ln -sv $PWD/nvim/init.vim $HOME/.vimrc
  test -e $HOME/.config/nvim ||  ln -sv $PWD/nvim $HOME/.config/nvim
  test -e $HOME/.clang_complete || ln -sv $PWD/nvim/clang_complete $HOME/.clang_complete
}

remove() {
  test -L $HOME/.gitconfig && rm -fv $HOME/.gitconfig
  test -L $HOME/.config/nvim && rm -rfv $HOME/.config/nvim
  test -L $HOME/.vim && rm -rfv $HOME/.vim
  test -L $HOME/.vimrc && rm -fv $HOME/.vimrc
  test -L $HOME/.clang_complete && rm -fv $HOME/.clang_complete
}

main() {
  if [ $# -eq 0 ]; then
    echo "No option given"
    usage
    exit 1
  fi

  while [ $# -gt 0 ]; do
    opt=$1
    case $opt in
      --git)
        want_git=yes
        ;;
      --vim)
        want_vim=yes
        ;;
      --all)
        want_git=yes
        want_vim=yes
        ;;
      --refresh)
        will_refresh=yes
        ;;
      --rm)
        will_remove=yes
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        echo "Unknown option: $opt"
        usage
        exit 1
        ;;
    esac
    shift
  done

  if [ ! -z $will_remove ]; then
    remove
  fi

  if [ ! -z $want_git ]; then
    setup_git
  fi

  if [ ! -z $want_vim ]; then
    setup_vim
  fi

  if [ ! -z $will_refresh ]; then
    refresh
  fi
}

main $@
