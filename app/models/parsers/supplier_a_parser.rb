module Parsers
  class SupplierAParser < Parser
    def self.applicable?(email)
      Array(email.from).join.downcase.include?("loja@fornecedora.com")
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
      @email_data[/Nome\s*(?:completo|do\s*cliente)?\s*[:-]?\s*([A-Za-zÀ-Úà-ú .'-]+)/i, 1]&.strip || ""
    end

    def extract_email
      @email_data[/\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b/].to_s.strip || ""
    end

    def extract_phone
      match = @email_data.match(/(\+?\d{0,2}\s?\(?\d{2}\)?\s?\d{4,5}-?\d{4})/)
      match ? match[1].gsub(/\D/, "").to_s : ""
    end

    def extract_subject
      @email.subject || ""
    end

    def extract_product_code
      match = @email&.subject&.match(/([A-Z]{2,}[0-9]+)/i)
      match && match[1].to_s.strip
    end
  end
end
