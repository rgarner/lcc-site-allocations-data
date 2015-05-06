require 'csv'

module SiteAllocations
  module Data
    class MergeBoundaries
      def initialize(boundary_csv_files, output_file)
        @boundary_csv_files = boundary_csv_files
        @output_file        = output_file
      end

      def run!
        raise ArgumentError, 'no input files' unless @boundary_csv_files.any?
        check_boundary_files_exist!
        File.open(@output_file, 'w+') do |file|
          file.puts 'SHLAA Ref,Boundary'
          merged_geoms_by_shlaa_ref.each do |pair|
            file.puts(CSV.generate_line(pair))
          end
        end
      end

      private
      def check_boundary_files_exist!
        @boundary_csv_files.each do |filename|
          raise Errno::ENOENT.new(filename) unless File.exists?(filename)
        end
      end

      def merged_geoms_by_shlaa_ref
        @boundary_csv_files.inject({}) do |hash, filename|
          hash.merge(geom_by_shlaa_ref(filename))
        end
      end

      def geom_by_shlaa_ref(filename)
        CSV.read(filename, headers: true).inject({}) do |hash, row|
          hash[row['SHLAA_REF']] = row['WKT']
          hash
        end
      end

    end
  end
end
