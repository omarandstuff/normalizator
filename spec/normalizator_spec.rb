require 'spec_helper'
require 'normalizator'

describe 'Normalizator' do
  let(:enumerators) { ['500', '80'] }
  let(:row) { { number1: 'hdgdf', field1: '  8 ', field2: 'ABCDE', field3: 'FGHIJ' } }

  describe '#normalize' do
    it 'applies a default value for unmatched rules' do
      rules = {
        number1: Normalizator::NumericRule.new(),
        unmatched: Normalizator::NumericRule.new({ greater_than: 500 })
      }

      options = {
        ignore_unmatched_rules: false,
        default_unmatched_rules_value: ''
      }

      normalized_data = Normalizator.normalize(rules, [row, row], options)

      expect(normalized_data).to eq( [
        { number1: 0, unmatched: '' },
        { number1: 0, unmatched: '' }
      ])
    end

    it 'ignores unmatched rules by default' do
      rules = {
        number1: Normalizator::NumericRule.new(),
        unmatched: Normalizator::NumericRule.new({ greater_than: 500 })
      }

      normalized_data = Normalizator.normalize(rules, [row, row])

      expect(normalized_data).to eq( [
        { number1: 0 },
        { number1: 0 }
      ])
    end

    it 'can apply more than one rule per field' do
      rules = {
        number1: Normalizator::NumericRule.new(),
        field1: [
          Normalizator::EnumRule.new({ enumerators: enumerators, diffuse: true }),
          Normalizator::NumericRule.new()
        ]
      }

      normalized_data = Normalizator.normalize(rules, [row, row])

      expect(normalized_data).to eq( [
        { number1: 0, field1: 80 },
        { number1: 0, field1: 80 }
      ])
    end

    describe 'Custom rules' do
      it 'can run on and assign several fields at a time' do
        class CustomMultifield < Normalizator::BaseRule
          def apply(values, original_row)
            values.map { |value| value.downcase }
          end
        end

        class CustomMultifield2 < Normalizator::BaseRule
          def apply(values, original_row)
            values.map { |value| value.capitalize }
          end
        end

        rules = {
          [:number1, :field1] => CustomMultifield2.new(),
          [:field2, :field3] => [CustomMultifield.new(), CustomMultifield2.new()]
        }

        normalized_data = Normalizator.normalize(rules, [row, row])

        expect(normalized_data).to eq( [
          { number1: 'Hdgdf', field1: '  8 ', field2: 'Abcde', field3: 'Fghij' },
          { number1: 'Hdgdf', field1: '  8 ', field2: 'Abcde', field3: 'Fghij' }
        ])
      end
    end

  end
end