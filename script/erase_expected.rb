require_relative "../config/environment"
require "json"
require "fileutils"

BASE_DIR = Rails.root.join("spec/fixtures/files/emails")
SUFFIX = ".expected.json"

old = Dir[BASE_DIR.join("**/*#{SUFFIX}")]
if old.any?
  old.each { |f| FileUtils.rm_f(f) }
end

puts "\nAll #{SUFFIX} files have been deleted!"
