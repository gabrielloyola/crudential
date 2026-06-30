module Events
  class Destroy < ApplicationService
    def call
      event = Event.find_by(id: params[:id])

      return not_found_result if event.blank?
      return Result.new if event.destroy

      Result.new(errors: event.errors.to_hash)
    rescue ActiveRecord::DeleteRestrictionError
      add_error(:base, "cannot delete event with registrations")
      Result.new(errors: errors)
    end

    private

    def not_found_result
      add_error(:id, "not found")
      Result.new(errors: errors)
    end
  end
end
