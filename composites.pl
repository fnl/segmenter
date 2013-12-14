#!/usr/bin/env perl

# this script extracts composite tokens of the form "T1_T2", "T1.T2" and "T1-T2"

# Auhtor: Florian Leitner <florian.leitner@gmail.com>
# (C) 2013. All rights reserved.
# License: Apache License v2 <https://www.apache.org/licenses/LICENSE-2.0.html>

use File::Basename;
my $prog = basename($0);
if ($#ARGV == 0 && $ARGV[0] =~/-h|--help/) {
  print STDERR "usage: $prog < TOKENS > TOKENS\n";
  exit 1;
}

use open ':locale';

while (<>) {
  if (/[_.-]/) {
    @words = split;
    foreach (@words) {
      print "$_\n" if (/[\p{L}\p{N}][_.-][\p{L}\p{N}]/); 
    }
  }
}
