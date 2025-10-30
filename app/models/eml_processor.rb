class EmlProcessor
  include Loggable

  def initialize(eml_file)
    @eml_file = eml_file
    @email = set_email
  end

  def process
    parser_class = Parsers::ParserRegistry.find_for(@email)
    return log_processing_failure("Remetente desconhecido") unless parser_class

    parser = parser_class.new(@email)
    data = parser.parse

    if valid_contact?(data)
      Customer.create!(data)
      log_processing_success(data)
    else
      log_processing_failure("Falta contato (email ou telefone)", data)
    end
  rescue => e
    Rails.logger.warn("Error during eml file processing: #{e.message}")
  end

  private

  def set_email
    @eml_file.file.open { |file| Mail.read(file) }
  end

  def valid_contact?(data)
    data[:email].present? || data[:phone].present?
  end

  def log_processing_success(extracted_data = {})
    create_log(
      status: :success,
      extracted_data: extracted_data
    )
  end

  def log_processing_failure(error, extracted_data = {})
    create_log(
      status: :failed,
      extracted_data: extracted_data,
      error: error
    )
  end
end
