# frozen_string_literal: true

require_relative 'lib/solidrail/version'

Gem::Specification.new do |spec|
  spec.name = 'solidrail'
  spec.version = SolidRail::VERSION
  spec.authors = ['Rafael Dalpra']
  spec.email = ['rafael@solidrail.dev']

  spec.summary = 'Ruby to Solidity transpiler for smart contract development'
  spec.description = 'Write smart contracts in Ruby, generate production-ready ' \
                     'Solidity code for Ethereum and EVM-compatible blockchains.'
  spec.homepage = 'https://github.com/rfdlp/solid-rail'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.0.0'

  spec.metadata['source_code_uri'] = 'https://github.com/rfdlp/solid-rail'
  spec.metadata['changelog_uri'] = 'https://github.com/rfdlp/solid-rail/blob/main/CHANGELOG.md'
  spec.metadata['bug_tracker_uri'] = 'https://github.com/rfdlp/solid-rail/issues'
  spec.metadata['documentation_uri'] = 'https://rubydoc.info/gems/solidrail'
  spec.metadata['rubygems_mfa_required'] = 'true'

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.glob('{bin,lib}/**/*') + %w[README.md LICENSE CHANGELOG.md]
  spec.bindir = 'bin'
  spec.executables = ['solidrail']
  spec.require_paths = ['lib']

  # Runtime dependencies
  spec.add_dependency 'colorize', '~> 0.8'
  spec.add_dependency 'json', '~> 2.6'
  spec.add_dependency 'parallel', '~> 1.22'
  spec.add_dependency 'thor', '~> 1.2'

  # Development dependencies are in Gemfile
end
