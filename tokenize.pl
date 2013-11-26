#!/usr/bin/env perl

# this script tokenizes sentences into word-level tokens

# Auhtor: Florian Leitner <florian.leitner@gmail.com>
# (C) 2013. All rights reserved.
# License: Apache License v2 <https://www.apache.org/licenses/LICENSE-2.0.html>

use 5.012;
use encoding 'utf8', STDIN => 'utf8', STDOUT => 'utf8';
use charnames ':full';
use File::Basename;

my $prog = basename($0);

if ($#ARGV == 0 && $ARGV[0] =~/-h|--help/) {
  print STDERR "usage: $prog < SENTENCES > TOKENS\n";
  exit 1;
}

while (<>) {
  # debugging output
  #print "--------------------------\n";
  #print;

  # decode a few infrequently contaminating XML entities
  s/&amp;/&/g;
  s/&lt;/</g;
  s/&gt;/>/g;
  s/&nbsp;/ /g;

  # basic space normalization
  s/\t/ /g;  # normalize tabs to spaces
  s/\xa0/ /g;  # normalize non-breaking spaces to spaces
  s/_/ /g; # normalize underscores to spaces
  s/^ +//;  # remove initial spaces

  # fix common "impurities"
  s/<\/?\w+>//g;  # remove infrequent HTML tag "contamination"
  s/'s\b//g;  # drop apostrophe-s
  s/n't\b/ not/g;  # fix "...n't" contractions

  # lower-case capitalized words at line (sentence) start
  if (/^\p{Lu}\p{Ll}*\b/) {$_=lcfirst;}

  # translate Greek letters to latin names
  s/\N{GREEK SMALL LETTER ALPHA}      /alpha/xg;
  s/\N{GREEK SMALL LETTER BETA}       /beta/xg;
  s/\N{GREEK SMALL LETTER GAMMA}      /gamma/xg;
  s/\N{GREEK SMALL LETTER DELTA}      /delta/xg;
  s/\N{GREEK SMALL LETTER EPSILON}    /epsilon/xg;
  s/\N{GREEK SMALL LETTER ZETA}       /zeta/xg;
  s/\N{GREEK SMALL LETTER ETA}        /eta/xg;
  s/\N{GREEK SMALL LETTER THETA}      /theta/xg;
  s/\N{GREEK SMALL LETTER IOTA}       /iota/xg;
  s/\N{GREEK SMALL LETTER KAPPA}      /kappa/xg;
  s/\N{GREEK SMALL LETTER LAMDA}      /lamda/xg;
  s/\N{GREEK SMALL LETTER MU}         /mu/xg;
  s/\N{GREEK SMALL LETTER NU}         /nu/xg;
  s/\N{GREEK SMALL LETTER XI}         /xi/xg;
  s/\N{GREEK SMALL LETTER OMICRON}    /omicron/xg;
  s/\N{GREEK SMALL LETTER PI}         /pi/xg;
  s/\N{GREEK SMALL LETTER RHO}        /rho/xg;
  s/\N{GREEK SMALL LETTER FINAL SIGMA}/sigma/xg;
  s/\N{GREEK SMALL LETTER SIGMA}      /sigma/xg;
  s/\N{GREEK SMALL LETTER TAU}        /tau/xg;
  s/\N{GREEK SMALL LETTER UPSILON}    /upsilon/xg;
  s/\N{GREEK SMALL LETTER PHI}        /phi/xg;
  s/\N{GREEK SMALL LETTER CHI}        /chi/xg;
  s/\N{GREEK SMALL LETTER PSI}        /psi/xg;
  s/\N{GREEK SMALL LETTER OMEGA}      /omega/xg;
  # uppercase
  s/\N{GREEK CAPITAL LETTER ALPHA}    /Alpha/xg;
  s/\N{GREEK CAPITAL LETTER BETA}     /Beta/xg;
  s/\N{GREEK CAPITAL LETTER GAMMA}    /Gamma/xg;
  s/\N{GREEK CAPITAL LETTER DELTA}    /Delta/xg;
  s/\N{GREEK CAPITAL LETTER EPSILON}  /Epsilon/xg;
  s/\N{GREEK CAPITAL LETTER ZETA}     /Zeta/xg;
  s/\N{GREEK CAPITAL LETTER ETA}      /Eta/xg;
  s/\N{GREEK CAPITAL LETTER THETA}    /Theta/xg;
  s/\N{GREEK CAPITAL LETTER IOTA}     /Iota/xg;
  s/\N{GREEK CAPITAL LETTER KAPPA}    /Kappa/xg;
  s/\N{GREEK CAPITAL LETTER LAMDA}    /Lamda/xg;
  s/\N{GREEK CAPITAL LETTER MU}       /Mu/xg;
  s/\N{GREEK CAPITAL LETTER NU}       /Nu/xg;
  s/\N{GREEK CAPITAL LETTER XI}       /Xi/xg;
  s/\N{GREEK CAPITAL LETTER OMICRON}  /Omicron/xg;
  s/\N{GREEK CAPITAL LETTER PI}       /Pi/xg;
  s/\N{GREEK CAPITAL LETTER RHO}      /Rho/xg;
  s/\N{GREEK CAPITAL LETTER SIGMA}    /Sigma/xg;
  s/\N{GREEK CAPITAL LETTER TAU}      /Tau/xg;
  s/\N{GREEK CAPITAL LETTER UPSILON}  /Upsilon/xg;
  s/\N{GREEK CAPITAL LETTER PHI}      /Phi/xg;
  s/\N{GREEK CAPITAL LETTER CHI}      /Chi/xg;
  s/\N{GREEK CAPITAL LETTER PSI}      /Psi/xg;
  s/\N{GREEK CAPITAL LETTER OMEGA}    /Omega/xg;

  # join word-word (dash) where one word may be a number
  s/(\p{L})-([\p{L}\p{N}])/\1\2/g;
  s/(\p{N})-(\p{L})/\1\2/g;

  # TOKENIZATION:
  # separate word, symbol and number tokens
  s/(\p{L}+|\p{N}+(?:[\.,]\p{N}+)*|\S)/ \1 /g;

  s/ \. / /g;  # remove "lone" dot tokens

  # clean up remaining space mess
  s/ {2,}/ /g;
  s/^ //;
  s/ \n$/\n/;

  print;
}
