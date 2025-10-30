# app/models/processing_log.rb
class ProcessingLog < ApplicationRecord
  belongs_to :eml_file
  enum :status, [:success, :failed]
end
