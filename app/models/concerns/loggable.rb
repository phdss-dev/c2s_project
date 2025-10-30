# app/services/concerns/loggable.rb
module Loggable
  extend ActiveSupport::Concern

  def create_log(
    status:,
    extracted_data: {},
    errors: nil
  )
    raise ArgumentError, "eml_file is required" unless defined?(@eml_file) && @eml_file

    ActiveRecord::Base.transaction do
      ProcessingLog.create!(
        eml_file: @eml_file,
        status: status,
        extracted_data: extracted_data.to_json,
        errors: errors,
        processed_at: Time.current
      )

      @eml_file.update!(status: status, processed_at: Time.current)
    end
  rescue => e
    Rails.logger.error("Log creation failed: #{e.message}\n#{e.backtrace.join("\n")}")
    raise
  end
end
