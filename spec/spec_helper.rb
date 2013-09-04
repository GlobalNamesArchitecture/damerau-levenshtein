require 'coveralls'
Coveralls.wear!

require 'rspec'
require 'damerau-levenshtein'

def read_test_file(file, fields_num)
  f = open(file)
  f.each do |line|
    fields = line.split("|")
    if line.match(/^\s*#/) == nil && fields.size == fields_num
      fields[-1] = fields[-1].split('#')[0].strip
      yield(fields)
    else
      yield(nil)
    end
  end
end
