require 'spec_helper'
require 'normalizator'

describe 'Normalizator::NumericRule' do
  let(:row) { { number1: 'hdgdf', number2: '666', number3: 69, number4: '-42', number5: '21' } }

  describe '.apply' do
    it 'follow the rule options to normalize data' do
      rules = {
        number1: Normalizator::NumericRule.new(),
        number2: Normalizator::NumericRule.new({ greater_than: 500 }),
        number3: Normalizator::NumericRule.new({ less_than: 100 }),
        number4: Normalizator::NumericRule.new({ negative: true })
      }

      normalized_data = Normalizator.normalize(rules, [row, row])

      expect(normalized_data).to eq( [
        { number1: 0, number2: 666, number3: 69, number4: -42 },
        { number1: 0, number2: 666, number3: 69, number4: -42 }
      ])
    end

    it 'returns the same value en failure or de configured one' do
      rules = {
        number1: Normalizator::NumericRule.new({
          return_original_on_failure: false,
          default_value_on_failure: nil,
          negative: true
        }),
        number2: Normalizator::NumericRule.new({ greater_than: 700 }),
        number3: Normalizator::NumericRule.new({ less_than: 68 }),
        number4: Normalizator::NumericRule.new({ positive: true })
      }

      normalized_data = Normalizator.normalize(rules, [row, row])

      expect(normalized_data).to eq( [
        { number1: nil, number2: '666', number3: 69, number4: '-42' },
        { number1: nil, number2: '666', number3: 69, number4: '-42' }
      ])
    end
  end
end