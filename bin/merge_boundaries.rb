#!/usr/bin/env ruby

require_relative '../lib/site_allocations/data/merge_boundaries'

SiteAllocations::Data::MergeBoundaries.new(
  Dir['data/raw/shapefiles/*boundaries.csv'],
  'data/output/boundaries.csv'
).run!
