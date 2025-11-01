require "rails_helper"
require "json"

RSpec.describe "All parsers" do
  emails_dir = Rails.root.join("spec", "fixtures", "files", "emails")
  Dir["#{emails_dir}/*.eml"].each do |email_file|
    expected_file = email_file.sub(/\.eml$/, ".expected.json")

    next unless File.exist?(expected_file)

    context "parsing email #{File.basename(email_file)}" do
      let(:raw_email) { File.read(email_file) }
      let(:mail) { Mail.read_from_string(raw_email) }
      let(:expected_data) { JSON.parse(File.read(expected_file)).deep_symbolize_keys }
      let(:parser_class) { Parsers::ParserRegistry.find_for(mail) }

      it "finds a parser for the current email" do
        expect(parser_class).to be_present
      end

      it "parses correctly" do
        parsed = parser_class.new(mail).parse
        expect(parsed).to eq(expected_data)
      end
    end
  end
end
