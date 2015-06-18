#!/bin/sh

#
# From shapefiles in data/raw/shapefiles, creates a single data/output/hmca.csv with two columns,
# NAME and WKT (well-known text for geometry).
#
# Must always be run from dir above as bin/extract_hmca.rb -
#   relies on relative paths

command -v ogr2ogr >/dev/null 2>&1 || { echo "I require ogr2ogr but GDAL is not installed." >&2; exit 1; }

trap '{ exit 1; }' INT

set -e

HMCA_CSV=data/output/hmca.csv

rm -f ${HMCA_CSV}
ogr2ogr -nlt POLYGON -lco "GEOMETRY=AS_WKT" -t_srs EPSG:4326 -f "CSV" ${HMCA_CSV} \
  data/raw/shapefiles/Housing_Market_Characteristic_Areas.shp
