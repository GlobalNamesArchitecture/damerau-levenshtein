# frozen_string_literal: true

describe DamerauLevenshtein::Formatter do
  let(:subject) { DamerauLevenshtein::Formatter }

  describe ".new" do
    it "creates an instance" do
      expect(subject.new).to be_kind_of DamerauLevenshtein::Formatter
    end
  end
end
