#!/bin/sh

for fs in $(ls -1 sample/*.json)
do
  cmd="ruby json2rubyc.rb ${fs}"
  echo === ${cmd} ===
  ${cmd}
  echo
  sleep 0.5
done
