#!/bin/bash

set -eu

# Usage
usage_exit() {
  echo "USAGE: $0"
}

# Copy or Concatenate
arrange_file() {
  src=$1
  dst=$2

  if ! [ -e $src ]; then
    echo "Source file not exist, $src"
    exit 1
  fi

  if [ -f $dst ]; then
    if [ -f $src ]; then
      # Add config to existing file.
      cat $src >> $dst
    elif [ -d $src ]; then
      echo "Can't arrange direcory $src to file $dst"
    else
      echo "Format error $src"
    fi 
  elif [ -d $dst ]; then
    if [ -d $src ]; then
      # Copy directory to directory
      cp -r ${src}/* ${dst}/
    elif [ -f $src ]; then
      echo "Can't arrange file $src to directory $dst"
    else
      echo "Format error $src"
    fi 
  elif ! [ -e $dst ]; then
    cp -r $src $dst
  else
    echo "Format error $dst"
  fi
}

### Check Environment ###
if [ ${0} !=  "./install.sh" ]; then
  echo "Run './instll.sh' in myterm directory'"
  exit 1
fi

while getopts h OPT
do
  case $OPT in
    h)  usage_exit
        ;;
  esac
done


### Deploy Scripts ###
ls ./conf/dots | while read fname; do
  arrange_file "./conf/dots/${fname}" "${HOME}/.${fname}"
done

ls ./conf/undots | while read fname; do
  arrange_file "./conf/undots/${fname}" "${HOME}/${fname}"
done

ls ./bin | while read fname; do
  sudo cp -r "./bin/${fname}" /usr/local/bin/${fname}
  sudo chmod 755 /usr/local/bin/${fname}
done

### Setup for Shell ###

which apt > /dev/null 2>&1 && sudo apt update && sudo apt install zsh command-not-found
which pacman > /dev/null 2>&1 && sudo pacman -Syu & sudo pacman -S vim tmux


### End ###
echo "Intall done."
exit 0
