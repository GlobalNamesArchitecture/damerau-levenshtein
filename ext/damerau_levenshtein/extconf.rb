# Loads mkmf which is used to make makefiles for Ruby extensions
require 'mkmf'

# The destination
dir_config('damerau-levenshtein/damerau_levenshtein')

# Do the work
create_makefile('damerau-levenshtein/damerau_levenshtein')
