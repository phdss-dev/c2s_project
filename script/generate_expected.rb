require_relative "../config/environment"
require "json"

BASE_DIR = Rails.root.join("spec/fixtures/files/emails")
SUFFIX = ".expected.json"

def generate_for(eml_path)
  raw = File.read(eml_path)
  mail = Mail.read_from_string(raw)

  parser_class = Parsers::ParserRegistry.find_for(mail)
  return nil unless parser_class

  parser = parser_class.new(mail)
  parser.parse
end

Dir[BASE_DIR.join("**/*.eml")].each do |eml_path|
  next if eml_path.end_with?(".json")

  data = generate_for(eml_path)

  unless data
    next
  end

  expected_path = eml_path.sub(/\.eml$/, SUFFIX)

  unless File.exist?(expected_path)
    File.write(expected_path, JSON.pretty_generate(data))
  end
end

puts "\nAll #{SUFFIX} files have been generated!"
