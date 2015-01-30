#!/bin/sh
set -ex

RAW=data/raw
OUTPUT=data/output

tabula "$RAW/1. Aireborough A3 Inc Site Schedule.pdf"       -p 1-4,6-9 --spreadsheet | grep '^[0-9]\|^HLA' > $OUTPUT/1.csv
tabula "$RAW/2. City Centre A3 Inc Site Schedule.pdf"       -p 2-13    --spreadsheet | grep '^[0-9]\|^HLA' > $OUTPUT/2.csv
tabula "$RAW/3. East Leeds A3 Inc Site Schedule.pdf"        -p 2-7     --spreadsheet | grep '^[0-9]\|^HLA' > $OUTPUT/3.csv
tabula "$RAW/4. Inner Area A3 Inc Site Schedule.pdf"        -p 2-17    --spreadsheet | grep '^[0-9]\|^HLA' > $OUTPUT/4.csv
tabula "$RAW/5. North Leeds A3 Inc Site Schedule.pdf"       -p 2-14    --spreadsheet | grep '^[0-9]\|^HLA' > $OUTPUT/5.csv
tabula "$RAW/6. Outer North East A3 Inc Site Schedule.pdf"  -p 2-16    --spreadsheet | grep '^[0-9]\|^HLA' > $OUTPUT/6.csv
tabula "$RAW/7. Outer North West A3 Inc Site Schedule.pdf"  -p 2-7     --spreadsheet | grep '^[0-9]\|^HLA' > $OUTPUT/7.csv
tabula "$RAW/8. Outer South A3 Inc Site Schedule.pdf"       -p 2-9     --spreadsheet | grep '^[0-9]\|^HLA' > $OUTPUT/8.csv
tabula "$RAW/9. Outer South East A3 Inc Site Schedule.pdf"  -p 2-10    --spreadsheet | grep '^[0-9]\|^HLA' > $OUTPUT/9.csv
tabula "$RAW/10. Outer South West A3 Inc Site Schedule.pdf" -p 2-20    --spreadsheet | grep '^[0-9]\|^HLA' > $OUTPUT/10.csv
tabula "$RAW/11. Outer West A3 Inc Site Schedule.pdf"       -p 2-16    --spreadsheet | grep '^[0-9]\|^HLA' > $OUTPUT/11.csv

echo 'SHLAA Ref,Address,Area ha,_something_,Capacity,I&O RAG,Settlement Hierarchy,Green/Brown,Reason' > $OUTPUT/sites.csv
cat $OUTPUT/{1..11}.csv >> $OUTPUT/sites.csv

rm $OUTPUT/{1..11}.csv
