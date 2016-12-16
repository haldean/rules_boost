#!/bin/bash
set -eu

# Generates a boost_library rule given an estimate of the deps, pulled from
# #include statements. The deps are often slightly wrong, but it's a good
# starting point; it rarely misses things, and often adds things like "lib_fwd"
# and "lib", when really you just need "lib".

SRC=${1:-.}
echo reading from $SRC
grep -R --no-filename '#include' $SRC \
    | grep -v '//' \
    | grep '[<"]boost' \
    | cut -f2 -d/ \
    | sed -s 's/[\./].*$//' \
    | sort \
    | uniq \
    | grep -v $(basename $PWD) \
    | awk 'BEGIN { print "boost_library(\n  name = \"\",\n  deps = [" } { print "    \":" $0 "\"," } END { print "  ],\n)" } '

