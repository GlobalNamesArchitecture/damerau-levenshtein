# frozen_string_literal: true

module DamerauLevenshtein
  # Formats supplied strings according to their differences
  class Formatter
    def initialize(formatter)
      @formatter = formatter
    end

    def show(raw_format, str1, str2)
      @formatter.show(raw_format, str1, str2)
    end
  end

  # Outputs raw format for two strings
  module FormatterRaw
    def self.show(raw_format, _, _)
      raw_format
    end
  end

  # Outputs strings marked with tags
  module FormatterTag
    def self.show(raw_format, str1, str2)
      inverted_raw_format = raw_format.map do |e|
        e[:type] = :ins if e[:type] == :del
        e[:type] = :del if e[:dype] == :ins
        e
      end
      [show_string(raw_format, str1), show_string(inverted_raw_format, str2)]
    end

    def self.show_string(raw, str)
      str = []
      current_type = nil
      raw.each_with_index do |e, i|
        current_type = process_entry(str, e, i, current_type)
      end
      str << format("</%s>", current_type) if current_type != :same
    end

    def process_entry(str, e, _, current_type)
      return e[:type] if current_type && e[:type] != current_type &&
                         current_type != :same
      str << format("</%s>", current_type)
      str << format("<%s>", e[:type]) if e[:type] != :same
    end
  end
end
