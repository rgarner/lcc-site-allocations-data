#!/bin/sh

tabula data/1.\ Aireborough\ A3\ Inc\ Site\ Schedule.pdf -p 1-4,6-9 --spreadsheet | grep '^[0-9]\|^HLA' > data/1.csv
tabula data/2.\ City\ Centre\ A3\ Inc\ Site\ Schedule.pdf -p 2-13 --spreadsheet   | grep '^[0-9]\|^HLA' > data/2.csv
tabula data/3.\ East\ Leeds\ A3\ Inc\ Site\ Schedule.pdf -p 2-7 --spreadsheet     | grep '^[0-9]\|^HLA' > data/3.csv
tabula data/4.\ Inner\ Area\ A3\ Inc\ Site\ Schedule.pdf -p 2-17 --spreadsheet    | grep '^[0-9]\|^HLA' > data/4.csv
tabula data/5.\ North\ Leeds\ A3\ Inc\ Site\ Schedule.pdf -p 2-14 --spreadsheet   | grep '^[0-9]\|^HLA' > data/5.csv

echo 'SHLAA Ref,Address,Area ha,_something_,Capacity,I&O RAG,Settlement Hierarchy,Green/Brown,Reason' > data/sites.csv
cat data/{1..5}.csv >> data/sites.csv

rm data/{1..5}.csv
