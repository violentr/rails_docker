#!/usr/bin/env bash

function install_dependency(){
  if [ -f $file ]
  then
    dependency="$(git diff $file | wc -w)"
    if ([ $dependency -gt 0 ] && echo "[+] Installing Dependencies: $cmd ");
    then
      bash -c $cmd
    fi
  fi
}
cmd="bundle install"
file="Gemfile"
install_dependency

cmd="yarn install"
file="yarn.lock"
install_dependency
