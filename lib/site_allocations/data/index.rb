require 'csv'
require 'ostruct'

module SiteAllocations
  module Data
    class Index
      def rows
        @rows ||= CSV.read('data/00index.txt', col_sep: '|')
      end

      def source_pdfs
        rows.map do |row|
          OpenStruct.new(filename: row[0], range: row[1])
        end
      end
    end
  end
end
