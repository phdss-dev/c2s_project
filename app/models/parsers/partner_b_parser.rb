module Parsers
  class PartnerBParser < Parser
    def self.applicable?(email)
      Array(email.from).join.downcase.include?("contato@parceirob.com")
    end

    def initialize(email)
      @email = email
      @email_data = extract_data_from(email)
    end

    def parse
      {
        name: extract_name,
        email: extract_email,
        phone: extract_phone,
        product_code: extract_product_code,
        email_subject: extract_subject
      }
    end

    private

    def extract_name
      @email_data[/^(?:Cliente|Nome(?: completo| do cliente)?)[\s:–-]+(.+)$/i, 1]&.strip
    end

    def extract_email
      @email_data[/(?:E-?mail(?:\s*de\s*contato)?)[:-]\s*([^\n\r]+)/i, 1].to_s.strip
    end

    def extract_phone
      match = @email_data.match(/Telefone[:-]\s*(\+?\d[\d\s\-().]{8,}\d)/i)
      match ? "+#{match[1].gsub(/\D/, "")}" : ""
    end

    def extract_subject
      @email.subject
    end

    def extract_product_code
      match = @email.subject.match(/([A-Z]+-\d+)/i)
      match && match[1].to_s.strip
    end
  end
end
