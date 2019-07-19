# frozen_string_literal: true

module Normalizator
  def self.gem_version
    Gem::Version.new VERSION::STRING
  end

  # Version builder module
  module VERSION
    # major version
    MAJOR = 0
    # minor version
    MINOR = 0
    # tiny version
    TINY  = 1
    # alpha, beta, etc. tag
    PRE   = nil

    # Build version string
    STRING = [[MAJOR, MINOR, TINY].compact.join('.'), PRE].compact.join('-')
  end
end
