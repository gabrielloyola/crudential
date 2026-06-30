require 'rails_helper'

RSpec.describe Events::Show, type: :service do
  describe ".call" do
    subject(:result) { described_class.call(params) }

    let(:params) { { id: event.id } }
    let(:event) { create(:event) }

    it "returns a successful result with the event" do
      expect(result).to be_success
      expect(result.data.event).to eq(event)
      expect(result.errors).to eq({})
    end

    context "when the event does not exist" do
      let(:params) { { id: 999_999 } }

      it "returns errors" do
        expect(result).not_to be_success
        expect(result.data.event).to be_nil
        expect(result.errors).to eq(id: [ "not found" ])
      end
    end
  end
end
