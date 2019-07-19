# Normalizator::NumericRule module
module Normalizator
  class NumericRule < BaseRule
    def apply(value, _original_row)
      value_on_failure = get_value_on_failure(value)

      apply_numeric_rules value_on_failure, value.to_i
    end

    private

    def apply_numeric_rules(value_on_failure, value)
      return value_on_failure if @options[:positive] && value < 0
      return value_on_failure if @options[:negative] && value >= 0
      return value_on_failure if @options[:greater_than] && value < @options[:greater_than]
      return value_on_failure if @options[:less_than] && value > @options[:less_than]

      value
    end
  end
end
