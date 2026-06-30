class Result
  attr_reader :data, :errors

  def initialize(data: {}, errors: {})
    @data = normalize_data(data)
    @errors = errors
  end

  def success?
    errors.empty?
  end

  def failure?
    errors.present?
  end

  private

  def normalize_data(data)
    return data unless data.is_a?(Hash)

    ActiveSupport::OrderedOptions.new.tap do |options|
      data.each do |key, value|
        options[key] = value
      end
    end
  end
end
