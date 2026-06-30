module Events
  class Show < ApplicationService
    def call
      event = Event.find_by(id: params[:id])

      return Result.new(data: { event: event }) if event.present?

      add_error(:id, "not found")
      Result.new(errors: errors)
    end
  end
end
