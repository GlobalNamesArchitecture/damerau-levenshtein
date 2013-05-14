require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe DamerauLevenshtein do

  it 'should return version' do
    DamerauLevenshtein::VERSION.should =~ /^\d+\.\d+\.\d+$/
  end

  it 'should get tests' do
    tests = File.expand_path(File.dirname(__FILE__)) + 
              '/damerau_levenshtein_test.txt'

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
