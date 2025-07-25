# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidRail do
  describe 'VERSION' do
    it 'has a version number' do
      expect(SolidRail::VERSION).not_to be nil
    end
  end

  describe 'configuration' do
    it 'has default configuration' do
      expect(SolidRail.configuration).to be_a(SolidRail::Configuration)
    end

    it 'allows configuration changes' do
      SolidRail.configure do |config|
        config.solidity_version = '^0.8.20'
      end

      expect(SolidRail.configuration.solidity_version).to eq('^0.8.20')
    end
  end

  describe 'error classes' do
    it 'has error hierarchy' do
      expect(SolidRail::Error).to be < StandardError
      expect(SolidRail::ParseError).to be < SolidRail::Error
      expect(SolidRail::CompilationError).to be < SolidRail::Error
      expect(SolidRail::ValidationError).to be < SolidRail::Error
    end
  end
end 