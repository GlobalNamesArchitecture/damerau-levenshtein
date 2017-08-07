# damerau-levenshtein #

[![Gem Version][gem_svg]][gem]
[![Continuous Integration Status][ci_svg]][ci]
[![Dependency Status][dep_svg]][dep]
[![Coverage Status][cov_svg]][cov]

The damerau-levenshtein gem allows to find [edit distance][ed] between two
UTF-8 or ASCII encoded strings with O(N\*M) efficiency.

This gem implements pure Levenshtein algorithm, Damerau modification of it
(where 2 character transposition counts as 1 edit distance). It also includes
Boehmer & Rees 2008 modification of Damerau algorithm, where transposition
of bigger than 1 character blocks is taken in account as well

It also returns a diff between two strings according to Levenshtein alrorithm.
The diff is expressed by tags `<ins>`, `<del>`, and `<subst>`

[(Rees 2014)][rees2014].

```ruby
require "damerau-levenshtein"
DamerauLevenshtein.distance("Something", "Smoething") #returns 1
```

Gem damerau-levenshtein is compatible with ruby versions 1.8.7
and 1.9.2 and higher, as well as 2.0.0 and higher

## Dependencies ##

    sudo apt-get install build-essential libgmp3-dev

## Installation ##

    gem install damerau-levenshtein

## Examples ##

```ruby
require "damerau-levenshtein"
dl = DamerauLevenshtein
```

* compare using Damerau Levenshtein algorithm

```ruby
dl.distance("Something", "Smoething") #returns 1
```

* compare using Levensthein algorithm

```ruby
dl.distance("Something", "Smoething", 0) #returns 2
```

* compare using Boehmer & Rees modification

```ruby
dl.distance("Something", "meSothing", 2) #returns 2 instead of 4
```

* comparison of words with utf-8 characters should work fine:

```ruby
dl.distance("Sjöstedt", "Sjostedt") #returns 1
```

* compare two arrays

```ruby
dl.array_distance([1,2,3,5], [1,2,3,4]) #returns 1
```

* return diff between two strings

differ = DamerauLevenshtein::Differ.new
differ.run("Something", "smthg")

* return diff between two strings in raw format

differ = DamerauLevenshtein::Differ.new
differ.format = :raw
differ.run("Something", "smthg")

## API Description ##

### Methods ###

```ruby
DamerauLevenshtein.version
#returns version number of the gem

DamerauLevenshtein.distance(string1, string2, block_size, max_distance)
#returns edit distance between 2 strings

DamerauLevenshtein.string_distance(string1, string2, block_size, max_distance)
# an alias for .distance

DamerauLevenshtein.array_distance(array1, array2, block_size, max_distance)
# returns edit distance between 2 arrays of integers
```

`DamerauLevenshtein.distance` and `.array_distance` take 4 arguments:

* `string1` (`array1` for `.array_distance`)
* `string2` (`array2` for `.array_distance`)
* `block_size` (default is 1)
* `max_distance` (default is 10)

`block_size` determines maximum number of characters in a transposition block:

    block_size = 0
    (transposition does not count -- it is a pure Levenshtein algorithm)

    block_size = 1
    (transposition between 2 adjustent characters --
    it is pure Damerau-Levenshtein algorithm)

    block_size = 2
    (transposition between blocks as big as 2 characters -- so abcd and cdab
    counts as edit distance 2, not 4)

    block_size = 3
    (transposition between blocks as big as 3 characters --
    so abcdef and defabc counts as edit distance 3, not 6)

    etc.

`max_distance` -- is a threshold after which algorithm gives up and
returns max_distance instead of real edit distance.

Levenshtein algorithm is expensive, so it makes sense to give up when edit
distance is becoming too big. The argument max_distance does just that.

```ruby

DamerauLevenshtein.distance("abcdefg", "1234567", 0, 3)
# output: 4 -- it gave up when edit distance exceeded 3

```

`differ = DamerauLevenshtein::Differ.new` creates an instance of new differ class to return difference between two strings

`differ.format` shows current format for diff. Default is `:tag` format

`differ.format = :raw` changes current format for diffs. Possible values are `:tag` and `:raw`

`differ.run("String1", "String2")` returns difference between two strings.

For example:

```ruby
differ = DamerauLevenshtein::Differ.new
differ.run("Something", "smthng")
# output: ["<ins>S</ins><subst>o</subst>m<ins>e</ins>th<ins>i</ins>ng",
#          "<del>S</del><subst>s</subst>m<del>e</del>th<del>i</del>ng"]

```


## Contributing to damerau-levenshtein ##

* Check out the latest master to make sure the feature hasn't been
  implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested
  it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it
  in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want
  to have your own version, or is otherwise necessary, that is fine, but please
  isolate to its own commit so I can cherry-pick around it.

## Versioning ##

This gem is following practices of [Semantic Versioning][semver]

## Authors ##

[Dmitry Mozzherin][dimus]

## Contributors ##

[lazylester][lazylester], [Ran Xie][skarlit], [Alexey Zapparov][ixti], [azhi][azhi]

## Copyright ##

Copyright (c) 2011-2016 Dmitry Mozzherin. See LICENSE.txt for
further details.

[gem_svg]: https://badge.fury.io/rb/damerau-levenshtein.svg
[gem]: http://badge.fury.io/rb/damerau-levenshtein
[ci_svg]: https://secure.travis-ci.org/GlobalNamesArchitecture/damerau-levenshtein.svg
[ci]: http://travis-ci.org/GlobalNamesArchitecture/damerau-levenshtein
[dep_svg]: https://gemnasium.com/GlobalNamesArchitecture/damerau-levenshtein.svg
[dep]: https://gemnasium.com/GlobalNamesArchitecture/damerau-levenshtein
[cov_svg]: https://coveralls.io/repos/GlobalNamesArchitecture/damerau-levenshtein/badge.svg?branch=master
[cov]: https://coveralls.io/r/GlobalNamesArchitecture/damerau-levenshtein?branch=master
[ed]: http://en.wikipedia.org/wiki/Edit_distance
[semver]: http://semver.org/
[dimus]: https://github.com/dimus
[lazylester]: https://github.com/lazylester
[skarlit]: https://github.com/Skarlit
[ixti]: https://github.com/ixti
[azhi]: https://github.com/azhi
[rees2014]: https://dx.doi.org/10.1371/journal.pone.0107510
