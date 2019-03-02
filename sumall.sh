#!/bin/bash

NALL=0
while read n; do
    NALL=$((NALL+n))
done
echo $NALL
