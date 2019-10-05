#!/usr/bin/env bash

function install_dependency(){
  if [ -f $file ]
  then
    dependency="$(git diff $file | wc -w)"
    if (($dependency > 0 ))
    then
      echo -e "[+] Installing Dependencies: '$cmd'"
      $cmd
    else
      echo -e "[-]  No need to run : $cmd"
    fi
  else
    echo -e "[-] File $file does not exist"
  fi
}
cmd="bundle install"
file="Gemfile"
install_dependency

cmd="yarn install"
file="yarn.lock"
install_dependency
