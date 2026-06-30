class Participant < ApplicationRecord
  has_many :registrations, dependent: :restrict_with_exception

  normalizes :email, with: ->(email) { email.strip.downcase }
  normalizes :document_number, with: ->(document_number) { document_number.gsub(/\D/, "") }

  validates :name, :email, :document_number, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :document_number, uniqueness: true
end
