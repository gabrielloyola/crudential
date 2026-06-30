require 'rails_helper'

RSpec.describe "Api::V1::Events", type: :request do
  describe "GET /api/v1/events" do
    subject(:perform_request) { get api_v1_events_path, params: params }

    let(:params) { {} }

    it "returns events ordered by start date" do
      later_event
      earlier_event
      perform_request

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body.pluck("id")).to eq([ earlier_event.id, later_event.id ])
    end

    let(:later_event) { create(:event, name: "Later", starts_at: 3.days.from_now, ends_at: 4.days.from_now) }
    let(:earlier_event) { create(:event, name: "Earlier", starts_at: 1.day.from_now, ends_at: 2.days.from_now) }

    context "when status is provided" do
      let(:params) { { status: "published" } }
      let(:published_event) { create(:event, status: "published") }

      before do
        published_event
        create(:event, status: "draft")
      end

      it "filters events by status" do
        perform_request

        expect(response).to have_http_status(:ok)
        expect(response.parsed_body.pluck("id")).to eq([ published_event.id ])
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
        perform_request

        expect(response).to have_http_status(:ok)
        expect(response.parsed_body.pluck("id")).to eq([ inside_event.id ])
      end
    end

    context "when status is unknown" do
      let(:params) { { status: "unknown" } }

      it "rejects the request" do
        perform_request

        expect(response).to have_http_status(:unprocessable_content)
        expect(response.parsed_body).to eq(
          "errors" => {
            "status" => [ "is not included in the list" ]
          }
        )
      end
    end

    context "when ends_at is not after starts_at" do
      let(:params) do
        {
          starts_at: "2026-07-10T10:00:00Z",
          ends_at: "2026-07-10T10:00:00Z"
        }
      end

      it "rejects the request" do
        perform_request

        expect(response).to have_http_status(:unprocessable_content)
        expect(response.parsed_body).to eq(
          "errors" => {
            "ends_at" => [ "must be after starts at" ]
          }
        )
      end
    end
  end

  describe "GET /api/v1/events/:id" do
    subject(:perform_request) { get api_v1_event_path(id) }

    let(:id) { event.id }
    let(:event) { create(:event) }

    it "returns the event" do
      perform_request

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body).to include(
        "id" => event.id,
        "name" => event.name,
        "status" => event.status
      )
    end

    context "when the event does not exist" do
      let(:id) { 999_999 }

      it "returns not found" do
        perform_request

        expect(response).to have_http_status(:not_found)
        expect(response.parsed_body).to eq(
          "errors" => {
            "id" => [ "not found" ]
          }
        )
      end
    end
  end
end
