class EmlFile < ApplicationRecord
  has_one_attached :file
  enum :status, [:pending, :processing, :success, :failed]

  after_create :trigger_processing

  validates :file, presence: true
  validate :file_must_be_eml

  private

  def trigger_processing
    ProcessEmlJob.perform_async(id)
  end

  def file_must_be_eml
    return unless file.attached?

    unless file.filename.extension.downcase == "eml"
      errors.add(:file, "must be a .eml file")
    end
  end
end
