#!/bin/sh
set -ex

RAW=data/raw
OUTPUT=data/output
FINAL_FILE=${OUTPUT}/allocations.csv

tabula "$RAW/01.Aireborough HMCA Area.pdf"      -rp 2,3,4,29     | bin/jun16pdfs.rb > ${OUTPUT}/1.csv
tabula "$RAW/02.City Centre HMCA Area.pdf"      -rp 3-8,67-70    | bin/jun16pdfs.rb > ${OUTPUT}/2.csv
tabula "$RAW/03.East Leeds HMCA Area.pdf"       -rp 2-4,20-21    | bin/jun16pdfs.rb > ${OUTPUT}/3.csv
tabula "$RAW/04.Inner HMCA Area.pdf"            -rp 3-9,79-81    | bin/jun16pdfs.rb > ${OUTPUT}/4.csv
tabula "$RAW/05.North HMCA Area.pdf"            -rp 3-8,61-62    | bin/jun16pdfs.rb > ${OUTPUT}/5.csv
tabula "$RAW/06.Outer North East HMCA Area.pdf" -rp 2-4,22,24,25 | bin/jun16pdfs.rb > ${OUTPUT}/6.csv
tabula "$RAW/07.Outer North West HMCA Area.pdf" -rp 2-4,21,23,24 | bin/jun16pdfs.rb > ${OUTPUT}/7.csv
tabula "$RAW/08.Outer South HMCA Area.pdf"      -rp 2-4,34       | bin/jun16pdfs.rb > ${OUTPUT}/8.csv
tabula "$RAW/09.Outer South East HMCA Area.pdf" -rp 2-4,24,28,29 | bin/jun16pdfs.rb > ${OUTPUT}/9.csv
tabula "$RAW/10.Outer South West HMCA Area.pdf" -rp 2-7,80-82    | bin/jun16pdfs.rb > ${OUTPUT}/10.csv
tabula "$RAW/11.Outer West HMCA Area.pdf"       -rp 3-8,66,71    | bin/jun16pdfs.rb > ${OUTPUT}/11.csv

echo 'Allocation Ref,SHLAA Refs,Address,Capacity,Completed post-2012,'\
     'Under construction,Not started,Area HA,Green/Brown,Status' > ${FINAL_FILE}

cat ${OUTPUT}/{1..11}.csv >> ${FINAL_FILE}

rm ${OUTPUT}/{1..11}.csv
