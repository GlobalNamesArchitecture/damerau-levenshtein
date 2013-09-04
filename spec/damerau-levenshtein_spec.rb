require 'spec_helper'

describe DamerauLevenshtein do

  it 'should return version' do
    ver = DamerauLevenshtein::VERSION
    ver.should =~ /^\d+\.\d+\.\d+$/
    DamerauLevenshtein::version.should == ver
  end

  it 'should get tests' do
    tests = 'spec/damerau_levenshtein_test.txt'

    read_test_file(tests, 5) do |y|
      dl = DamerauLevenshtein
      if y
        res = dl.distance(y[0], y[1], y[3].to_i, y[2].to_i)
        puts y if res != y[4].to_i
        res.should == y[4].to_i
      end
    end
  end
end
