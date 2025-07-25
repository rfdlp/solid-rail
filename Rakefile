# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new(:rubocop)

desc 'Run all tests and linting'
task test: %i[spec rubocop]

desc 'Build the gem'
task build: :clean do
  system('gem build solidrail.gemspec')
end

desc 'Install the gem locally'
task install: :build do
  system('gem install solidrail-*.gem')
end

desc 'Clean build artifacts'
task :clean do
  FileUtils.rm_f(Dir.glob('solidrail-*.gem'))
end

desc 'Run the transpiler on example files'
task :examples do
  Dir.glob('examples/*.rb').each do |file|
    puts "Compiling #{file}..."
    system("ruby bin/solidrail compile #{file}")
  end
end

desc 'Show project information'
task :info do
  puts "SolidRail v#{SolidRail::VERSION}"
  puts "Ruby version: #{RUBY_VERSION}"
  puts "Platform: #{RUBY_PLATFORM}"
end
