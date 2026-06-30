class User < ApplicationRecord
  has_secure_password

  has_many :events, dependent: :restrict_with_exception

  enum :role, {
    admin: "admin",
    staff: "staff"
  }, default: :staff, validate: true

  normalizes :email, with: ->(email) { email.strip.downcase }

  validates :name, presence: true
  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP }
end
