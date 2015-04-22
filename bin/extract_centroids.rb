#!/usr/bin/env ruby

# Must always be run as bin/extract_candidates.rb -
#   relies on relative paths

require 'tabula'

PDF_FILE_PATH = "data/raw/*Proforma*.pdf"

TOP  = 116.63
LEFT = 32.71

HEIGHT = 28.95
WIDTH  = 776.59

WARD_COORDS = [TOP, LEFT, HEIGHT + TOP, WIDTH + LEFT]

HEADER = 'Ward,Name,Address,Party,Proposer,Seconder'

def ward_name(pdf_page, index)
  page = index + 1
  case page
  when 22
    'Kirkstall Ward'
  when 28
    'Pudsey ward'
  else
    pdf_page.get_text(WARD_COORDS).map(&:text).join.strip
  end
end


def should_output?(row)
  # Only if no IMPORTANT FIELDS are empty
  IMPORTANT_FIELDS.none? { |index| row[index].text.strip.empty? }
end

def propose_second(str)
  m = str.match /(?<proposer>.*)\(P\)\s*,\s*(?<seconder>.*)\(S\)/
  [m[:proposer], m[:seconder]]
end

NAME           = 1
ADDRESS        = 5
PARTY          = 9
PROPOSE_SECOND = 13

IMPORTANT_FIELDS =  [NAME, ADDRESS, PARTY, PROPOSE_SECOND]

File.open(OUTFILENAME, 'w+') do |out|
  extractor = Tabula::Extraction::ObjectExtractor.new(PDF_FILE_PATH, :all)

  out.puts HEADER

  extractor.extract.each_with_index do |pdf_page, index|
    ward_name = ward_name(pdf_page, index)

    sheet = pdf_page.spreadsheets(use_line_returns: false)[0]

    sheet.rows.select {|row| should_output?(row)}.each do |row|
      cells = [
        ward_name,
        [NAME, ADDRESS, PARTY].map {|index| row[index].text},
        *propose_second(row[PROPOSE_SECOND].text)
      ].flatten

      out.write CSV.generate_line(cells, row_sep: "\r\n")
    end
  end
end
