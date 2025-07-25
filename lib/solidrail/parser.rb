# frozen_string_literal: true

require 'ripper'

module SolidRail
  # Parser module for converting Ruby code to AST
  module Parser
    class << self
      def parse(source_code)
        ast = Ripper.sexp(source_code)
        raise ParseError, 'Failed to parse Ruby code' unless ast

        ASTNode.new(ast)
      end
    end

    # AST Node representation
    class ASTNode
      attr_reader :type, :children, :value, :line, :column

      def initialize(node_data)
        if node_data.is_a?(Array) && node_data.length >= 2
          @type = node_data[0]
          @children = node_data[1..].compact.map { |child| ASTNode.new(child) }
        else
          @type = :literal
          @value = node_data
        end
      end

      def method_missing(method_name, *args)
        if method_name.to_s.end_with?('?')
          type == method_name.to_s.chomp('?').to_sym
        else
          super
        end
      end

      def respond_to_missing?(method_name, include_private = false)
        method_name.to_s.end_with?('?') || super
      end
    end
  end
end
