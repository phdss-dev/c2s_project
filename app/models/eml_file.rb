class EmlFile < ApplicationRecord
  has_one_attached :file
  enum :status, [:pending, :processing, :success, :failed]

  after_create :trigger_processing

  validates :file, presence: true
  validate :file_must_be_eml
  validate :file_cannot_be_blank

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

  def file_cannot_be_blank
    return unless file.attached?

    if file.blob.byte_size.zero?
      errors.add(:file, "cannot be empty")
    end
  end
end
