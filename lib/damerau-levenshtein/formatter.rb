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
    class << self
      def show(raw_format, str1, str2)
        inverted_raw_format = raw_format.map do |e|
          type = invert_type(e[:type])
          { distance: e[:distance], type: type }
        end
        [show_string(raw_format, str1, str2),
         show_string(inverted_raw_format, str2, str1)]
      end

      private

      def invert_type(type)
        case type
        when :del
          :ins
        when :ins
          :del
        else
          type
        end
      end

      def show_string(raw, str1, str2)
        data = { res: [], type: nil, deletes: 0, inserts: 0,
                 str1: str1, str2: str2 }
        raw.each_with_index do |e, i|
          process_entry(e, i, data)
        end
        data[:res] << format("</%s>", data[:type]) if data[:type] != :same
        data[:res].join("")
      end

      def process_entry(e, i, data)
        if data[:type] && e[:type] != data[:type]
          insert_tags(e, data)
        elsif data[:type].nil?
          data[:res] << format("<%s>", e[:type]) if e[:type] != :same
        end
        insert_letter(e, i, data)
      end

      def insert_tags(entry, data)
        data[:res] << format("</%s>", data[:type]) if data[:type] != :same
        data[:res] << format("<%s>", entry[:type]) if entry[:type] != :same
      end

      def insert_letter(entry, index, data)
        if entry[:type] == :del
          insert_del(index, data)
        else
          insert_others(index, data)
        end
        data[:inserts] += 1 if entry[:type] == :ins
        data[:type] = entry[:type]
      end

      def insert_del(i, data)
        data[:res] << data[:str2][i - data[:inserts]]
        data[:deletes] += 1
      end

      def insert_others(i, data)
        data[:res] << data[:str1][i - data[:deletes]]
      end
    end
  end
end
