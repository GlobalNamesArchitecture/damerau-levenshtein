# encoding: UTF-8

require 'damerau_levenshtein/damerau_levenshtein_binding'
require 'damerau_levenshtein/version'

module DamerauLevenshtein
  extend DamerauLevenshteinBinding

  def self.version
    VERSION
  end

  def self.distance(str1, str2, block_size = 1, max_distance = 10)
    distance_utf(str1.unpack('U*'), str2.unpack('U*'), block_size, max_distance)
  end
end
