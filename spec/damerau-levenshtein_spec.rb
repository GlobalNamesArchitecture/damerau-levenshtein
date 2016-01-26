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
end
