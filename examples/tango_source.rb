require 'normalizator'

# Custom Rule to split trim from model
class ModelTrimRule < Normalizator::BaseRule
  def apply(values, _original_row)
    splited = values[0].split(' ')

    if splited.size > 1
      [splited[0], splited[1]]
    else
      values
    end
  end
end

# Custom rul to set nil "blank" values
class BlankRule < Normalizator::BaseRule
  def apply(value, _original_row)
    value == 'blank' ? nil : value
  end
end

years_rule = Normalizator::NumericRule.new({
  greater_than: 1899,
  less_that: Time.new.year + 3
})
make_rule = Normalizator::EnumRule.new({
  enumerators: ['Ford', 'Chevrolet', 'JEEP'],
  diffuse: true
})
model_trim_rule = ModelTrimRule.new()
model_rule = Normalizator::EnumRule.new({
  enumerators: ['Focus', 'Impala'],
  diffuse: true,
  runs_on_derived_value: true
})
trim_rule = Normalizator::EnumRule.new({
  enumerators: ['SE', 'ST'],
  diffuse: true,
  runs_on_derived_value: true
})
blank_rule = BlankRule.new()

@rules = {
  year: [years_rule, blank_rule],
  make: [make_rule, blank_rule],
  [:model, :trim] => model_trim_rule,
  model: [model_rule, blank_rule],
  trim: [trim_rule, blank_rule],
}

# Normalize the data provded using the defined rules
def normalize_data(input)
   Normalizator.normalize(@rules, [input])
end

examples = [
  # To-be normalized data                                                           # Normalized data
  [{ :year => '2018', :make => 'fo',      :model => 'focus',    :trim => 'blank' }, { :year => 2018,  :make => 'Ford',      :model => 'Focus',  :trim => nil }],
  [{ :year => '200',  :make => 'blah',    :model => 'foo',      :trim => 'bar' },   { :year => '200', :make => 'blah',      :model => 'foo',    :trim => 'bar' }],
  [{ :year => '1999', :make => 'Chev',    :model => 'IMPALA',   :trim => 'st' },    { :year => 1999,  :make => 'Chevrolet', :model => 'Impala', :trim => 'ST' }],
  [{ :year => '2000', :make => 'ford',    :model => 'focus se', :trim => '' },      { :year => 2000,  :make => 'Ford',      :model => 'Focus',  :trim => 'SE' }]
]

examples.each_with_index do |(input, expected_output), index|
  output = normalize_data(input)

  if output[0] != expected_output
    puts "Example #{index + 1} failed,
          Expected: #{expected_output.inspect}
          Got:      #{output.inspect}"

  else
    puts "Case #{index + 1}: succes!"
  end
end