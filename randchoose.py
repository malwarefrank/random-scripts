#!/usr/bin/env python

import sys
import random

prob = float(sys.argv[1])

for line in sys.stdin:
    if random.random() <= prob:
        sys.stdout.write(line)
