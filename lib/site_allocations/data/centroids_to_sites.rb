require 'csv'
require 'tempfile'

module SiteAllocations
  module Data
    class CentroidsToSites
      EASTING_INDEX  = 9
      NORTHING_INDEX = 10
      EMPTY_CENTROID = [nil, nil]

      def initialize(sites_csv_filename, centroids_csv_filename)
        @sites_csv_filename = sites_csv_filename  or raise ArgumentError, 'sites CSV not given'
        @centroids_csv_filename = centroids_csv_filename or raise ArgumentError, 'centroids CSV not given'
      end

      def run!
        check_files_exist!

        site_rows = CSV.read(@sites_csv_filename)

        site_rows.first[EASTING_INDEX]  = 'Easting'
        site_rows.first[NORTHING_INDEX] = 'Northing'

        site_rows[1..-1].each do |site_row|
          centroid = centroids_by_site[site_row[0]] || EMPTY_CENTROID
          site_row[EASTING_INDEX], site_row[NORTHING_INDEX] = centroid.first, centroid.last
        end

        CSV.open(@sites_csv_filename, 'w') do |sites_csv|
          site_rows.each { |site_row| sites_csv << site_row }
        end
      end

      private
      def check_files_exist!
        [@sites_csv_filename, @centroids_csv_filename].each do |filename|
          raise Errno::ENOENT, filename unless File.exists?(filename)
        end
      end

      def centroids_by_site
        @_centroids_by_site = CSV.read(@centroids_csv_filename).inject({}) do |hash, row|
          hash[row[0]] = [row[1], row[2]]
          hash
        end
      end
    end
  end
end
