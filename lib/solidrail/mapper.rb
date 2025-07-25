# frozen_string_literal: true

module SolidRail
  # Mapper module for converting Ruby types and syntax to Solidity
  module Mapper
    class << self
      def map_type(ruby_type)
        case ruby_type
        when Integer then 'uint256'
        when String then 'string'
        when Array then 'uint256[]'
        when Hash then 'mapping(address => uint256)'
        when Symbol then 'enum'
        end
      end

      def map_visibility(ruby_visibility)
        {
          public: 'public',
          private: 'private',
          protected: 'internal'
        }.fetch(ruby_visibility, 'public')
      end

      def map_function_type(ruby_method)
        # Determine if function is pure, view, or payable
        if ruby_method.include?('pure')
          'pure'
        elsif ruby_method.include?('view')
          'view'
        elsif ruby_method.include?('payable')
          'payable'
        else
          ''
        end
      end
    end
  end
end
