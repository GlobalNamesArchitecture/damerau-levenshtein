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
    it "shows raw difference between two strings" do
      res = [{ distance: 1, type: :subst },
             { distance: 2, type: :subst },
             { distance: 3, type: :subst }]
      expect(instance.show("one", "two")).to eq res
    end

    it "shows tag difference between two strings" do
      instance.format = :tag
      res = ["S<subst>om</subst>ethi<ins>n</ins>g",
             "S<subst>mo</subst>ethi<del>n</del>g"]
      expect(instance.show("Something", "Smoethig")).to eq res
      res = ["<del>S</del>ometh<ins>ing</ins>",
             "<ins>S</ins>ometh<del>ing</del>"]
      expect(instance.show("omething", "Someth")).to eq res
      res = ["<del>Somet</del><subst>aaaa</subst>",
             "<ins>Somet</ins><subst>hing</subst>"]
      expect(instance.show("aaaa", "Something")).to eq res
      res = ["<del>Something</del>", "<ins>Something</ins>"]
      expect(instance.show("", "Something")).to eq res
      res = ["<ins>Something</ins>", "<del>Something</del>"]
      expect(instance.show("Something", "")).to eq res
    end
  end
end

# rubocop:enable all
