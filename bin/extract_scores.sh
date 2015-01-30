#!/bin/sh

tabula data/scores.pdf -p 7-24 --spreadsheet | \
  awk '/^HMCA/ { if(NR==1) print $0 } /^[0-9]/ { print $0 } /^AVL[0-9]/ { print $0 }' > data/scores.csv
