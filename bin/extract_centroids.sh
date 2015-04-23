#!/bin/sh

# Must always be run from dir above as bin/extract_centroids.rb -
#   relies on relative paths

trap '{ exit 1; }' INT

set -ex

IFS=$"\n"
PDFS=data/raw/*Proforma*

for pdf in ${PDFS};
do
  # echo "# Source: ${pdf}"
  tabula "${pdf}" --pages all | awk -f bin/proforma.awk
done
