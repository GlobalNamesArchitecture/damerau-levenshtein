# encoding: UTF-8
require 'spec_helper'

describe 'DamerauLevenshteinMod' do
  it 'should get tests' do
    read_test_file(File.expand_path(File.dirname(__FILE__)) + '/damerau_levenshtein_mod_test.txt', 5) do |y|
      dl = Taxamatch::DamerauLevenshteinMod.new
      if y
        res = dl.distance(y[0], y[1], y[3].to_i, y[2].to_i)
        puts y if res != y[4].to_i
        res.should == y[4].to_i
      end
    end
  end
end

describe 'Atomizer' do
  before(:all) do
    @parser = Taxamatch::Atomizer.new
  end

  it 'should parse uninomials' do
    @parser.parse('Betula').should == {:all_authors=>[], :all_years=>[], :uninomial=>{:string=>"Betula", :normalized=>"BETULA", :phonetized=>"BITILA", :authors=>[], :years=>[], :normalized_authors=>[]}}
    @parser.parse('Ærenea Lacordaire, 1872').should == {:all_authors=>["LACORDAIRE"], :all_years=>["1872"], :uninomial=>{:string=>"Aerenea", :normalized=>"AERENEA", :phonetized=>"ERINIA", :authors=>["Lacordaire"], :years=>["1872"], :normalized_authors=>["LACORDAIRE"]}}
  end

  it 'should parse binomials' do
    @parser.parse('Leœptura laetifica Dow, 1913').should == {:all_authors=>["DOW"], :all_years=>["1913"], :genus=>{:string=>"Leoeptura", :normalized=>"LEOEPTURA", :phonetized=>"LIPTIRA", :authors=>[], :years=>[], :normalized_authors=>[]}, :species=>{:string=>"laetifica", :normalized=>"LAETIFICA", :phonetized=>"LITIFICA", :authors=>["Dow"], :years=>["1913"], :normalized_authors=>["DOW"]}}
  end

  it 'should parse trinomials' do
    @parser.parse('Hydnellum scrobiculatum zonatum (Banker) D. Hall et D.E. Stuntz 1972').should == {:all_authors=>["BANKER", "D HALL", "D E STUNTZ"], :all_years=>["1972"], :genus=>{:string=>"Hydnellum", :normalized=>"HYDNELLUM", :phonetized=>"HIDNILIM", :authors=>[], :years=>[], :normalized_authors=>[]}, :species=>{:string=>"scrobiculatum", :normalized=>"SCROBICULATUM", :phonetized=>"SCRABICILATA", :authors=>[], :years=>[], :normalized_authors=>[]}, :infraspecies=>[{:string=>"zonatum", :normalized=>"ZONATUM", :phonetized=>"ZANATA", :authors=>["Banker", "D. Hall", "D.E. Stuntz"], :years=>["1972"], :normalized_authors=>["BANKER", "D HALL", "D E STUNTZ"]}]}
  end
end


describe 'Taxamatch::Normalizer' do
  it 'should normalize  strings' do
    Taxamatch::Normalizer.normalize('abcd').should == 'ABCD'
    Taxamatch::Normalizer.normalize('Leœptura').should == 'LEOEPTURA'
    Taxamatch::Normalizer.normalize('Ærenea').should == 'AERENEA'
    Taxamatch::Normalizer.normalize('Fallén').should == 'FALLEN'
    Taxamatch::Normalizer.normalize('Choriozopella trägårdhi').should == 'CHORIOZOPELLA TRAGARDHI'
  end

  it 'should normalize words' do
    Taxamatch::Normalizer.normalize_word('L-3eœ|pt[ura$').should == 'L-3EOEPTURA'
  end
end

