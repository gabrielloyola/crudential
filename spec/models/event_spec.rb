require 'rails_helper'

RSpec.describe Event, type: :model do
  subject(:event) { build(:event) }

  describe "associations" do
    it "belongs to a user" do
      association = described_class.reflect_on_association(:user)

      expect(association.macro).to eq(:belongs_to)
    end

    it "has many registrations" do
      association = described_class.reflect_on_association(:registrations)

      expect(association.macro).to eq(:has_many)
      expect(association.options).to include(dependent: :restrict_with_exception)
    end
  end

  describe "validations" do
    it "is valid with the expected attributes" do
      expect(event).to be_valid
    end

    it "requires a user" do
      event.user = nil

      expect(event).not_to be_valid
      expect(event.errors[:user]).to include("must exist")
    end

    it "requires a name" do
      event.name = nil

      expect(event).not_to be_valid
      expect(event.errors[:name]).to include("can't be blank")
    end

    it "requires a start date" do
      event.starts_at = nil

      expect(event).not_to be_valid
      expect(event.errors[:starts_at]).to include("can't be blank")
    end

    it "requires an end date" do
      event.ends_at = nil

      expect(event).not_to be_valid
      expect(event.errors[:ends_at]).to include("can't be blank")
    end

    it "requires a positive integer capacity" do
      event.capacity = 0

      expect(event).not_to be_valid
      expect(event.errors[:capacity]).to include("must be greater than 0")
    end

    it "requires the end date to be after the start date" do
      event.ends_at = event.starts_at

      expect(event).not_to be_valid
      expect(event.errors[:ends_at]).to include("must be after starts at")
    end
  end

  describe "enums" do
    it "defines status values" do
      expect(described_class.statuses).to eq(
        "draft" => "draft",
        "published" => "published",
        "ongoing" => "ongoing",
        "cancelled" => "cancelled"
      )
    end

    it "defaults status to draft" do
      expect(described_class.new.status).to eq("draft")
    end

    it "rejects unknown statuses" do
      event.status = "unknown"

      expect(event).not_to be_valid
      expect(event.errors[:status]).to include("is not included in the list")
    end
  end
end
