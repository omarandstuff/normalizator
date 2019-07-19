# frozen_string_literal: true

# Normalizator::Normalize module
module Normalizator
  # Normalization logic for Normalizator
  class Normalize
    def initialize(rules, data, options)
      raise(Normalizator::NormalizeError, 'Nil data') unless data
      raise(Normalizator::NormalizeError, 'Nil rules') unless rules
      @rules = rules
      @data = data
      @rules_keys = rules.keys
      @options = options
    end

    def normalize
      normalized_data = []

      @data.each do |original_row|
        normalized_row = run_rules_on_row original_row

        normalized_data.push(normalized_row)
      end

      normalized_data
    end

    private

    def run_rules_on_row(original_row)
      new_row = @options[:exclude_fileds_without_rule] ? {} : original_row.clone

      @rules_keys.each do |field|
        if field.instance_of? Array
          next if should_skip_mutly_field_rule(field, original_row)
          run_rules_on_multy_value(field, new_row, original_row)
        else 
          next if should_skip_rule(field, new_row, original_row)
          new_row[field] = run_rules_on_value(@rules[field], original_row[field], original_row)
        end
      end

      new_row
    end

    def run_rules_on_multy_value(multy_field, new_row, original_row)
      values = multy_field.map { |sub_field| original_row[sub_field] }

      normalized_values = run_rules_on_value(@rules[multy_field], values, original_row)

      multy_field.each_with_index do |sub_field, index|
        new_row[sub_field] = normalized_values[index]
      end
    end

    def run_rules_on_value(rules, values, original_row)
      if rules.instance_of? Array
        ruled_field = values

        rules.each do |rule|
          ruled_field = rule.apply(ruled_field, original_row)
        end

        ruled_field
      else
        rules.apply(values, original_row)
      end
    end

    def should_skip_rule(field, new_row, original_row)
      unless original_row.key? field
        return true if @options[:ignore_unmatched_rules]

        new_row[field] = @options[:default_unmatched_rules_value]
        true
      end
    end

    def should_skip_mutly_field_rule(multy_field, original_row)
      multy_field.any? { |sub_field| !original_row.key?(sub_field) }
    end
  end
end
