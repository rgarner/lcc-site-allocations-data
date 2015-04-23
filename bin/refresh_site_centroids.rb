#!/usr/bin/env ruby

require_relative '../lib/site_allocations/data/centroids_to_sites'

SiteAllocations::Data::CentroidsToSites.new(
  'data/output/sites.csv',
  'data/output/centroids.csv'
).run!