describe 'Taxamatch::Base' do
  before(:all) do
    @tm = Taxamatch::Base.new
  end

  it 'should get txt tests' do
    dl = Taxamatch::DamerauLevenshteinMod.new
    read_test_file(File.expand_path(File.dirname(__FILE__)) + '/taxamatch_test.txt', 4) do |y|
      if y
        y[2] = y[2] == 'true' ? true : false
        res = @tm.taxamatch(y[0], y[1], false)
        puts "%s, %s, %s, %s" % [y[0], y[1], y[2], y[3]]
        res['match'].should == y[2]
        res['edit_distance'].should == y[3].to_i
      end
    end
  end

  it 'should work with names that cannot be parsed' do
    res = @tm.taxamatch('Quadraspidiotus ostreaeformis MacGillivray, 1921','Quadraspidiotus ostreaeformis Curtis)')
    res = false
  end

  it 'should compare genera' do
    #edit distance 1 always match
    g1 = make_taxamatch_hash 'Plantago'
    g2 = make_taxamatch_hash 'Plantagon'
    @tm.match_genera(g1, g2).should == {'phonetic_match' => false, 'edit_distance' => 1, 'match' => true}
    #edit_distance above threshold does not math
    g1 = make_taxamatch_hash 'Plantago'
    g2 = make_taxamatch_hash 'This shouldnt match'
    @tm.match_genera(g1, g2).should == {'phonetic_match' => false, 'match' => false, 'edit_distance' => 4}
    #phonetic_match matches
    g1 = make_taxamatch_hash 'Plantagi'
    g2 = make_taxamatch_hash 'Plantagy'
    @tm.match_genera(g1, g2).should == {'phonetic_match' => true, 'edit_distance' => 1, 'match' => true}
    #distance 1 in first letter also matches
    g1 = make_taxamatch_hash 'Xantheri'
    g2 = make_taxamatch_hash 'Pantheri'
    @tm.match_genera(g1, g2).should == {'phonetic_match' => false, 'edit_distance' => 1, 'match' => true}
    #phonetic match tramps everything
    g1 = make_taxamatch_hash 'Xaaaaantheriiiiiiiiiiiiiii'
    g2 = make_taxamatch_hash 'Zaaaaaaaaaaaantheryyyyyyyy'
    @tm.match_genera(g1, g2).should == {'phonetic_match' => true, 'edit_distance' => 4, 'match' => true}
    #same first letter and distance 2 should match
    g1 = make_taxamatch_hash 'Xaaaantherii'
    g2 = make_taxamatch_hash 'Xaaaantherrr'
    @tm.match_genera(g1, g2).should == {'phonetic_match' => false, 'match' => true, 'edit_distance' => 2}
    #First letter is the same and distance is 3 should match, no phonetic match
    g1 = make_taxamatch_hash 'Xaaaaaaaaaaantheriii'
    g2 = make_taxamatch_hash 'Xaaaaaaaaaaantherrrr'
    @tm.match_genera(g1, g2).should == {'phonetic_match' => false, 'match' => true, 'edit_distance' => 3}
    #Should not match if one of words is shorter than 2x edit distance and distance is 2 or 3
    g1 = make_taxamatch_hash 'Xant'
    g2 = make_taxamatch_hash 'Xanthe'
    @tm.match_genera(g1, g2).should ==  {'phonetic_match' => false, 'match' => false, 'edit_distance' => 2}
    #Should not match if edit distance > 3 and no phonetic match
    g1 = make_taxamatch_hash 'Xantheriiii'
    g2 = make_taxamatch_hash 'Xantherrrrr'
    @tm.match_genera(g1, g2).should ==  {'phonetic_match' => false, 'match' => false, 'edit_distance' => 4}
  end

  it 'should compare species' do
    #Exact match
    s1 = make_taxamatch_hash 'major'
    s2 = make_taxamatch_hash 'major'
    @tm.match_species(s1, s2).should ==  {'phonetic_match' => true, 'match' => true, 'edit_distance' => 0}
    #Phonetic match always works
    s1 = make_taxamatch_hash 'xanteriiieeeeeeeeeeeee'
    s2 = make_taxamatch_hash 'zantereeeeeeeeeeeeeeee'
    @tm.match_species(s1, s2).should ==  {'phonetic_match' => true, 'match' => true, 'edit_distance' => 4}
    #Phonetic match works with different endings
    s1 = make_taxamatch_hash 'majorum'
    s2 = make_taxamatch_hash 'majoris'
    @tm.match_species(s1, s2).should ==  {'phonetic_match' => true, 'match' => true, 'edit_distance' => 2}
    #Distance 4 matches if first 3 chars are the same
    s1 = make_taxamatch_hash 'majjjjorrrrr'
    s2 = make_taxamatch_hash 'majjjjoraaaa'
    @tm.match_species(s1, s2).should == {'phonetic_match' => false, 'match' => true, 'edit_distance' => 4}
    #Should not match if Distance 4 matches and first 3 chars are not the same
    s1 = make_taxamatch_hash 'majorrrrr'
    s2 = make_taxamatch_hash 'marorraaa'
    @tm.match_species(s1, s2).should == {'phonetic_match' => false, 'match' => false, 'edit_distance' => 4}
    #Distance 2 or 3 matches if first 1 char is the same
    s1 = make_taxamatch_hash 'moooorrrr'
    s2 = make_taxamatch_hash 'mooooraaa'
    @tm.match_species(s1, s2).should == {'phonetic_match' => false, 'match' => true, 'edit_distance' => 3}
    #Should not match if Distance 2 or 3 and first 1 char is not the same
    s1 = make_taxamatch_hash 'morrrr'
    s2 = make_taxamatch_hash 'torraa'
    @tm.match_species(s1, s2).should == {'phonetic_match' => false, 'match' => false, 'edit_distance' => 3}
    #Distance 1 will match anywhere
    s1 = make_taxamatch_hash 'major'
    s2 = make_taxamatch_hash 'rajor'
    @tm.match_species(s1, s2).should == {'phonetic_match' => false, 'match' => true, 'edit_distance' => 1}
    #Will not match if distance 3 and length is less then twice of the edit distance
    s1 = make_taxamatch_hash 'marrr'
    s2 = make_taxamatch_hash 'maaaa'
    @tm.match_species(s1, s2).should == {'phonetic_match' => false, 'match' => false, 'edit_distance' => 3}
  end

  it 'should match matches' do
    #No trobule case
    gmatch = {'match' => true, 'phonetic_match' => true, 'edit_distance' => 1}
    smatch = {'match' => true, 'phonetic_match' => true, 'edit_distance' => 1}
    @tm.match_matches(gmatch, smatch).should == {'phonetic_match' => true, 'edit_distance' => 2, 'match' => true}
    #Will not match if either genus or sp. epithet dont match
    gmatch = {'match' => false, 'phonetic_match' => false, 'edit_distance' => 1}
    smatch = {'match' => true, 'phonetic_match' => true, 'edit_distance' => 1}
    @tm.match_matches(gmatch, smatch).should == {'phonetic_match'=>false, 'edit_distance'=>2, 'match'=>false}
    gmatch = {'match' => true, 'phonetic_match' => true, 'edit_distance' => 1}
    smatch = {'match' => false, 'phonetic_match' => false, 'edit_distance' => 1}
    @tm.match_matches(gmatch, smatch).should == {'phonetic_match'=>false, 'edit_distance'=>2, 'match'=>false}
    #Should not match if binomial edit distance > 4 NOTE: EVEN with full phonetic match
    gmatch = {'match' => true, 'phonetic_match' => true, 'edit_distance' => 3}
    smatch = {'match' => true, 'phonetic_match' => true, 'edit_distance' => 2}
    @tm.match_matches(gmatch, smatch).should == {'phonetic_match'=>true, 'edit_distance'=>5, 'match'=>false}
    #Should not have phonetic match if one of the components does not match phonetically
    gmatch = {'match' => true, 'phonetic_match' => false, 'edit_distance' => 1}
    smatch = {'match' => true, 'phonetic_match' => true, 'edit_distance' => 1}
    @tm.match_matches(gmatch, smatch).should == {'phonetic_match'=>false, 'edit_distance'=>2, 'match'=>true}
    gmatch = {'match' => true, 'phonetic_match' => true, 'edit_distance' => 1}
    smatch = {'match' => true, 'phonetic_match' => false, 'edit_distance' => 1}
    @tm.match_matches(gmatch, smatch).should == {'phonetic_match'=>false, 'edit_distance'=>2, 'match'=>true}
    #edit distance should be equal the sum of of edit distances
    gmatch = {'match' => true, 'phonetic_match' => true, 'edit_distance' => 2}
    smatch = {'match' => true, 'phonetic_match' => true, 'edit_distance' => 2}
    @tm.match_matches(gmatch, smatch).should == {'phonetic_match'=>true, 'edit_distance'=>4, 'match'=>true}
  end

  it 'should return only boolean values' do
    @tm.taxamatch("AJLJljljlj", "sls").should_not be_nil
    @tm.taxamatch('Olsl','a')
  end


  describe 'Taxamatch::Authmatch' do
    before(:all) do
      @am = Taxamatch::Authmatch
    end

    it 'should calculate score' do
      res = @am.authmatch(['Linnaeus', 'Muller'], ['L'], [], [1788])
      res.should == 90
      res = @am.authmatch(['Linnaeus'],['Kurtz'], [], [])
      res.should == 0
      #found all authors, same year
      res = @am.authmatch(['Linnaeus', 'Muller'], ['Muller', 'Linnaeus'], [1766], [1766])
      res.should == 100
      #all authors, 1 year diff
      res = @am.authmatch(['Linnaeus', 'Muller'], ['Muller', 'Linnaeus'], [1767], [1766])
      res.should == 54
      #year is not counted in
      res = @am.authmatch(['Linnaeus', 'Muller'], ['Muller', 'Linnaeus'], [1767], [])
      res.should == 94
      #found all authors on one side, same year
      res = @am.authmatch(['Linnaeus', 'Muller', 'Kurtz'], ['Muller', 'Linnaeus'], [1767], [1767])
      res.should == 91
      #found all authors on one side, 1 year diff
      res = @am.authmatch(['Linnaeus', 'Muller', 'Kurtz'], ['Muller', 'Linnaeus'], [1766], [1767])
      res.should == 51
      #found all authors on one side, year does not count
      res = @am.authmatch(['Linnaeus', 'Muller'], ['Muller', 'Linnaeus', 'Kurtz'], [1766], [])
      res.should == 90
      #found some authors
      res = @am.authmatch(['Stepanov', 'Linnaeus', 'Muller'], ['Muller', 'Kurtz', 'Stepanov'], [1766], [])
      res.should == 67
      #if year does not match or not present no match for previous case
      res = @am.authmatch(['Stepanov', 'Linnaeus', 'Muller'], ['Muller', 'Kurtz', 'Stepanov'], [1766], [1765])
      res.should == 0
    end

    it 'should compare years' do
      @am.compare_years([1882],[1880]).should == 2
      @am.compare_years([1882],[]).should == nil
      @am.compare_years([],[]).should == 0
      @am.compare_years([1788,1798], [1788,1798]).should be_nil
    end

    it 'should remove duplicate authors' do
      #Li submatches Linnaeus and it its size 3 is big enought to remove Linnaeus
      #Muller is identical
      res = @am.remove_duplicate_authors(['Lin', 'Muller'], ['Linnaeus', 'Muller'])
      res.should == [[], []]
      #same in different order
      res = @am.remove_duplicate_authors(['Linnaeus', 'Muller'], ['Linn', 'Muller'])
      res.should == [[], []]
      #auth Li submatches Linnaeus, but Li size less then 3 required to remove Linnaeus
      res = @am.remove_duplicate_authors(['Dem', 'Li'], ['Linnaeus', 'Stepanov'])
      res.should == [["Dem"], ["Linnaeus", "Stepanov"]]
      #fuzzy match
      res = @am.remove_duplicate_authors(['Dem', 'Lennaeus'], ['Linnaeus', 'Stepanov'])
      res.should == [["Dem"], ["Stepanov"]]
      res = @am.remove_duplicate_authors(['Linnaeus', 'Muller'], ['L', 'Kenn'])
      res.should == [['Linnaeus', 'Muller'], ['Kenn']]
      res = @am.remove_duplicate_authors(['Linnaeus', 'Muller'], ['Muller', 'Linnaeus', 'Kurtz'])
      res.should == [[],['Kurtz']]
    end

    it 'should fuzzy match authors' do
      #TODO: fix the bug revealed by this test
      # res = @am.fuzzy_match_authors('L', 'Muller')
      # res.should be_false
    end

  end

end


