# Normalizator::BaseRule module
module Normalizator
  class BaseRule
    DEFAULT_OPTIONS = {
      return_original_on_failure: true,
      default_value_on_failure: nil
    }.freeze

    def initialize(options = {})
      @options = DEFAULT_OPTIONS.merge(options)
    end

    private

    def get_value_on_failure(value)
      @options[:return_original_on_failure] ? value : @options[:default_value_on_failure]
    end
  end
end
