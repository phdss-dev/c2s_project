class Customer < ApplicationRecord
  validates :email, format: {with: URI::MailTo::EMAIL_REGEXP}, allow_blank: true
  validate :has_contact_info

  private

  def has_contact_info
    if email.blank? && phone.blank?
      errors.add(:base, "Must have email or phone")
    end
  end
end
