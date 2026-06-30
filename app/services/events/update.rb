module Events
  class Update < ApplicationService
    def call
      event = Event.find_by(id: params[:id])

      return not_found_result if event.blank?
      return Result.new(data: { event: event }) if event.update(event_attributes)

      Result.new(errors: event.errors.to_hash)
    end

    private

    def event_attributes
      params.except(:id)
    end

    def not_found_result
      add_error(:id, "not found")
      Result.new(errors: errors)
    end
  end
end
