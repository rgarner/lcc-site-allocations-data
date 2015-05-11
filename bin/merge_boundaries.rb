#!/usr/bin/env ruby

require_relative '../lib/site_allocations/data/merge_boundaries'

SiteAllocations::Data::MergeBoundaries.new(
  ARGV,
  'data/output/boundaries.csv'
).run!
