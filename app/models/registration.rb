class Registration < ApplicationRecord
  belongs_to :event
  belongs_to :participant

  has_one :credential, dependent: :restrict_with_exception
  has_many :access_logs, dependent: :restrict_with_exception

  enum :status, {
    pending: "pending",
    confirmed: "confirmed",
    cancelled: "cancelled"
  }, default: :pending, validate: true

  validates :participant_id, uniqueness: { scope: :event_id }
  validate :confirmed_at_required_when_confirmed

  private

  def confirmed_at_required_when_confirmed
    return unless confirmed?
    return if confirmed_at.present?

    errors.add(:confirmed_at, "can't be blank when registration is confirmed")
  end
end
