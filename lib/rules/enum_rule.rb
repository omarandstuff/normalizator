# Normalizator::EnumRule module
module Normalizator
  class EnumRule < BaseRule
    def apply(value, _original_row)
      value_on_failure = get_value_on_failure(value)
      best_match = nil

      raise(RuleError, 'Array of enumerators is expected in the rule constructor options') unless @options[:enumerators].instance_of? Array

      @options[:enumerators].each do |enum|
        (best_match, perfect_match) = match_agains_enumerator(enum, value, best_match)

        break if perfect_match
      end

      best_match ? best_match : value_on_failure
    end

    private

    def match_agains_enumerator(enum, value, best_match)
      if @options[:case_sensitive]
        (best_match, perfect_match) = case_sensitive_matching(enum, value, best_match)
      else
        (best_match, perfect_match) = case_insensitive_matching(enum, value, best_match)
      end

      [best_match, perfect_match]
    end

    def case_sensitive_matching(enum, value, best_match)
      return [value, true] if value.strip == enum.strip
      return [enum, false] if @options[:diffuse] && enum.include?(value)

      [best_match, false]
    end

    def case_insensitive_matching(enum, value, best_match)
      sanitized_value = value.downcase.strip
      sanitized_enum = enum.downcase.strip

      return [enum, true] if sanitized_value == sanitized_enum
      return [enum, false] if @options[:diffuse] && !sanitized_value.empty? && sanitized_enum.include?(sanitized_value)

      [best_match, false]
    end
  end
end
