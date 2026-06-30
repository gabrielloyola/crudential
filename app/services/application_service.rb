class ApplicationService
  Result = Data.define(:events, :errors) do
    def success?
      errors.empty?
    end

    def failure?
      errors.present?
    end
  end

  def self.call(params = {})
    new(params).call
  end

  def initialize(params = {})
    @params = params.to_h.symbolize_keys
    @errors = {}
  end

  private

  attr_reader :params, :errors

  def add_error(attribute, message)
    errors[attribute] ||= []
    errors[attribute] << message
  end
end
