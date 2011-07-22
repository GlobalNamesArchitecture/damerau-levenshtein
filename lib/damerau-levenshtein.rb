# encoding: UTF-8

require 'damerau_levenshtein_binding'

class DamerauLevenshtein
  include DamerauLevenshteinBinding

  def distance(str1, str2, opts = {:with_damerau => true, :max_distance => 10})
    block_size = opts[:with_damerau] ? 2 : 1
    max_distance = opts[:max_distance]
    require 'ruby-debug'; debugger
    distance_utf(str1.unpack("U*"), str2.unpack("U*"), block_size, max_distance)
  end
end
