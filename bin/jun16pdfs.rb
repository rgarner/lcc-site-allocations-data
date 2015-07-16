#!/usr/bin/env ruby
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../lib'))

require 'csv'
require 'set'
require 'site_allocations/data/allocation_row'

# Pipe Tabula output (with --spreadsheet) from Jun 16 Development Plans Panel PDF here, e.g.
#
#   tabula data/raw/01.\ Aireborough\ HMCA\ Area.pdf --pages 2,3,4 | ruby -ne bin/jun16pdfs.rb
#
# Maintains state, beginning with back half of field. Adds a header

back_half ||= false

allocations = {}

while (line = gets)
  row = CSV.parse(line).first

  case SiteAllocations::Data::AllocationRow.type(row)
  when :address_and_stats
    # The back half shows up first. Store it
    back_half = row[2..-1]
  when :id_mapping
    # When a front half (id allocation -> site mapping) shows up,
    # spit it out.
    front_half = row[0..1]
    id = front_half[0]
    if back_half
      allocations[id] ||= SiteAllocations::Data::AllocationRow.new(front_half).tap do |allocation|
        allocation.add_back_half(back_half)
        puts allocation.to_csv
      end
      back_half = false
    end
  end

end

