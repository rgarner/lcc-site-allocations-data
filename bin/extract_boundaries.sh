#!/bin/sh

#
# From shapefiles in data/raw/shapefiles, creates a single data/output/boundaries.csv with two columns,
# SHLAA_REF and WKT (well-known text for geometry).  Keeps this data separate from data/output/sites.csv
# for clarity (to preserve that file's human readability).
#
# Must always be run from dir above as bin/extract_boundaries.rb -
#   relies on relative paths

command -v ogr2ogr >/dev/null 2>&1 || { echo "I require ogr2ogr but GDAL is not installed." >&2; exit 1; }

trap '{ exit 1; }' INT

set -e

# Create temp CSV files first

# SHLAA sites default to a .dbf FLOAT representation of the SHLAA ref.
# Deal with this in a brute-force way - substitute ",<shlaa_ref>.00000000000" with "<shlaa_ref>"
SHLAA_CSV=data/raw/shapefiles/shlaa-2013-boundaries.csv
rm -Rf ${SHLAA_CSV} && \
  ogr2ogr -nlt POLYGON -lco "GEOMETRY=AS_WKT" -t_srs EPSG:4326 -f "CSV" /vsistdout/ data/raw/shapefiles/PLAN_SHLAA_SITES_2013.shp | \
  sed 's/,\(.*\)\.00000000000/,\1/' \
    > ${SHLAA_CSV}

AIRE_CSV=data/raw/shapefiles/aireborough-2015-boundaries.csv
rm -Rf ${AIRE_CSV} && \
  ogr2ogr -nlt POLYGON -lco "GEOMETRY=AS_WKT" -f "CSV" /vsistdout/ data/raw/shapefiles/SHLAA\ Allocations\ aireborough\ 2015_region.shp | \
  sed 's/,ID,/,SHLAA_REF,/' \
    > ${AIRE_CSV}

# Merge the temp CSV into two-column output CSV in order given (last in wins)

bin/merge_boundaries.rb ${SHLAA_CSV} ${AIRE_CSV}

rm ${AIRE_CSV} ${SHLAA_CSV}
