
require 'rspec'
require 'simplecov'
require 'simplecov-json'
require 'codeclimate-test-reporter'

SimpleCov.configure do
  root File.join(File.dirname(__FILE__), '..')
  project_name 'Normalizator'
  add_filter 'spec'
end

SimpleCov.start

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = %i[should expect]
  end

  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.order = 'random'
end