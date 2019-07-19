require 'spec_helper'
require 'normalizator'

describe 'Normalizator::EnumRule' do
  let(:enumerators) { ['Tango', 'Diego', 'David', 'Colima'] }
  let(:row) { { field1: 'tang', field2: 'Die', field3: 'David', field4: '  coli ', field5: 'foo' } }

  describe '.apply' do
    it 'follow the rule options to normalize data' do
      rules = {
        field1: Normalizator::EnumRule.new({ enumerators: enumerators, diffuse: true }),
        field2: Normalizator::EnumRule.new({ enumerators: enumerators, diffuse: true, case_sensitive: true }),
        field3: Normalizator::EnumRule.new({ enumerators: enumerators, case_sensitive: true }),
        field4: Normalizator::EnumRule.new({ enumerators: enumerators, diffuse: true })
      }

      normalized_data = Normalizator.normalize(rules, [row, row])

      expect(normalized_data).to eq( [
        { field1: 'Tango', field2: 'Diego', field3: 'David', field4: 'Colima' },
        { field1: 'Tango', field2: 'Diego', field3: 'David', field4: 'Colima' }
      ])
    end

    it 'returns the same value en failure or de configured one' do
      rules = {
        field1: Normalizator::EnumRule.new({
          return_original_on_failure: false,
          default_value_on_failure: nil,
          enumerators: enumerators
        }),
        field2: Normalizator::EnumRule.new({ enumerators: enumerators }),
        field3: Normalizator::EnumRule.new({ enumerators: enumerators }),
        field4: Normalizator::EnumRule.new({ enumerators: enumerators })
      }

      normalized_data = Normalizator.normalize(rules, [row, row])

      expect(normalized_data).to eq( [
        { field1: nil, field2: 'Die', field3: 'David', field4: '  coli ' },
        { field1: nil, field2: 'Die', field3: 'David', field4: '  coli ' }
      ])
    end

    it 'throws if enumerators are not provided' do
      rules = {
        field1: Normalizator::EnumRule.new()
      }

      expect{Normalizator.normalize(rules, [row, row])}.to raise_error(Normalizator::RuleError)
    end
  end
end