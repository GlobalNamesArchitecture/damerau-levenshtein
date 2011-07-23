require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "DamerauLevenshtein" do
  it 'should get tests' do
    read_test_file(File.expand_path(File.dirname(__FILE__)) + '/damerau_levenshtein_test.txt', 5) do |y|
      dl = DamerauLevenshtein.new
      if y
        res = dl.distance(y[0], y[1], y[3].to_i, y[2].to_i)
        puts y if res != y[4].to_i
        puts y
        res.should == y[4].to_i
      end
    end
  end
end
