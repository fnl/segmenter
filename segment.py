#!/usr/bin/env python3

# this script segments text into sentences given a probabilistic model (from train.py)

# Auhtor: Florian Leitner <florian.leitner@gmail.com>
# (C) 2013. All rights reserved.
# License: Apache License v2 <https://www.apache.org/licenses/LICENSE-2.0.html>

import pickle
import sys

from os.path import basename
from nltk.tokenize.punkt import PunktSentenceTokenizer

if len(sys.argv) == 2 and sys.argv[1] in ('-h', '--help'):
    print('usage: {} PARAMS < TEXT > SENTENCES'.format(basename(sys.argv[0])))
    sys.exit(1)

with open(sys.argv[1], 'rb') as f:
    params = pickle.load(f)

pst = PunktSentenceTokenizer(params)

for text in sys.stdin:
    for sentence in pst.tokenize(text.strip()):
        if sentence:
            print(sentence)
