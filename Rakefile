# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "cucumber/rake/task"
require "rubocop/rake_task"
require "rake/dsl_definition"
require "rake"
require "rake/extensiontask"
require "rspec"

RSpec::Core::RakeTask.new(:spec) do |rspec|
  rspec.pattern = FileList["spec/**/*_spec.rb"]
end

Cucumber::Rake::Task.new(:features)

Rake::ExtensionTask.new("damerau_levenshtein") do |extension|
  extension.ext_dir = "ext/damerau_levenshtein"
  extension.lib_dir = "lib/damerau-levenshtein"
end

Rake::Task[:spec].prerequisites << :compile
Rake::Task[:features].prerequisites << :compile

RuboCop::RakeTask.new
task default: %i[rubocop spec]
