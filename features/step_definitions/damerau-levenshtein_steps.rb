str1 = str2 = with_damerau = max_distance = distance = dl = nil

Given /^strings "([^\"]*)" and "([^\"]*)", with_damerau "([^\"]*)", and a maximum allowed distance "([^\"]*)"$/ do |a,b,c,d|
  str1 = a
  str2 = b
  with_damerau = (c == "true") ? true : false
  max_distance = d.to_i
end

When /^I run "([^\"]*)" instance function "([^\"]*)"$/ do |arg1, arg2|
  dl = eval(arg1 + ".new")
  require 'ruby-debug'; debugger
  distance = dl.distance(str1, str2, {:with_damerau => with_damerau, :max_distance => max_distance})
end

Then /^I should receive edit distance "([^\"]*)"$/ do |arg1|
  distance.should == arg1.to_i
end
