require 'rails_helper'

RSpec.describe Registration, type: :model do
  subject(:registration) { build(:registration) }

  describe "associations" do
    it "belongs to an event" do
      association = described_class.reflect_on_association(:event)

      expect(association.macro).to eq(:belongs_to)
    end

    it "belongs to a participant" do
      association = described_class.reflect_on_association(:participant)

      expect(association.macro).to eq(:belongs_to)
    end

    it "has one credential" do
      association = described_class.reflect_on_association(:credential)

      expect(association.macro).to eq(:has_one)
      expect(association.options).to include(dependent: :restrict_with_exception)
    end

    it "has many access logs" do
      association = described_class.reflect_on_association(:access_logs)

      expect(association.macro).to eq(:has_many)
      expect(association.options).to include(dependent: :restrict_with_exception)
    end
  end

  describe "validations" do
    it "is valid with the expected attributes" do
      expect(registration).to be_valid
    end

    it "requires an event" do
      registration.event = nil

      expect(registration).not_to be_valid
      expect(registration.errors[:event]).to include("must exist")
    end

    it "requires a participant" do
      registration.participant = nil

      expect(registration).not_to be_valid
      expect(registration.errors[:participant]).to include("must exist")
    end

    it "requires a participant to be unique within an event" do
      existing_registration = create(:registration)

      registration.event = existing_registration.event
      registration.participant = existing_registration.participant

      expect(registration).not_to be_valid
      expect(registration.errors[:participant_id]).to include("has already been taken")
    end

    it "allows the same participant to register for different events" do
      existing_registration = create(:registration)

      registration.participant = existing_registration.participant

      expect(registration).to be_valid
    end

    it "requires confirmed_at when status is confirmed" do
      registration.status = "confirmed"
      registration.confirmed_at = nil

      expect(registration).not_to be_valid
      expect(registration.errors[:confirmed_at]).to include(
        "can't be blank when registration is confirmed"
      )
    end
  end

  describe "enums" do
    it "defines status values" do
      expect(described_class.statuses).to eq(
        "pending" => "pending",
        "confirmed" => "confirmed",
        "cancelled" => "cancelled"
      )
    end

    it "defaults status to pending" do
      expect(described_class.new.status).to eq("pending")
    end

    it "rejects unknown statuses" do
      registration.status = "unknown"

      expect(registration).not_to be_valid
      expect(registration.errors[:status]).to include("is not included in the list")
    end
  end
end
