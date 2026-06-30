require 'rails_helper'

RSpec.describe AccessLog, type: :model do
  subject(:access_log) { build(:access_log) }

  describe "associations" do
    it "belongs to a registration" do
      association = described_class.reflect_on_association(:registration)

      expect(association.macro).to eq(:belongs_to)
    end

    it "belongs to a credential" do
      association = described_class.reflect_on_association(:credential)

      expect(association.macro).to eq(:belongs_to)
    end
  end

  describe "validations" do
    it "is valid with the expected attributes" do
      expect(access_log).to be_valid
    end

    it "requires a registration" do
      access_log.registration = nil

      expect(access_log).not_to be_valid
      expect(access_log.errors[:registration]).to include("must exist")
    end

    it "requires a credential" do
      access_log.credential = nil

      expect(access_log).not_to be_valid
      expect(access_log.errors[:credential]).to include("must exist")
    end

    it "requires attempted_at" do
      access_log.attempted_at = nil

      expect(access_log).not_to be_valid
      expect(access_log.errors[:attempted_at]).to include("can't be blank")
    end

    it "requires the credential to belong to the registration" do
      other_registration = build(:registration)
      access_log.registration = other_registration

      expect(access_log).not_to be_valid
      expect(access_log.errors[:credential]).to include("must belong to the registration")
    end
  end

  describe "enums" do
    it "defines result values" do
      expect(described_class.results).to eq(
        "granted" => "granted",
        "denied" => "denied"
      )
    end

    it "defaults result to denied" do
      expect(described_class.new.result).to eq("denied")
    end

    it "rejects unknown results" do
      access_log.result = "unknown"

      expect(access_log).not_to be_valid
      expect(access_log.errors[:result]).to include("is not included in the list")
    end
  end
end
