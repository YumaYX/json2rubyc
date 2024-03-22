# frozen_string_literal: true

require 'minitest/autorun'
require 'json'

require_relative '../lib/json2rubyc'

class TestTemplate < Minitest::Test
  def setup; end

  def teardown; end

  def extract_json_file(json_filename)
    content = File.read(json_filename)
    JSON.parse(content)
  end

  def test_gen
    json_input_dir = 'test/input'
    json_input_files = Dir.glob("#{json_input_dir}/*.json")

    json_input_files.each do |json_file|
      expect_file = json_file.gsub(/.json$/, '.txt')

      json_data = extract_json_file(json_file)
      output_content = convert_data(json_data)

      assert_equal(File.read(expect_file), output_content)
    end
  end
end
