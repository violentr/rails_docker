#!/usr/bin/env bash

diff="$(git diff Gemfile | wc -w)"
echo "value of diff: $diff"

if (($diff > 0))
then
  echo "installing dependencies: Ruby gems"
  bundle install
else
  echo "No new ruby gems needs to installed"
fi
