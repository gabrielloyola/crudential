module Events
  class Create < ApplicationService
    def call
      event = Event.new(params)

      return Result.new(data: { event: event }) if event.save

      Result.new(errors: event.errors.to_hash)
    end
  end
end
