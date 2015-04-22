#!/usr/bin/env awk

# Pipe Tabula output (without --spreadsheet) from proforma PDF here, e.g.
#
#   tabula data/raw/3.\ East\ Leeds\ Site\ Proformas.pdf --pages all | awk -f bin/proforma.awk
#
# Maintains state, beginning with site heading. Gathers to temp variables.
# Prints when first conclusion seen.


#
# Negative lookahead blocks. Things we always want to skip (for now)
#
/^[0-9]\./                           { next } # Skip heading 1. 2. 3. 4.
/\"?[0-9]{2}\/[0-9]{5}\/[A-Z]{2,5}/ { next }  # Skip planning refs like 07/07682/FU,420240,441717
                                              #                         14/02181/COND,419403,442345

/1990 Act that/                      { next } # Not a shlaa_ref, but would match shlaa_ref regex otherwise

BEGIN {
  state = "expecting_shlaa_ref"
}

# Real headings. May contain "s. Use a single capital at the end to filter
# rubbish that would otherwise require a blacklist
/^\"?(HLA|CFSM)?[0-9]{2,7}([A-Z]{1,4})* [A-Z]/ {
  if(state == "expecting_shlaa_ref") {
    massaged_shlaa_ref = $1
    sub(/\"/, "", massaged_shlaa_ref)
    if(massaged_shlaa_ref != last_shlaa_ref) {
      if (massaged_shlaa_ref < last_shlaa_ref) {
        print "WARN: shlaa ref appears out of order " $0 > "/dev/stderr"
      }
      shlaa_ref = massaged_shlaa_ref
      state = "expecting_location"
    }
  }
}

/Easting.*Northing/ {
  if(state == "expecting_location") {
    easting  = $2;
    northing = $4
    sub(/,/, "", northing)
    state = "expecting_conclusion"
  }
}

# We'll accept any old conclusion as the first.
/(DPP Allocation c)?(SHLAA)?[Cc]onclusion/ {
  if(state == "expecting_conclusion") {
    print shlaa_ref "," easting "," northing

    easting = ""
    northing = ""
    last_shlaa_ref = shlaa_ref
    shlaa_ref = ""

    state = "expecting_shlaa_ref"
  }
}
