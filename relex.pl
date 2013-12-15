#!/usr/bin/env perl

# extract sentences containing co-ocurrences between two terms as defined by pairs of term IDs

# Auhtor: Florian Leitner <florian.leitner@gmail.com>
# (C) 2013. All rights reserved.
# License: Apache License v2 <https://www.apache.org/licenses/LICENSE-2.0.html>

use strict;
use File::Basename;
my $prog = basename($0);
if ($#ARGV < 0 || $ARGV[0] =~/-h|--help/) {
  print STDERR "usage: $prog TERMID_TERMS_TSV TERMID_PAIRS < SENTENCES > HITS\n";
  exit 1;
}

use List::Util qw( max );
use Text::Scan;
use open ':locale';
use utf8;

my %pairs;
my %term_a_ids;
my %term_b_ids;
my $dict_a = new Text::Scan;
my $dict_b = new Text::Scan;
open my $term_dict, '<', shift || die "could not open TERMID_TERMS_TSV file: $!";
$dict_a->ignore(" ._-");  # IGNORE 1/2
$dict_b->ignore(" ._-");  # IGNORE 1/2
open my $term_pairs, '<', shift || die "could not open TERMID_PAIRS file: $!";

foreach (<$term_pairs>) {
  chomp;
  my @items = split /\t/;
  print STDERR "adding pair: $items[0] <-> $items[1]\n";
  $pairs{$_}++;
  $term_a_ids{$items[0]}++;
  print STDERR "adding term id a: $items[0]\n";
  $term_b_ids{$items[1]}++;
  print STDERR "adding term id b: $items[1]\n";
}

close $term_pairs;

sub expandDict {
  my $dict = shift;
  my $term_id = shift;
  my $ref_terms = shift;

  foreach my $term (@$ref_terms) {
    $term =~ tr/ _.-//d;  # IGNORE 2/2

    if ($dict->has($term)) {
      my $ref_ids = $dict->val($term);

      unless (grep(/^$term_id$/,  @$ref_ids)) {
        push @$ref_ids, $term_id; 
      }
    } else {
      my @term_ids = ($term_id);
      $dict->insert($term, \@term_ids);
    }
  }
}

foreach (<$term_dict>) {
  chomp;
  my @terms = split /\t/;
  my $term_id = shift(@terms);

  if (exists $term_a_ids{$term_id}) {
    print STDERR "adding term a: $term_id -> @terms\n";
    expandDict($dict_a, $term_id, \@terms);
  }

  if (exists $term_b_ids{$term_id}) {
    print STDERR "adding term b: $term_id -> @terms\n";
    expandDict($dict_b, $term_id, \@terms);
  }
}

close $term_dict;

while (<>) {
  chomp;
  my $line = $_;
  my @hits_a = $dict_a->scan($line);

  if ($#hits_a != -1) {
    my @hits_b = $dict_b->scan($line);

    for (my $a = 0; $a <= $#hits_a; $a += 2) {
      my $term_a = $hits_a[$a];
      my $ref_ids_a = $hits_a[$a+1];

      for (my $b = 0; $b <= $#hits_b; $b += 2) {
        my $term_b = $hits_b[$b];
        my $ref_ids_b = $hits_b[$b+1];

        for my $id_a (@$ref_ids_a) {
          for my $id_b (@$ref_ids_b) {
            if (exists $pairs{"$id_a\t$id_b"}) {
              print "$line\t$id_a\t$term_a\t$id_b\t$term_b\n";
            }
          }
        }
      }
    }
  }
}
