# Normalizator::BaseRule module
module Normalizator
  class BaseRule
    attr_reader :options

    DEFAULT_OPTIONS = {
      return_original_on_failure: true,
      default_value_on_failure: nil,
      runs_on_derived_value: false
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
