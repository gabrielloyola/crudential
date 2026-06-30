require 'rails_helper'

RSpec.describe Events::List, type: :service do
  describe ".call" do
    subject(:result) { described_class.call(params) }

    let(:params) { {} }

    it "returns a successful result with events ordered by start date" do
      later_event
      earlier_event

      expect(result).to be_success
      expect(result.data.events).to eq([ earlier_event, later_event ])
      expect(result.errors).to eq({})
    end

    let(:later_event) { create(:event, starts_at: 3.days.from_now, ends_at: 4.days.from_now) }
    let(:earlier_event) { create(:event, starts_at: 1.day.from_now, ends_at: 2.days.from_now) }

    context "when status is provided" do
      let(:params) { { status: "published" } }
      let(:published_event) { create(:event, status: "published") }

      before do
        published_event
        create(:event, status: "draft")
      end

      it "filters events by status" do
        expect(result).to be_success
        expect(result.data.events).to eq([ published_event ])
      end
    end

    context "when starts_at and ends_at are provided" do
      let(:params) do
        {
          starts_at: "2026-07-10T00:00:00Z",
          ends_at: "2026-07-10T23:59:59Z"
        }
      end
      let(:inside_event) do
        create(:event, starts_at: Time.zone.local(2026, 7, 10, 10), ends_at: Time.zone.local(2026, 7, 10, 18))
      end

      before do
        inside_event
        create(:event, starts_at: Time.zone.local(2026, 7, 9, 10), ends_at: Time.zone.local(2026, 7, 9, 18))
        create(:event, starts_at: Time.zone.local(2026, 7, 11, 10), ends_at: Time.zone.local(2026, 7, 11, 18))
      end

      it "filters events by the provided datetime range" do
        expect(result).to be_success
        expect(result.data.events).to eq([ inside_event ])
      end
    end

    context "when status is unknown" do
      let(:params) { { status: "unknown" } }

      it "returns errors" do
        expect(result).not_to be_success
        expect(result.data.events).to be_none
        expect(result.errors).to eq(status: [ "is not included in the list" ])
      end
    end

    context "when ends_at is not after starts_at" do
      let(:params) do
        {
          starts_at: "2026-07-10T10:00:00Z",
          ends_at: "2026-07-10T10:00:00Z"
        }
      end

      it "returns errors" do
        expect(result).not_to be_success
        expect(result.data.events).to be_none
        expect(result.errors).to eq(ends_at: [ "must be after starts at" ])
      end
    end

    context "when a datetime filter is invalid" do
      let(:params) { { starts_at: "not-a-date" } }

      it "returns errors" do
        expect(result).not_to be_success
        expect(result.data.events).to be_none
        expect(result.errors).to eq(starts_at: [ "is invalid" ])
      end
    end
  end
end
