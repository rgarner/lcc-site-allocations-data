#!/usr/bin/env ruby
require 'csv'

# Check data for off-by-one errors by testing the last site
# in every PDF against this list of known eastings/northings
test_centroids_by_shlaa_ref = [
  ['HLA28024', 1,  '419403', '442345'],
  ['HLA20050', 2,  '429061', '434235'],
  ['5140'    , 3,  '436555', '436486'],
  ['HLA26038', 4,  '428746', '434793'],
  ['HLA34026', 5,  '430856', '436376'],
  ['HLA31043', 6,  '442899', '445632'],
  ['HLA29013', 7,  '420198', '445596'],
  ['HLA22022', 8,  '436181', '428331'],
  ['HLA33066', 9,  '441153', '431026'],
  ['HLA23043', 10, '428112', '424442'],
  ['HLA24050', 11, '424682', '435072']
]

centroids_by_shlaa_ref = CSV.read('data/output/centroids.csv').inject({}) do |hash, row|
  existing_row = hash[row[0]]
  puts "#{row.to_s} has already been seen as #{existing_row}" if existing_row

  hash[row[0]] ||= row
  hash
end

failures = []

test_centroids_by_shlaa_ref.each do |shlaa_ref, pdf_no, easting, northing|
  centroids_by_shlaa_ref[shlaa_ref].tap do |_, actual_easting, actual_northing|
    if actual_easting != easting || actual_northing != northing
      failures << "From pdf #{pdf_no}, site #{shlaa_ref} " \
                  "expected: #{[easting, northing].to_s}, "\
                  "actual #{[actual_easting, actual_northing].to_s}"
    end
  end
end

failures.each { |failure| puts failure }
exit failures.none? ? 0 : 1
