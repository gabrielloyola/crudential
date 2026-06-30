module Events
  class List < ApplicationService
    def call
      validate_status
      starts_at = parse_datetime(:starts_at)
      ends_at = parse_datetime(:ends_at)
      validate_date_range(starts_at, ends_at)

      return Result.new(data: { events: Event.none }, errors: errors) if errors.any?

      Result.new(data: { events: filtered_events(starts_at, ends_at) })
    end

    private

    def filtered_events(starts_at, ends_at)
      Event
        .then { |scope| filter_by_status(scope) }
        .then { |scope| filter_by_starts_at(scope, starts_at) }
        .then { |scope| filter_by_ends_at(scope, ends_at) }
        .order(:starts_at, :id)
    end

    def filter_by_status(scope)
      return scope if params[:status].blank?

      scope.where(status: params[:status])
    end

    def filter_by_starts_at(scope, starts_at)
      return scope if starts_at.blank?

      scope.where(starts_at: starts_at..)
    end

    def filter_by_ends_at(scope, ends_at)
      return scope if ends_at.blank?

      scope.where(ends_at: ..ends_at)
    end

    def validate_status
      return if params[:status].blank?
      return if Event.statuses.key?(params[:status])

      add_error(:status, "is not included in the list")
    end

    def parse_datetime(attribute)
      value = params[attribute]
      return if value.blank?

      Time.zone.parse(value).tap do |datetime|
        add_error(attribute, "is invalid") if datetime.blank?
      end
    rescue ArgumentError, TypeError
      add_error(attribute, "is invalid")
      nil
    end

    def validate_date_range(starts_at, ends_at)
      return if starts_at.blank? || ends_at.blank?
      return if ends_at > starts_at

      add_error(:ends_at, "must be after starts at")
    end
  end
end
