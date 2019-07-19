# Normalizator::EnumRule module
module Normalizator
  class EnumRule < BaseRule
    def apply(value, _original_row)
      value_on_failure = get_value_on_failure(value)
      best_match = nil

      raise(RuleError, 'Array of enumerators is expected in the rule constructor options') unless @options[:enumerators].instance_of? Array

      @options[:enumerators].each do |enum|
        if @options[:case_sensitive]
          if value.strip == enum.strip
            best_match = value
            break
          end

          if @options[:diffuse]
            if enum.include? value
              best_match = enum
            end
          end
        else
          sanitized_value = value.downcase.strip
          sanitized_enum = enum.downcase.strip

          if sanitized_value == sanitized_enum
            best_match = enum
            break
          end

          if @options[:diffuse]
            if sanitized_enum.include? sanitized_value
              best_match = enum
            end
          end
        end
      end

      best_match ? best_match : value_on_failure
    end
  end
end
