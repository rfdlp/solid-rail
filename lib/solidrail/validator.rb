# frozen_string_literal: true

module SolidRail
  # Validator module for code validation and error checking
  module Validator
    class << self
      def validate_ruby_code(source_code)
        errors = []

        # Basic syntax validation
        begin
          RubyVM::InstructionSequence.compile(source_code)
        rescue SyntaxError => e
          errors << "Syntax error: #{e.message}"
        end

        # Custom validation rules
        errors += validate_smart_contract_patterns(source_code)
        errors += validate_security_patterns(source_code)

        errors
      end

      def validate_solidity_code(solidity_code)
        errors = []

        # Basic Solidity syntax validation
        errors += validate_solidity_syntax(solidity_code)

        # Security validation
        errors += validate_solidity_security(solidity_code)

        errors
      end

      private

      def validate_smart_contract_patterns(source_code)
        errors = []

        # Check for required smart contract patterns
        errors << 'No contract class found' unless source_code.include?('class')

        # Check for proper initialization
        errors << 'Contract should have an initialize method' unless source_code.include?('initialize')

        errors
      end

      def validate_security_patterns(source_code)
        errors = []

        # Check for dangerous patterns
        errors << 'Use of eval is not allowed in smart contracts' if source_code.include?('eval')

        errors << 'System calls are not allowed in smart contracts' if source_code.include?('system')

        errors
      end

      def validate_solidity_syntax(solidity_code)
        errors = []

        # Basic syntax checks
        errors << 'Missing pragma solidity directive' unless solidity_code.include?('pragma solidity')

        errors << 'No contract definition found' unless solidity_code.include?('contract')

        errors
      end

      def validate_solidity_security(solidity_code)
        errors = []

        # Check for common security issues
        errors << 'Warning: Use of tx.origin may be unsafe' if solidity_code.include?('tx.origin')

        if solidity_code.include?('block.timestamp')
          errors << 'Warning: Use of block.timestamp for randomness is unsafe'
        end

        errors
      end
    end
  end
end
