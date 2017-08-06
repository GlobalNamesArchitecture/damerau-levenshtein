# frozen_string_literal: true

describe DamerauLevenshtein::Differ do
  let(:subject) { DamerauLevenshtein::Differ }
  let(:instance) { subject.new }

  describe ".new" do
    it "creates an instance" do
      expect(subject.new).to be_kind_of DamerauLevenshtein::Differ
    end
  end

  describe "#format" do
    it "shows format of a diff" do
      expect(instance.format).to eq :raw
    end
  end

  describe "#format=" do
    it "allows to change format" do
      instance.format = :tag
      expect(instance.format).to eq :tag
      instance.format = :raw
    end

    it "allows strings as input" do
      instance.format = "tag"
      expect(instance.format).to eq :tag
      instance.format = :raw
    end

    it "does not change format, if input is unknown" do
      instance.format = :unknown
      expect(instance.format).to be :raw
    end
  end

  describe "#show" do
    it "shows difference between two strings using levenshtein algorithm" do
      res = [{ distance: 1, type: :subst },
             { distance: 2, type: :subst },
             { distance: 3, type: :subst }]
      expect(instance.show("one", "two")).to eq res
    end
  end
end
