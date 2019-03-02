#!/bin/bash

DOHEX=0

if [ "$1" == "-x" ]; then
  DOHEX=1
  shift
fi

if command -v od >/dev/null; then
  echo -n
else
  echo "od command not found, is it installed?"
  exit
fi

if [ "$1" == "" ]; then
    echo "syntax:  $0 INFILE"
    echo "    Show histogram of bytes in file, top ten"
    exit
fi

OUT_FORMAT='-td1'
if [ $DOHEX -eq 1 ]; then
  OUT_FORMAT='-tx1'
fi

od -v $OUT_FORMAT -An -w1 "$1" | sort -n | uniq -c | sort -n | tail
