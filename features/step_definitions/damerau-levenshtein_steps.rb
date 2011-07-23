Given /^strings "([^\"]*)" and "([^\"]*)", block size "([^\"]*)", and a maximum allowed distance "([^\"]*)"$/ do |str1, str2, block_size, max_distance|
  @str1 = str1
  @str2 = str2
  @block_size = block_size.to_i
  @max_distance = max_distance.to_i
end

When /^I run "([^\"]*)" instance function "([^\"]*)"$/ do |klass, meth|
  dl = eval(klass + ".new")
  @distance = dl.distance(@str1, @str2, @block_size, @max_distance)
end

Then /^I should receive edit distance "([^\"]*)"$/ do |edit_distance|
  @distance.should == edit_distance.to_i
end
