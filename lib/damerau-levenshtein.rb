# encoding: UTF-8

require "damerau-levenshtein/version"
require "damerau-levenshtein/damerau_levenshtein"

# Damerau-Levenshtein algorithm
module DamerauLevenshtein
  extend DamerauLevenshteinBinding

  def self.version
    VERSION
  end

  def self.distance(str1, str2, block_size = 1, max_distance = 10)
    internal_distance(
      str1.unpack("U*"), str2.unpack("U*"),
      block_size, max_distance
    )
  end

  def self.string_distance(*args)
    distance(*args)
  end

  def self.array_distance(array1, array2, block_size = 1, max_distance = 10)
    internal_distance(array1, array2, block_size, max_distance)
  end

  # keep backward compatibility - internal_distance was called distance_utf
  # before
  def self.distance_utf(*args)
    internal_distance(*args)
  end
end
