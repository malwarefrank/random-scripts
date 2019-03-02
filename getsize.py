#!/usr/bin/env python

import os
import sys

for line in sys.stdin:
    line = line.rstrip("\r\n")
    print(os.path.getsize(line))
