# Loads mkmf which is used to make makefiles for Ruby extensions
require 'mkmf'

# The destination
dir_config('damerau_levenshtein')

# Do the work
create_makefile('damerau_levenshtein/damerau_levenshtein_binding')
