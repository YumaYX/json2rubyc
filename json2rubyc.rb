# frozen_string_literal: true

require 'json'
require 'securerandom'

def format_data(id, pid, key, value, depth)
  { id: id, pid: pid, key: key, value: value.class, depth: depth }
end

def generate_random_id(data)
  "#{SecureRandom.hex(10)}-#{data.object_id}"
end

def generate(data, _id = 'id', _key = 'key', pid = 'ROOT', depth = 0)
  result = []

  if data.is_a?(Hash)
    data.each do |key, value|
      hash_id = generate_random_id(data)
      result << format_data(hash_id, pid, key, value, depth)
      result << generate(value, hash_id, key, hash_id, depth + 1)
    end
  elsif data.is_a?(Array)
    array_id = generate_random_id(data)
    result << format_data(array_id, pid, nil, data, depth)
    data.each do |element|
      result << generate(element, array_id, element, array_id, depth + 1)
    end
  end
  result.flatten
end

def clean_lists(data)
  mini_data = data.map { |ele| { key: ele[:key], pid: ele[:pid] } }

  hash = {}
  data.each do |ele|
    target_key = ele[:key]
    target_pid = ele[:pid]

    mini_data.shift
    next if mini_data.any? { |mini_ele| mini_ele.eql?({ key: target_key, pid: target_pid }) }

    (hash[target_pid] ||= []) << ele
  end
  hash
end

def indent(num)
  ' ' * 2 * num
end

def convert_j2r(data, top_key = 'ROOT')
  output = ''
  data[top_key].each do |ele|
    id = ele[:id]
    type = ele[:value]
    key = ele[:key]
    depth = ele[:depth]

    if type.eql?(Hash)
      output = "#{indent(depth)}[\"#{key}\"]\n"
      output += convert_j2r(data, id) if data.keys.include?(id)
    elsif type.eql?(Array)
      if key.nil?
        output += convert_j2r(data, id) if data.keys.include?(id)
      else
        output = "#{output}#{indent(depth)}[\"#{key}\"].each do |element|\n"
        output += "#{indent(depth + 1)}puts element\n"
        output += convert_j2r(data, id) if data.keys.include?(id)
        output += "#{indent(depth)}end\n"
      end
    else
      output = "#{output}#{indent(depth)}[\"#{key}\"] # (#{type})\n"
    end
  end
  output
end

def process_json(json_filename)
  data = JSON.parse(File.read(json_filename))
  converted_data = convert_data(data)
  display_result(data, converted_data)
end

def convert_data(data)
  processed_data = generate(data)
  cleaned_data = clean_lists(processed_data)
  convert_j2r(cleaned_data)
end

def display_result(original_data, converted_data)
  puts "# Original Data Length: #{original_data.length}"
  puts "# Original Data Class: #{original_data.class}"
  puts converted_data
end

if __FILE__ == $PROGRAM_NAME
  json_filename = ARGV[0]
  process_json(json_filename)
end
