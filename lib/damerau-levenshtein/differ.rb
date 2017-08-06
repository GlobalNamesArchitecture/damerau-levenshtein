# frozen_string_literal: true

module DamerauLevenshtein
  # Shows the difference between two strings in character by character
  # resolution
  class Differ
    FORMATS = %i[raw tag].freeze
    attr_accessor :format

    def initialize
      @format = :raw
      @matrix = []
      @len1 = 0
      @len2 = 0
    end

    def format=(new_format)
      new_format = new_format.to_sym
      @format = new_format if FORMATS.include?(new_format)
    end

    def show(str1, str2)
      @len1 = str1.size
      @len2 = str2.size
      prepare_matrix
      edit_distance(str1, str2)
      raw = trace_back
      formatter_factory(@format).new(str1, str2, raw).format
    end

    private

    def edit_distance(str1, str2)
      (1..@len2).each do |i|
        (1..@len1).each do |j|
          no_change(i, j) && next if str2[i - 1] == str1[j - 1]
          @matrix[i][j] = [del(i, j), ins(i, j), subst(i, j)].min + 1
        end
      end
    end

    def trace_back
      res = []
      cell = [@len2, @len1]
      while cell != [0, 0]
        cell, char = char_data(cell)
        res.unshift char
      end
      res
    end

    def char_data(cell)
      char = { distance: @matrix[cell[0]][cell[1]] }
      val = find_previous(cell)
      previous_value = val[0][0]
      char[:type] = previous_value == char[:distance] ? :same : val[1]
      cell = val.pop
      [cell, char]
    end

    def find_previous(cell)
      [[[ins(*cell), 1], :ins, [cell[0], cell[1] - 1]],
       [[del(*cell), 2], :del, [cell[0] - 1, cell[1]]],
       [[subst(*cell), 0], :subst, [cell[0] - 1, cell[1] - 1]]].
        sort_by(&:first).first
    end

    def del(i, j)
      @matrix[i - 1][j]
    end

    def ins(i, j)
      @matrix[i][j - 1]
    end

    def subst(i, j)
      @matrix[i - 1][j - 1]
    end

    def no_change(i, j)
      @matrix[i][j] = @matrix[i - 1][j - 1]
    end

    def prepare_matrix
      @matrix = []
      @matrix << (0..@len1).to_a
      @len2.times do |i|
        ary = [i + 1] + (1..@len1).map { nil }
        @matrix << ary
      end
    end
  end
end
