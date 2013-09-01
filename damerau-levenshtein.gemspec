$:.push File.expand_path('../lib', __FILE__)

require 'damerau-levenshtein/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name = 'damerau-levenshtein'
  s.version = DamerauLevenshtein::VERSION
  s.homepage = 'https://github.com/GlobalNamesArchitecture/damerau-levenshtein'
  s.license = 'MIT'
  s.summary = %Q{Calculation of editing distance for 2 strings \
    using Levenshtein or Damerau-Levenshtein algorithms}
  s.description = %Q{This gem implements pure Levenshtein algorithm, \
    Damerau modification of it (where 2 character transposition counts \
    as 1 edit distance). It also includes Boehmer & Rees 2008 modification \
    of Damerau algorithm, where transposition of bigger than 1 character \
    blocks is taken in account as well (Boehmer & Rees 2008).}
  s.authors = ['Dmitry Mozzherin']
  s.email = 'dmozzherin@gmail.com'
  s.files = `git ls-files`.split("\n")
  s.extensions = ['ext/damerau_levenshtein/extconf.rb']
  s.require_paths = ['lib', 'lib/damerau-levenshtein']
end
