#!/usr/bin/env perl

# this script (Snowball) stems tokens if the token is all lower-case

# Auhtor: Florian Leitner <florian.leitner@gmail.com>
# (C) 2013. All rights reserved.
# License: Apache License v2 <https://www.apache.org/licenses/LICENSE-2.0.html>

use 5.012;
use encoding 'utf8', STDIN => 'utf8', STDOUT => 'utf8';
use File::Basename;

#use local::lib "~/perl5/lib/perl5";
use Lingua::Stem::Snowball;
my $stemmer = Lingua::Stem::Snowball->new( lang => 'en' );

my $prog = basename($0);

if ($#ARGV == 0 && $ARGV[0] =~/-h|--help/) {
  print STDERR "usage: $prog < TOKENS > STEMMED_TOKENS\n";
  exit 1;
}

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
