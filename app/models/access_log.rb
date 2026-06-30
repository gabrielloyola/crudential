class AccessLog < ApplicationRecord
  belongs_to :registration
  belongs_to :credential

  enum :result, {
    granted: "granted",
    denied: "denied"
  }, default: :denied, validate: true

  validates :attempted_at, presence: true
  validate :credential_belongs_to_registration

  private

  def credential_belongs_to_registration
    return if credential.blank? || registration.blank?
    return if credential.registration == registration

    errors.add(:credential, "must belong to the registration")
  end
end
