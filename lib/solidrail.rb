# frozen_string_literal: true

require 'ripper'
require 'json'
require 'parallel'

require_relative 'solidrail/version'

# Main SolidRail module
module SolidRail
  # Error classes
  class Error < StandardError; end
  class ParseError < Error; end
  class CompilationError < Error; end
  class ValidationError < Error; end

  # Configuration
  class Configuration
    attr_accessor :solidity_version, :optimization_enabled, :gas_optimization, :security_checks

    def initialize
      @solidity_version = '^0.8.30'
      @optimization_enabled = true
      @gas_optimization = true
      @security_checks = true
    end
  end

  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end

# Load all components
require_relative 'solidrail/parser'
require_relative 'solidrail/mapper'
require_relative 'solidrail/generator'
require_relative 'solidrail/optimizer'
require_relative 'solidrail/validator'
require_relative 'solidrail/compiler'
