require 'rails_helper'

RSpec.describe Events::Create, type: :service do
  describe ".call" do
    subject(:result) { described_class.call(params) }

    let(:params) do
      {
        name: "Ruby Summit",
        description: "A conference for Rubyists.",
        starts_at: "2026-07-10T10:00:00Z",
        ends_at: "2026-07-10T18:00:00Z",
        capacity: 120,
        status: "published",
        user_id: user.id
      }
    end
    let(:user) { create(:user) }

    it "creates an event" do
      expect { result }.to change(Event, :count).by(1)
      expect(result).to be_success
      expect(result.data.event).to have_attributes(
        name: "Ruby Summit",
        description: "A conference for Rubyists.",
        status: "published",
        user_id: user.id
      )
      expect(result.errors).to eq({})
    end

    context "when params are invalid" do
      let(:params) do
        {
          name: "",
          starts_at: "2026-07-10T10:00:00Z",
          ends_at: "2026-07-10T10:00:00Z",
          capacity: 0,
          user_id: user.id
        }
      end

      it "does not create an event and returns validation errors" do
        expect { result }.not_to change(Event, :count)
        expect(result).not_to be_success
        expect(result.data.event).to be_nil
        expect(result.errors).to include(
          name: [ "can't be blank" ],
          capacity: [ "must be greater than 0" ],
          ends_at: [ "must be after starts at" ]
        )
      end
    end
  end
end
