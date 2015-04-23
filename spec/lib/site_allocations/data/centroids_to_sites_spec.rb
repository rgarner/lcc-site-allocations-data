require 'spec_helper'
require 'site_allocations/data/centroids_to_sites'
require 'digest'

module SiteAllocations
  module Data
    describe CentroidsToSites do
      context 'Unhappy paths' do
        it 'fails when missing either CSV' do
          expect { CentroidsToSites.new(nil, 'otherfile') }.to raise_error(ArgumentError, /sites CSV not given/)
          expect { CentroidsToSites.new('otherfile', nil) }.to raise_error(ArgumentError, /centroids CSV not given/)
        end
      end

      describe '#run!' do
        def reset_fixtures!
          FileUtils.cp('spec/fixtures/sites_with_no_centroids.csv', 'spec/fixtures/sites.csv')
        end

        before { reset_fixtures! }
        after  { reset_fixtures! }

        subject(:converter) { CentroidsToSites.new(sites_csv_filename, centroids_csv_filename) }

        context 'sites CSV does not exist' do
          let(:sites_csv_filename) { 'spec/fixtures/sites_not_here.csv' }
          let(:centroids_csv_filename) { 'spec/fixtures/centroids.csv' }

          it 'fails' do
            expect { converter.run! }.to raise_error(Errno::ENOENT, /sites_not_here/)
          end
        end

        context 'centroids CSV does not exist' do
          let(:sites_csv_filename) { 'spec/fixtures/sites.csv' }
          let(:centroids_csv_filename) { 'spec/fixtures/centroids_not_here.csv' }

          it 'fails' do
            expect { converter.run! }.to raise_error(Errno::ENOENT, /centroids_not_here/)
          end
        end

        context 'everything exists' do
          let(:sites_csv_filename) { 'spec/fixtures/sites.csv' }
          let(:centroids_csv_filename) { 'spec/fixtures/centroids.csv' }

          before do
            @pre_run_sites_hash = Digest::MD5.hexdigest(File.read(sites_csv_filename))
            converter.run!
          end

          it 'has changed the sites file' do
            expect(Digest::MD5.hexdigest(File.read(sites_csv_filename))).not_to eql(@pre_run_sites_hash)
          end

          describe 'the output' do
            subject(:lines) { File.readlines(sites_csv_filename) }

            it 'has a new header' do
              expect(lines.first).to eql(
                "SHLAA Ref,Address,Area ha,_something_,Capacity,I&O RAG,Settlement Hierarchy,Green/Brown,Reason,Easting,Northing\n"
              )
            end

            it 'blanks centroids it could not find' do
              expect(lines).to include(
                "180DOESNOTEXIST,\"Swaine Hill Terrace - Brookfield Nursing Home, Yeadon\",0.4,\"\",7,R,Major Settlement Infill"\
                ",Brownfield,\"Allocate. Conversion site above 0.4ha, detail the requirement that redevelopment would not be acceptable.\",,\n"
              )
            end
          end
        end
      end
    end
  end
end
