<h1 align="center">
  <img src="https://raw.githubusercontent.com/omarandstuff/normalizator/master/media/normalizator-logo.png" alt="Normalizator" title="Normalizator" width="512">
</h1>

[![Gem Version](https://badge.fury.io/rb/normalizator.svg)](https://rubygems.org/gems/normalizator)
[![Build Status](https://travis-ci.org/omarandstuff/normalizator.svg?branch=master)](https://travis-ci.org/omarandstuff/normalizator)
[![Maintainability](https://api.codeclimate.com/v1/badges/8ac96249f76f2001c036/maintainability)](https://codeclimate.com/github/omarandstuff/normalizator/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/8ac96249f76f2001c036/test_coverage)](https://codeclimate.com/github/omarandstuff/normalizator/test_coverage)


Adaptable general solution for data normalization, you can create your custom rules to normalize any field in your data set.

## Getting staterd

```shell
gem install normalizator
```
Gamefile:
```ruby
gem 'normalizator'
```

## Input > Output

Your input should look like this

```ruby
input = [{ field: 'value', field2: 'value' }, { field: 'number', field2: 'number' } ]
```

So your output can look like this

```ruby
p output

[{ field: 'Value', field2: 'Value' }, { field: 'Number', field2: 'Number' } ]
```

in other words ana array of objects goes in, ana array of objects goes out.

## Rules

To normalize your data you need to make use of a set of rules that will run in every field that you want it normalized.

```ruby
require 'normalizator'

rules = {
  field: Normalizator::NumericRule.new() # This rule will run in "field"
}

input = [{
  field: '66'
}]

Normalizator.normalize(rules, input)

# [{ field: 66 }]
```

### Numeric Rule

Normalizator inclues a useful numeric rule to convert field values to numbers and verify if they fall into optional numeric validations.

```ruby
require 'normalizator'

rule_oprions = {
  return_original_on_failure: true, # if validations fail, return the original value?
  default_value_on_failure: nil, # if return_original_on_failure is set to false, which value return instead?
  runs_on_derived_value: false, # if a rula has been applied beore this one, ose that value?, false for the original one
  positive: false, # Validate if the number is positive or zero
  negative: false, # Validate if the number is negative
  greater_than: 0, # Validate if the number is greater than that number 
  less_than: 100 # Validate if the number is less than that number
}

rule = Normalizator::NumericRule.new(rule_options)
```

### Enum Rule

The enum rule makes sure the value falls into a set of enumerators useful when a field contand incomplete data but can be matched with the compelete one.

```ruby
require 'normalizator'

rule_oprions = {
  return_original_on_failure: true, # if validations fail, return the original value?
  default_value_on_failure: nil, # if return_original_on_failure is set to false, which value return instead?
  runs_on_derived_value: false, # if a rula has been applied beore this one, ose that value?, false for the original one
  enumerators: ['Complete', 'Whole'], # Array of posible complete values the field can have
  case_sensitive: false, # If you want only the values that match exactly with the enumerators: et this to true, you can combine it with return_original_on_failure, to set to nil values that don't match exactly
  diffuse: true # Use this if you one values to match partially with the enumerators and set, ex: { value: 'com' } -> { value: 'Complete' }
}

rule = Normalizator::EnumRule.new(rule_options)
```

### Run multiple rules

You can run multiple rules in a single field, just wrap them in an array

```ruby
require 'normalizator'

rules = {
  field: [Normalizator::NumericRule.new(), another_rule]
}
```

### Constrained rules

You can run rules on severak fields at the same time, just set the rules key as an array of the fields.

```ruby
require 'normalizator'

rules = {
  [:field, :field2]: custom_rule
}
```

## Contributions

PRs are welcome

## Lisence

MIT