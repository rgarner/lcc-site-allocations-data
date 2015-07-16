require 'spec_helper'
require 'site_allocations/data/allocation_row'

module SiteAllocations
  module Data
    describe AllocationRow do
      describe 'the detection of raw tabula output row types before we initialize - .type' do
        subject(:type) { AllocationRow.type(row) }
        context 'the front_half (allocation/sites id mapping)' do
          let(:row) { ['HG1-1','734','','','','',''] }

          example { expect(type).to eql(:id_mapping) }
        end
        context 'a back half (details)' do
          let(:row) { ['', '', "Bradford Road - High Royds, Menston", '349', '', '335','14', '', '0'] }

          example { expect(type).to eql(:address_and_stats) }
        end
      end

      describe '#initialize' do
        subject(:row) { AllocationRow.new(front_half) }

        context 'not an array' do
          it 'fails' do
            expect { AllocationRow.new(1) }.to raise_error(ArgumentError, 'expects a two-element array')
          end
        end

        context 'an array with the wrong number' do
          it 'fails' do
            expect { AllocationRow.new([1]) }.to raise_error(ArgumentError, 'expects a two-element array')
          end
        end

        context 'has a single shlaa_ref and allocation ref' do
          let(:front_half) { ['HG2-119', '2062'] }

          it 'has an allocation ref' do
            expect(row.allocation_ref).to eql('HG2-119')
          end

          it 'has all the shlaa refs' do
            expect(row.shlaa_refs).to eql(['2062'])
          end
        end

        context 'has a list of shlaa_refs separated by underscore' do
          let(:front_half) { ['HG2-120', '2062_117_110A'] }

          it 'has an allocation ref' do
            expect(row.allocation_ref).to eql('HG2-120')
          end

          it 'has all the shlaa_refs' do
            expect(row.shlaa_refs).to eql(%w(2062 117 110A))
          end
        end
      end
    end

    describe '#add_back_half' do
      subject(:row) { AllocationRow.new(['HG2-119', '2062']) }

      before { row.add_back_half(back_half) }

      context 'has capacity and started stats (HG1) in an uncorrupted form' do
        let(:back_half)  { ["Bradford Road - High Royds, Menston",'349','335','14','0'] }

        example { expect(row.address).to eql('Bradford Road - High Royds, Menston') }
        example { expect(row.capacity).to eql('349') }
        example { expect(row.completed_post_2012).to eql('335') }
        example { expect(row.under_construction).to eql('14') }
        example { expect(row.not_started).to eql('0') }
      end

      context 'has capacity and started stats (HG1) in a corrupted form' do
        let(:back_half)  { ["Bradford Road - High Royds, Menston", '349', '', '335','14', '', '0'] }

        example { expect(row.address).to eql('Bradford Road - High Royds, Menston') }
        example { expect(row.capacity).to eql('349') }
        example { expect(row.completed_post_2012).to eql('335') }
        example { expect(row.under_construction).to eql('14') }
        example { expect(row.not_started).to eql('0') }
      end

      context 'has capacity and site type (HG2) stats' do
        let(:back_half) { ['New Birks Farm  Ings Lane  Guiseley', '11.3', '298', 'Greenfield'] }

        example { expect(row.address).to eql('New Birks Farm Ings Lane Guiseley') }
        example { expect(row.capacity).to eql('298') }
        example { expect(row.area_ha).to eql('11.3') }
        example { expect(row.under_construction).to be_nil }
        example { expect(row.green_brown).to eql('Greenfield') }
      end

      context 'has funky address (due to kerning on W, perhaps)' do
        let(:back_half)  { [address,'349','335','14','0'] }

        context 'Broken isolated letter at start' do
          let(:address) { 'W ills Gill, Guiseley' }
          it('fixes it') { expect(row.address).to eql('Wills Gill, Guiseley') }
        end
        context 'Broken isolated letter in middle' do
          let(:address) { 'Sweet Street W est (20) - Management Archives' }
          it('fixes it') { expect(row.address).to eql('Sweet Street West (20) - Management Archives') }
        end
        context 'Multiple spaces' do
          let(:address) { 'Netherfield Road - Cromptons,  Guiseley' }
          it('fixes it') { expect(row.address).to eql('Netherfield Road - Cromptons, Guiseley') }
        end
      end
    end

    describe '#to_csv' do
      context 'no data' do
        it 'is empty' do
          expect(AllocationRow.new(['', '']).to_csv).to eql(%("","",,,,,,,\n))
        end
      end

      context 'building up' do
        it 'puts out what it knows about at any stage' do
          row = AllocationRow.new(['HG2-119', '2062'])
          expect(row.to_csv).to eql("HG2-119,2062,,,,,,,\n")
          row.add_back_half(["Bradford Road - High Royds, Menston", '349', '', '335','14', '', '0'])
          expect(row.to_csv).to eql("HG2-119,2062,\"Bradford Road - High Royds, Menston\",349,335,14,0,,\n")
        end
      end
    end
  end
end
