$:.push File.expand_path("../lib", __FILE__)

require "damerau-levenshtein/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "damerau-levenshtein"
  s.version     = DamerauLevenshtein::VERSION
  s.homepage    = "https://github.com/GlobalNamesArchitecture/damerau-levenshtein"
  s.license = 'MIT'
  s.summary = %Q{Calculation of editing distance for 2 strings \
    using Levenshtein or Damerau-Levenshtein algorithms}
  s.description = %Q{Calculation of editing distance for 2 strings using \
    Levenshtein or Damerau-Levenshtein algorithms}
  s.authors = ['Dmitry Mozzherin']
  s.email = 'dmozzherin@gmail.com'
  s.files = `git ls-files`.split("\n")

  s.add_dependency 'bundler',       '~> 1.0'
  s.add_dependency 'rake',          '~> 10.0'
  s.add_dependency 'rake-compiler', '~> 0.8'

  s.add_development_dependency 'debugger', '~> 1.4'

  s.add_development_dependency 'rspec',     '~> 2.13'
  s.add_development_dependency 'cucumber',  '~> 1.2'
  s.add_development_dependency 'simplecov', '~> 0.7'
  s.add_development_dependency 'ruby-prof', '~> 0.13'
  s.add_development_dependency 'shoulda',   '~> 3.3'

end
