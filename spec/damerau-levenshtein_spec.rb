# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

describe DamerauLevenshtein do
  describe ".version" do
    it "returns version" do
      ver = DamerauLevenshtein::VERSION
      expect(ver).to match(/^\d+\.\d+\.\d+$/)
      expect(subject.version).to eq ver
    end
  end

  describe ".distance" do
    it "generates correct distance values" do
      tests = "spec/files/damerau_levenshtein_test.txt"

      read_test_file(tests, 5) do |y|
        dl = DamerauLevenshtein
        if y
          res = dl.distance(y[0], y[1], y[3].to_i, y[2].to_i)
          puts y if res != y[4].to_i
          expect(res).to eq y[4].to_i
        end
      end
    end

    it "does not generate random negative distance" do
      100_000.times do
        distance = DamerauLevenshtein.distance("aaaa", "aaaa", 1, 2)
        expect(distance).to(be >= 0)
      end
    end
  end

  describe ".string_distance" do
    it "is an alias for .distance" do
      tests = "spec/files/damerau_levenshtein_test.txt"

      read_test_file(tests, 5) do |y|
        dl = DamerauLevenshtein
        if y
          res1 = dl.distance(y[0], y[1], y[3].to_i, y[2].to_i)
          res2 = dl.string_distance(y[0], y[1], y[3].to_i, y[2].to_i)
          expect(res1).to eq res2
        end
      end
    end
  end

  describe ".array_distance" do
    it "works for arrays with elements up to 2**63 - 1" do
      distance = DamerauLevenshtein.array_distance(
        [2**63 - 1, 2**62, 2**61, 2**60],
        [2**63 - 1, 2**61, 2**62, 2**59]
      )
      expect(distance).to eq 2
    end
  end

  describe ".distance_utf" do
    it "is an alias to internal C implementation" do
      args = [[1, 2, 3], [1, 2, 3, 4], 1, 10]
      res1 = DamerauLevenshtein.distance_utf(*args)
      res2 = DamerauLevenshtein.internal_distance(*args)
      expect(res1).to eq(res2)
    end
  end
end

# rubocop:enable all
