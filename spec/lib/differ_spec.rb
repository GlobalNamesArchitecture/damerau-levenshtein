# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

describe DamerauLevenshtein::Differ do
  let(:subject) { DamerauLevenshtein::Differ }
  let(:instance) { subject.new }

  describe ".new" do
    it "creates an instance" do
      expect(subject.new).to be_kind_of DamerauLevenshtein::Differ
    end
  end

  describe "#format" do
    it "shows default format of a diff" do
      expect(instance.format).to eq :tag
    end
  end

  describe "#format=" do
    it "allows to change format" do
      instance.format = :raw
      expect(instance.format).to eq :raw
      instance.format = :tag
    end

    it "allows strings as input" do
      instance.format = "raw"
      expect(instance.format).to eq :raw
      instance.format = :tag
    end

    it "does not change format, if input is unknown" do
      instance.format = :unknown
      expect(instance.format).to be :tag
    end
  end

  describe "#run" do
    it "shows raw difference between two strings" do
      instance.format = :raw
      res = [{ distance: 1, type: :subst },
             { distance: 2, type: :subst },
             { distance: 3, type: :subst }]
      expect(instance.run("one", "two")).to eq res
    end

    it "shows tag difference between two strings" do
      res = ["S<subst>om</subst>ethi<ins>n</ins>g",
             "S<subst>mo</subst>ethi<del>n</del>g"]
      expect(instance.run("Something", "Smoethig")).to eq res
      res = ["<del>S</del>ometh<ins>ing</ins>",
             "<ins>S</ins>ometh<del>ing</del>"]
      expect(instance.run("omething", "Someth")).to eq res
      res = ["<del>Somet</del><subst>aaaa</subst>",
             "<ins>Somet</ins><subst>hing</subst>"]
      expect(instance.run("aaaa", "Something")).to eq res
      res = ["<del>Something</del>", "<ins>Something</ins>"]
      expect(instance.run("", "Something")).to eq res
      res = ["<ins>Something</ins>", "<del>Something</del>"]
      expect(instance.run("Something", "")).to eq res
    end
  end
end

# rubocop:enable all
