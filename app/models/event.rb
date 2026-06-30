class Event < ApplicationRecord
  belongs_to :user

  has_many :registrations, dependent: :restrict_with_exception

  enum :status, {
    draft: "draft",
    published: "published",
    ongoing: "ongoing",
    cancelled: "cancelled"
  }, default: :draft, validate: true

  validates :name, :starts_at, :ends_at, :capacity, presence: true
  validates :capacity, numericality: { only_integer: true, greater_than: 0 }
  validate :ends_at_after_starts_at

  private

  def ends_at_after_starts_at
    return if starts_at.blank? || ends_at.blank?
    return if ends_at > starts_at

    errors.add(:ends_at, "must be after starts at")
  end
end
