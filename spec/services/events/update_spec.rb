require 'rails_helper'

RSpec.describe Events::Update, type: :service do
  describe ".call" do
    subject(:result) { described_class.call(params) }

    let(:params) do
      {
        id: event.id,
        name: "Updated Ruby Summit",
        description: "Updated description.",
        status: "published"
      }
    end
    let(:event) { create(:event, name: "Ruby Summit", status: "draft") }

    it "updates the event" do
      expect(result).to be_success
      expect(result.data.event).to have_attributes(
        id: event.id,
        name: "Updated Ruby Summit",
        description: "Updated description.",
        status: "published"
      )
      expect(result.errors).to eq({})
    end

    context "when the event does not exist" do
      let(:params) do
        {
          id: 999_999,
          name: "Updated Ruby Summit"
        }
      end

      it "returns errors" do
        expect(result).not_to be_success
        expect(result.data.event).to be_nil
        expect(result.errors).to eq(id: [ "not found" ])
      end
    end

    context "when params are invalid" do
      let(:params) do
        {
          id: event.id,
          starts_at: "2026-07-10T10:00:00Z",
          ends_at: "2026-07-10T10:00:00Z",
          capacity: 0
        }
      end

      it "does not update the event and returns validation errors" do
        expect(result).not_to be_success
        expect(result.data.event).to be_nil
        expect(result.errors).to include(
          capacity: [ "must be greater than 0" ],
          ends_at: [ "must be after starts at" ]
        )
      end
    end
  end
end
