class Credential < ApplicationRecord
  belongs_to :registration

  has_many :access_logs, dependent: :restrict_with_exception

  enum :status, {
    active: "active",
    revoked: "revoked",
    expired: "expired"
  }, default: :active, validate: true

  validates :registration_id, uniqueness: true
  validates :issued_at, :expires_at, presence: true
  validate :expires_at_after_issued_at

  private

  def expires_at_after_issued_at
    return if issued_at.blank? || expires_at.blank?
    return if expires_at > issued_at

    errors.add(:expires_at, "must be after issued at")
  end
end
