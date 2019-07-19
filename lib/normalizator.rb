require 'normalizator/default_options'
require 'normalizator/error'
require 'normalizator/normalize'
require 'rules/base_rule'
require 'rules/enum_rule'
require 'rules/numeric_rule'

# Normalizator normizlize your data
module Normalizator
  include Normalizator::DefaultOptions

  module_function

  def normalize(rules, data, options = {})
    Normalize.new(rules, data, DEFAULT_OPTIONS.merge(options)).normalize
  end
end
