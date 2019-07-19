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
          next if field.any? { |sub_field| !original_row.key?(sub_field) }

          values = field.map { |sub_field| original_row[sub_field] }

          normalized_values = []

          if @rules[field].instance_of? Array
            ruled_field = values

            @rules[field].each do |rule|
              ruled_field = rule.apply(ruled_field, original_row)
            end

            normalized_values = ruled_field
          else
            normalized_values = @rules[field].apply(values, original_row)
          end

          field.each_with_index do |sub_field, index|
            new_row[sub_field] = normalized_values[index]
          end
        else 
          unless original_row.key? field
            next if @options[:ignore_unmatched_rules]
  
            new_row[field] = @options[:default_unmatched_rules_value]
            next
          end
          
          if @rules[field].instance_of? Array
            ruled_field = original_row[field]

            @rules[field].each do |rule|
              ruled_field = rule.apply(ruled_field, original_row)
            end

            new_row[field] = ruled_field
          else
            new_row[field] = @rules[field].apply(original_row[field], original_row)
          end
        end
      end

      new_row
    end
  end
end
