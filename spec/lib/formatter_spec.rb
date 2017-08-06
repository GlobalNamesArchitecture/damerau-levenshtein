# frozen_string_literal: true

describe DamerauLevenshtein::Formatter do
  let(:subject) { DamerauLevenshtein::Formatter }
  let(:formatter) { DamerauLevenshtein::FormatterRaw }

  describe ".new" do
    it "creates an instance" do
      expect(subject.new(formatter)).
        to be_kind_of DamerauLevenshtein::Formatter
    end
  end
end
