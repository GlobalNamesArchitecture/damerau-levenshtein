# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts 'Run `bundle install` to install missing gems'
  exit e.status_code
end
require 'rake/dsl_definition'
require 'rake'
require 'rake/extensiontask'

require 'rspec'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:features)

Rake::ExtensionTask.new('damerau_levenshtein_binding') do |extension|
    extension.lib_dir = 'lib'
end

Rake::Task[:spec].prerequisites << :compile
Rake::Task[:features].prerequisites << :compile
task :default => :spec
