#!/usr/bin/env perl

# this script (Snowball) stems tokens if the token is all lower-case

# Auhtor: Florian Leitner <florian.leitner@gmail.com>
# (C) 2013. All rights reserved.
# License: Apache License v2 <https://www.apache.org/licenses/LICENSE-2.0.html>

use File::Basename;
my $prog = basename($0);
if ($#ARGV == 0 && $ARGV[0] =~/-h|--help/) {
  print STDERR "usage: $prog < TOKENS > STEMMED_TOKENS\n";
  exit 1;
}

use open ':locale';
use Lingua::Stem::Snowball;
my $stemmer = Lingua::Stem::Snowball->new( lang => 'en' );

while (<>) {
  my @words = split;
  if (/[A-Z]/) {
    for my $i (0..$#words) {
      if ($words[$i] =~ /^[a-z]{2,}$/) {$words[$i] = $stemmer->stem($words[$i]);}
    }
  } else {
    $stemmer->stem_in_place(\@words);
  }
  print "@words\n";
}
