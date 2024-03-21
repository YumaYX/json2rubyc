#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'

json_data = JSON.parse(File.read('./sample/sample_json_1.json'))

p json_data['user']['address']['street']

json_data["items"].each do |element|
  puts element
    ["id"] # (Integer)
    ["name"] # (String)
    ["quantity"] # (Integer)
    ["price"] # (Float)
end
