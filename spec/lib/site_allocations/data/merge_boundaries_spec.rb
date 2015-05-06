require 'spec_helper'
require 'site_allocations/data/merge_boundaries'
require 'digest'

module SiteAllocations
  module Data
    describe MergeBoundaries do
      describe '#run!' do
        let(:shlaa_boundaries)       { 'spec/fixtures/shlaa_boundaries.csv' }
        let(:aireborough_boundaries) { 'spec/fixtures/aireborough_boundaries.csv' }
        let(:output_file)            { 'spec/fixtures/output.csv' }

        before { merger.run! }
        after  { FileUtils.rm(output_file) }

        let(:merger) { MergeBoundaries.new(input_files, output_file) }

        subject(:output_lines) { CSV.read(output_file, headers: true) }

        context 'aireborough file comes last' do
          let(:input_files) { [shlaa_boundaries, aireborough_boundaries] }

          it 'has a superset of data' do
            expect(output_lines.size).to eql(2)
          end

          it 'has the aireborough line' do
            expect(output_lines.first['SHLAA Ref']).to eql('4019')
            expect(output_lines.first['Boundary']).to start_with('POLYGON ((-1.691642 ')
          end
        end

        context 'aireborough file comes first' do
          let(:input_files) { [aireborough_boundaries, shlaa_boundaries] }

          it 'has a superset of data' do
            expect(output_lines.size).to eql(2)
          end

          it 'has the shlaa line' do
            expect(output_lines.first['SHLAA Ref']).to eql('4019')
            expect(output_lines.first['Boundary']).to start_with('POLYGON ((-1.691932643423883 ')
          end
        end
      end
    end
  end
end
