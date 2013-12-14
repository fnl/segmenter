#!/usr/bin/env perl

# this script scans for dictionary terms (first column) in the input and prints the number of hits for each mapped value together with the relevant term (other columns)

# Auhtor: Florian Leitner <florian.leitner@gmail.com>
# (C) 2013. All rights reserved.
# License: Apache License v2 <https://www.apache.org/licenses/LICENSE-2.0.html>

use strict;
use File::Basename;
my $prog = basename($0);
if ($#ARGV < 0 || $ARGV[0] =~/-h|--help/) {
  print STDERR "usage: $prog DICTIONARY_TSV < TOKENS > HITS\n";
  exit 1;
}

use List::Util qw( max );
use Text::Scan;
use open ':locale';
use utf8;

my %counts;
my $dict = new Text::Scan;
open my $handle, '<', shift || die "could not open COMPOSITES file: $!";
$dict->ignore(" ._-");  # IGNORE 1/2

foreach (<$handle>) {
  chomp;
  my @items = split /\t/;
  $_ = shift(@items);
  tr/ _.-//d;  # IGNORE 2/2
  for my $ref (@items) {
    $counts{$ref} = {};
  }
  if ($dict->has($_)) {
    my $ref_items = $dict->val($_);
    @items = (@$ref_items, @items);
  }
  $dict->insert($_, \@items);
}

close $handle;

while (<>) {
  my @hits = $dict->scan($_);
  for (my $i = 0; $i <= $#hits; $i += 2) {
    my $term = $hits[$i];
    for my $item (@{$hits[$i+1]}) {
      $counts{$item}{$term}++;
    }
  }
}

foreach my $hit (keys %counts) {
  foreach my $term (keys %{$counts{$hit}}) {
    print "$hit\t$term\t$counts{$hit}{$term}\n";
  }
}
