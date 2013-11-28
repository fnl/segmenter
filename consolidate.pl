#!/usr/bin/env perl

# this script prints mappings for composite tokens from infrequent to the most frequent forms 

# For example, given the token "quasi-experimental", it determines its own frequency as well
# as those of "quasi experimental" and "quasiexperimental". Mappings from any non-zero, but
# less frequent form to the most frequent form is printed. That means that if no mapping for
# a starting composite token is printed, the token either does not exist in the text or the
# two alternative forms were not present.

# Auhtor: Florian Leitner <florian.leitner@gmail.com>
# (C) 2013. All rights reserved.
# License: Apache License v2 <https://www.apache.org/licenses/LICENSE-2.0.html>

use strict;
use File::Basename;
my $prog = basename($0);
if ($#ARGV != 1 || $ARGV[0] =~/-h|--help/) {
  print STDERR "usage: $prog [UNIQ]COMPOSITES < TOKENS > TSV_MAPPINGS\n";
  exit 1;
}

use List::Util qw( max );
use Text::Scan;
use open ':locale';
use utf8;

my @composites;
my %counts;
my $path = shift;
my $outfile = shift;
my $dict = new Text::Scan;
my $mappings = new Text::Scan;
open my $handle, '<', $path || die "could not open COMPOSITES at $path: $!";

foreach (<$handle>) {
  chomp;
  push(@composites, $_);
  $_ = " $_ ";
  # com-posite
  $dict->insert($_, 0);
  $counts{$_} = 0;
  tr/_-/  /;
  # token ized
  $dict->insert($_, 0);
  $counts{$_} = 0;
  tr/ //d;
  $_ = " $_ ";
  # unigram
  $dict->insert($_, 0);
  $counts{$_} = 0;
}

my %dump = $dict->dump();
close $handle;

while (<>) {
  chomp;
  $_ = " $_ ";
  foreach my $hit ($dict->scan($_)) {
    if ($hit) {
      $hit =~ s/^ //;
      $hit =~ s/ $//;
      $counts{$hit}++;
    }
  }
}

sub showIf {
  my $to = shift;
  my $max = shift;

  if ($counts{$to} == $max) {
    my $from1 = shift;
    my $from2 = shift;
    print "$from1\t$to\n" if ($counts{$from1} > 0);
    print "$from2\t$to\n" if ($counts{$from2} > 0);
    return 1;
  } else {
    return 0;
  }
}

foreach my $composite (@composites) {
  (my $tokenized = $composite) =~ tr/_-/  /;
  (my $unigram = $composite) =~ tr/_-//d;
  my $max = max($counts{$tokenized}, $counts{$unigram}, $counts{$composite});
  unless (showIf($composite, $max, $unigram,   $tokenized)) {
    unless (showIf($unigram,   $max, $composite, $tokenized)) {
      showIf($tokenized, $max, $unigram,   $composite);
    }
  }
}
