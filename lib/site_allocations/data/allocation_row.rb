require 'csv'

module SiteAllocations
  module Data
    class AllocationRow
      ALLOCATION_REF_INDEX = 0
      SHLAA_REFS_INDEX     = 1

      attr_reader   :address
      attr_accessor :shlaa_refs, :allocation_ref, :capacity,
                    :completed_post_2012, :under_construction, :not_started,
                    :area_ha, :green_brown

      def address=(value)
        @address = normalize_address(value)
      end

      def initialize(front_half)
        front_half.is_a?(Array) && front_half.length == 2 or raise ArgumentError, 'expects a two-element array'

        self.allocation_ref = front_half[ALLOCATION_REF_INDEX]
        self.shlaa_refs     = normalize_shlaa_refs(front_half[SHLAA_REFS_INDEX])
      end

      def add_back_half(back_half)
        mappings = case
                   when back_half.length == 4
                     { address: 0, area_ha: 1, capacity: 2, green_brown: 3 }
                   when back_half[2] == '' && back_half[5] == ''
                     { address: 0, capacity: 1, completed_post_2012: 3, under_construction: 4, not_started: 6 }
                   else
                     { address: 0, capacity: 1, completed_post_2012: 2, under_construction: 3, not_started: 4 }
                   end

        mappings.each_pair { |attr, index| send "#{attr}=", back_half[index] }
      end

      def to_csv
        #    echo 'Allocation Ref,SHLAA Refs,Address,Capacity,Completed post-2012,'\
        #         'Under construction,Not started,Green/Brown,Status' > ${FINAL_FILE}
        CSV.generate_line [
          allocation_ref, shlaa_refs_as_string, address, capacity, completed_post_2012,
          under_construction, not_started, area_ha, green_brown, 'Draft'
        ]
      end

      def self.type(row)
        case
        when row.length >= 5 && [row[0], row[1]] == ['', ''] && row[2] =~ /[A-Z0-9]/
          :address_and_stats
        when row[0] =~ /^HG|MX[0-3]/ && row.length > 1
          :id_mapping
        end
      end

    private
      def normalize_address(value)
        value.gsub(/\s+/, ' ').gsub('W ', 'W')
      end

      def normalize_shlaa_refs(underscore_separated_refs)
        refs = underscore_separated_refs.split('_')

        refs.map do |ref|
          if ref =~ /^[A-Z]$/
            refs.first.sub(/[A-Z]$/, '') + ref
          else
            ref
          end
        end
      end

      def shlaa_refs_as_string
        shlaa_refs.join('_')
      end
    end
  end
end
