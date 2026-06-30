require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { build(:user, email: "ada@example.com", role: "admin") }

  describe "associations" do
    it "manages events as the admin user" do
      association = described_class.reflect_on_association(:events)

      expect(association.macro).to eq(:has_many)
      expect(association.options).to include(dependent: :restrict_with_exception)
    end
  end

  describe "validations" do
    it "is valid with the expected attributes" do
      expect(user).to be_valid
    end

    it "requires a name" do
      user.name = nil

      expect(user).not_to be_valid
      expect(user.errors[:name]).to include("can't be blank")
    end

    it "requires an email" do
      user.email = nil

      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it "requires a valid email format" do
      user.email = "invalid-email"

      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("is invalid")
    end

    it "requires a unique email regardless of case" do
      create(:user, email: "ADA@example.com", role: "admin")

      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("has already been taken")
    end

    it "requires a password on create" do
      user.password = nil

      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("can't be blank")
    end
  end

  describe "enums" do
    it "defines role values" do
      expect(described_class.roles).to eq(
        "admin" => "admin",
        "staff" => "staff"
      )
    end

    it "defaults role to staff" do
      expect(described_class.new.role).to eq("staff")
    end

    it "rejects unknown roles" do
      user.role = "unknown"

      expect(user).not_to be_valid
      expect(user.errors[:role]).to include("is not included in the list")
    end
  end

  describe "normalization" do
    it "strips and downcases email addresses" do
      user.email = "  ADA@Example.COM  "
      user.valid?

      expect(user.email).to eq("ada@example.com")
    end
  end

  describe "secure password" do
    it "stores a password digest and authenticates with the password" do
      user.save!

      expect(user.password_digest).to be_present
      expect(user.authenticate("super-secret")).to eq(user)
      expect(user.authenticate("wrong-password")).to be(false)
    end
  end
end
