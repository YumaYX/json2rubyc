#!/bin/sh

sed_command='sed'
if [ $(which gsed) ]; then
  sed_command='gsed'
fi

${sed_command} -n '1,/^## Sample$/p' README.md > temp

cmd="ruby app.rb test/input/sample_hash.json"
echo >> temp
echo '```json' >> temp
cat test/input/sample_hash.json >> temp
echo '```' >> temp
echo >> temp
echo '```ruby' >> temp
${cmd} >> temp
echo '```' >> temp

cmd="ruby app.rb test/input/sample_array.json"
echo >> temp
echo '```json' >> temp
cat test/input/sample_array.json >> temp
echo '```' >> temp
echo >> temp
echo '```ruby' >> temp
${cmd} >> temp
echo '```' >> temp

mv temp README.md
