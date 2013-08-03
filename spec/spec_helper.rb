$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'coveralls'
require 'damerau-levenshtein'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  
end

Coveralls.wear!

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
