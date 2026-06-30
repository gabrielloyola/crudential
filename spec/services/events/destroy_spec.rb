require 'rails_helper'

RSpec.describe Events::Destroy, type: :service do
  describe ".call" do
    subject(:result) { described_class.call(params) }

    let(:params) { { id: event.id } }
    let!(:event) { create(:event) }

    it "destroys the event" do
      expect { result }.to change(Event, :count).by(-1)
      expect(result).to be_success
      expect(result.errors).to eq({})
    end

    context "when the event does not exist" do
      let(:params) { { id: 999_999 } }

      it "returns errors" do
        expect { result }.not_to change(Event, :count)
        expect(result).not_to be_success
        expect(result.errors).to eq(id: [ "not found" ])
      end
    end

    context "when the event has registrations" do
      before do
        create(:registration, event: event)
      end

      it "does not destroy the event and returns errors" do
        expect { result }.not_to change(Event, :count)
        expect(result).not_to be_success
        expect(result.errors).to eq(base: [ "cannot delete event with registrations" ])
      end
    end
  end
end
