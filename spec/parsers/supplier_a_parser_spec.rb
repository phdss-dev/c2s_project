require "rails_helper"
require "json"

RSpec.describe Parsers::SupplierAParser, type: :parser do
  let(:fixtures_dir) { Rails.root.join("spec/fixtures/files/emails/supplier_a") }

  def load_fixture(scenario)
    eml_file = fixtures_dir.join("#{scenario}.eml")
    json_file = fixtures_dir.join("#{scenario}.expected.json")

    skip "Fixture missing: #{eml_file}" unless eml_file.exist?
    skip "Expected missing: #{json_file}" unless json_file.exist?

    {
      raw_email: File.read(eml_file),
      expected: JSON.parse(File.read(json_file)).deep_symbolize_keys
    }
  end

  describe ".applicable?" do
    it "returns true when sender matches" do
      email = Mail.new(from: "loja@fornecedora.com")
      expect(described_class.applicable?(email)).to be true
    end

    it "returns false when sender does not match" do
      email = Mail.new(from: "outro@exemplo.com")
      expect(described_class.applicable?(email)).to be false
    end
  end

  describe "#parse" do
    context "with valid data" do
      let(:fixture) { load_fixture(:valid) }
      let(:email) { Mail.read_from_string(fixture[:raw_email]) }
      let(:parser) { described_class.new(email) }

      it "extracts all fields correctly" do
        expect(parser.parse).to eq(fixture[:expected])
      end
    end

    context "with missing email" do
      let(:fixture) { load_fixture(:missing_email) }
      let(:email) { Mail.read_from_string(fixture[:raw_email]) }
      let(:parser) { described_class.new(email) }

      it "returns empty email" do
        expect(parser.parse[:email]).to be_empty
      end

      it "still extracts other fields" do
        result = parser.parse
        expect(result[:name]).to be_present
        expect(result[:phone]).to be_present
        expect(result[:product_code]).to be_present
        expect(result[:email_subject]).to be_present
      end
    end

    context "with empty body" do
      let(:fixture) { load_fixture(:empty_fields) }
      let(:email) { Mail.read_from_string(fixture[:raw_email]) }
      let(:parser) { described_class.new(email) }

      it "returns empty values for missing fields" do
        result = parser.parse
        expect(result[:name]).to be_empty
        expect(result[:email]).to be_empty
        expect(result[:phone]).to be_empty
        expect(result[:email_subject]).to be_empty
      end
    end
  end
end
