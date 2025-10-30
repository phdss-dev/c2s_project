module Parsers
  class ParserRegistry
    PARSERS = [
      Parsers::SupplierAParser,
      Parsers::PartnerBParser
    ].freeze

    def self.find_for(mail)
      PARSERS.find { |p| p.applicable?(mail) }
    end
  end
end
