require 'rails_helper'

RSpec.describe Credential, type: :model do
  subject(:credential) { build(:credential) }

  describe "associations" do
    it "belongs to a registration" do
      association = described_class.reflect_on_association(:registration)

      expect(association.macro).to eq(:belongs_to)
    end

    it "has many access logs" do
      association = described_class.reflect_on_association(:access_logs)

      expect(association.macro).to eq(:has_many)
      expect(association.options).to include(dependent: :restrict_with_exception)
    end
  end

  describe "validations" do
    it "is valid with the expected attributes" do
      expect(credential).to be_valid
    end

    it "requires a registration" do
      credential.registration = nil

      expect(credential).not_to be_valid
      expect(credential.errors[:registration]).to include("must exist")
    end

    it "requires one credential per registration" do
      existing_credential = create(:credential)

      credential.registration = existing_credential.registration

      expect(credential).not_to be_valid
      expect(credential.errors[:registration_id]).to include("has already been taken")
    end

    it "requires issued_at" do
      credential.issued_at = nil

      expect(credential).not_to be_valid
      expect(credential.errors[:issued_at]).to include("can't be blank")
    end

    it "requires expires_at" do
      credential.expires_at = nil

      expect(credential).not_to be_valid
      expect(credential.errors[:expires_at]).to include("can't be blank")
    end

    it "requires expires_at to be after issued_at" do
      credential.expires_at = credential.issued_at

      expect(credential).not_to be_valid
      expect(credential.errors[:expires_at]).to include("must be after issued at")
    end
  end

  describe "enums" do
    it "defines status values" do
      expect(described_class.statuses).to eq(
        "active" => "active",
        "revoked" => "revoked",
        "expired" => "expired"
      )
    end

    it "defaults status to active" do
      expect(described_class.new.status).to eq("active")
    end

    it "rejects unknown statuses" do
      credential.status = "unknown"

      expect(credential).not_to be_valid
      expect(credential.errors[:status]).to include("is not included in the list")
    end
  end
end
