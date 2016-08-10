$LOAD_PATH.push File.expand_path("../lib", __FILE__)

require "damerau-levenshtein/version"

Gem::Specification.new do |s|
  s.name = "damerau-levenshtein"
  s.version = DamerauLevenshtein::VERSION
  s.homepage = "https://github.com/GlobalNamesArchitecture/damerau-levenshtein"
  s.authors = ["Dmitry Mozzherin"]
  s.email = "dmozzherin@gmail.com"
  s.license = "MIT"
  s.summary = "Calculation of editing distance for 2 strings " \
              "using Levenshtein or Damerau-Levenshtein algorithms"
  s.description = "This gem implements pure Levenshtein algorithm, " \
                  "Damerau modification (where 2 character " \
                  "transposition counts as 1 edit distance). It also " \
                  "includes Boehmer & Rees 2008 modification, " \
                  "to handle transposition in blocks with more than " \
                  "2 characters (Boehmer & Rees 2008)."
  s.files = `git ls-files -z`.split("\x0").
            reject { |f| f.match(%r{^(test|spec|features)/}) }
  s.extensions = ["ext/damerau_levenshtein/extconf.rb"]
  s.require_paths = ["lib", "lib/damerau-levenshtein"]

  s.add_development_dependency "rspec", "~> 3.5"
  # activesupport >= 5.0 does not support Ruby < 2.2
  s.add_development_dependency "activesupport", "~> 4.2"
  s.add_development_dependency "cucumber", "~> 2.4"
  s.add_development_dependency "ruby-prof", "~> 0.15"
  s.add_development_dependency "shoulda", "~> 3.5"
  s.add_development_dependency "rubocop", "~> 0.41"
  s.add_development_dependency "coveralls", "~> 0.8"
  s.add_development_dependency "bundler", "~> 1.11"
  s.add_development_dependency "rake", "~> 11.2"
  s.add_development_dependency "rake-compiler", "~> 1.0"
end
