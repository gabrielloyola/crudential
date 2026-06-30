require 'rails_helper'

RSpec.describe Participant, type: :model do
  subject(:participant) { build(:participant) }

  describe "associations" do
    it "has many registrations" do
      association = described_class.reflect_on_association(:registrations)

      expect(association.macro).to eq(:has_many)
      expect(association.options).to include(dependent: :restrict_with_exception)
    end
  end

  describe "validations" do
    it "is valid with the expected attributes" do
      expect(participant).to be_valid
    end

    it "requires a name" do
      participant.name = nil

      expect(participant).not_to be_valid
      expect(participant.errors[:name]).to include("can't be blank")
    end

    it "requires an email" do
      participant.email = nil

      expect(participant).not_to be_valid
      expect(participant.errors[:email]).to include("can't be blank")
    end

    it "requires a valid email format" do
      participant.email = "invalid-email"

      expect(participant).not_to be_valid
      expect(participant.errors[:email]).to include("is invalid")
    end

    it "requires a document number" do
      participant.document_number = nil

      expect(participant).not_to be_valid
      expect(participant.errors[:document_number]).to include("can't be blank")
    end

    it "requires a unique document number" do
      create(:participant, document_number: "123.456.789-00")

      participant.document_number = "12345678900"

      expect(participant).not_to be_valid
      expect(participant.errors[:document_number]).to include("has already been taken")
    end
  end

  describe "normalization" do
    it "strips and downcases email addresses" do
      participant.email = "  GRACE@Example.COM  "
      participant.valid?

      expect(participant.email).to eq("grace@example.com")
    end

    it "keeps only digits in document numbers" do
      participant.document_number = "123.456.789-00"
      participant.valid?

      expect(participant.document_number).to eq("12345678900")
    end
  end
end
