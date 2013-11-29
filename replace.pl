#!/usr/bin/env perl

# this script replaces mapped terms in a text

# Auhtor: Florian Leitner <florian.leitner@gmail.com>
# (C) 2013. All rights reserved.
# License: Apache License v2 <https://www.apache.org/licenses/LICENSE-2.0.html>

use strict;
use File::Basename;
my $prog = basename($0);
if ($#ARGV < 0 || $ARGV[0] =~/-h|--help/) {
  print STDERR "usage: $prog TSV_MAPPINGS < TOKENS > MAPPED_TOKENS\n";
  exit 1;
}

use Text::Scan;
use open ':locale';
use utf8;

my $mappings = new Text::Scan;
my $path = shift;
open my $handle, '<', $path || die "could not open MAPPINGS at $path: $!";

foreach (<$handle>) {
  chomp;
  $mappings->insert(split(/\t/, $_));
}

close $handle;

while (<>) {
  my %hits = $mappings->scan($_);
  while ((my $from, my $to) = each %hits) {
    s/\b$from\b/$to/g;
  }
  print;
}
