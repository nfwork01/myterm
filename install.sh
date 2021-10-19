#!/bin/bash

set -eu

# Usage
usage_exit() {
  echo "USAGE: $0"
}


### Check Environment ###
if [ ${0} !=  "./install.sh" ]; then
  echo "Run './instll.sh' in mydc directory'"
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
  cp -r "./conf/dots/${fname}" ~/.${fname}
done

ls ./conf/undots | while read fname; do
  cp -r "./conf/undots/${fname}" ~/${fname}
done

ls ./bin | while read fname; do
  sudo cp -r "./bin/${fname}" /usr/local/bin/${fname}
  sudo chmod 755 /usr/local/bin/${fname}
done

### Setup for Shell ###
sudo apt update && sudo apt install zsh command-not-found


### End ###
echo "Intall done."
exit 0
