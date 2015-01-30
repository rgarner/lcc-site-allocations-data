require 'spec_helper'

require 'site_allocations/data/index'

module SiteAllocations::Data
  describe Index do
    subject(:index) { Index.new }

    it 'has several source PDFs' do
      expect(index.source_pdfs.size).to eql(5)
    end

    describe 'the first PDF' do
      subject(:pdf) { index.source_pdfs.first }

      it 'has a filename' do
        expect(pdf.filename).to eql('1. Aireborough A3 Inc Site Schedule.pdf')
      end
      it 'has a range' do
        expect(pdf.range).to eql('1-4,6-9')
      end
    end
  end
end

