module Parsers
  class Parser
    def initialize(email)
      @email = email
    end

    def self.applicable?(email)
      raise NotImplementedError, "subclass must implement applicable?"
    end

    def parse
      raise NotImplementedError, "subclass must implement parse"
    end

    protected

    def extract_data_from(email)
      raw = if email.multipart?
        part = email.text_part || email.html_part
        part&.decoded.to_s
      else
        email.body.decoded.to_s
      end
      raw.dup.force_encoding("UTF-8").encode("UTF-8", invalid: :replace, undef: :replace, replace: "")
    end
  end
end
