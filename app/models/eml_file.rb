class EmlFile < ApplicationRecord
  has_one_attached :file
  enum :status, [:pending, :processing, :success, :failed]

  after_create :trigger_processing

  private

  def trigger_processing
    ProcessEmlJob.perform_async(id)
  end
end
