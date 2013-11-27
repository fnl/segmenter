#!/usr/bin/env perl

# this script tokenizes sentences into word-level tokens

# Auhtor: Florian Leitner <florian.leitner@gmail.com>
# (C) 2013. All rights reserved.
# License: Apache License v2 <https://www.apache.org/licenses/LICENSE-2.0.html>

use File::Basename;
my $prog = basename($0);
if ($#ARGV == 0 && $ARGV[0] =~/-h|--help/) {
  print STDERR "usage: $prog [--normal] < SENTENCES > TOKENS\n";
  exit 1;
}

use charnames 'greek';
use open ':locale';

my $NORMAL = ($#ARGV > -1 && $ARGV[0] =~ '--normal');
shift @ARGV if ($#ARGV > -1 && $ARGV[0] =~ '--normal');

while (<>) {
  # debugging output
  #print "--------------------------\n";
  #print;

  # decode a few infrequently contaminating XML entities
  s/&amp;/&/g;
  s/&lt;/</g;
  s/&gt;/>/g;
  s/&nbsp;/ /g;

  # fix common "impurities"
  s/<\/?\w+>//g;  # remove infrequent HTML tag "contamination"
  s/'s\b//g;  # drop apostrophe-s
  s/n't\b/ not/g;  # fix "...n't" contractions

  # basic space normalization
  s/[\t\xA0_]/ /g;

  # translate Greek letters to latin names
  s/\N{alpha}/alpha/g;
  s/\N{beta}/beta/g;
  s/\N{gamma}/gamma/g;
  s/\N{delta}/delta/g;
  s/\N{epsilon}/epsilon/g;
  s/\N{zeta}/zeta/g;
  s/\N{eta}/eta/g;
  s/\N{theta}/theta/g;
  s/\N{iota}/iota/g;
  s/\N{kappa}/kappa/g;
  s/\N{lamda}/lamda/g;
  s/\N{mu}/mu/g;
  s/\N{nu}/nu/g;
  s/\N{xi}/xi/g;
  s/\N{omicron}/omicron/g;
  s/\N{pi}/pi/g;
  s/\N{rho}/rho/g;
  s/\N{final sigma}/sigma/g;
  s/\N{sigma}/sigma/g;
  s/\N{tau}/tau/g;
  s/\N{upsilon}/upsilon/g;
  s/\N{phi}/phi/g;
  s/\N{chi}/chi/g;
  s/\N{psi}/psi/g;
  s/\N{omega}/omega/g;
  # uppercase
  s/\N{Alpha}/Alpha/g;
  s/\N{Beta}/Beta/g;
  s/\N{Gamma}/Gamma/g;
  s/\N{Delta}/Delta/g;
  s/\N{Epsilon}/Epsilon/g;
  s/\N{Zeta}/Zeta/g;
  s/\N{Eta}/Eta/g;
  s/\N{Theta}/Theta/g;
  s/\N{Iota}/Iota/g;
  s/\N{Kappa}/Kappa/g;
  s/\N{Lamda}/Lamda/g;
  s/\N{Mu}/Mu/g;
  s/\N{Nu}/Nu/g;
  s/\N{Xi}/Xi/g;
  s/\N{Omicron}/Omicron/g;
  s/\N{Pi}/Pi/g;
  s/\N{Rho}/Rho/g;
  s/\N{Sigma}/Sigma/g;
  s/\N{Tau}/Tau/g;
  s/\N{Upsilon}/Upsilon/g;
  s/\N{Phi}/Phi/g;
  s/\N{Chi}/Chi/g;
  s/\N{Psi}/Psi/g;
  s/\N{Omega}/Omega/g;

  # TOKENIZATION:
  # separate alphanumeric, numeric, and symbolic tokens
  s/((?:\p{L}[\p{L}\p{N}\.-]*)|(?<!\p{N})-?\p{N}+(?:[\.,]\p{N}+)*|\S)/\1 /g;
  # clean-up: separate trailing dots and dashes in alphanumeric tokens
  s/(\p{L}[\p{L}\p{N}\.-]*)([\.-]) /\1 \2 /g;

  if ($NORMAL) {
    s/ [\.-] / /g;  # remove "lone" dot and slash tokens
    $_=lc;  # lower-case all text
  }

  # clean up the resulting space mess
  s/ {2,}/ /g;
  s/^ //;
  s/ \n$/\n/;


  print;
}
