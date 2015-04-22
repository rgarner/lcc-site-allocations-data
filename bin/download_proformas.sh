#!/bin/sh

PROFORMAS[0]=http://www.leeds.gov.uk/docs/1.%20Airebrough%20Site%20Proformas%20.pdf
PROFORMAS[1]=http://www.leeds.gov.uk/docs/2.%20City%20Centre%20Site%20Proformas.pdf
PROFORMAS[2]=http://www.leeds.gov.uk/docs/3.%20East%20Leeds%20SiteProformas.pdf
PROFORMAS[3]=http://www.leeds.gov.uk/docs/4.%20Inner%20Area%20SiteProformas.pdf
PROFORMAS[4]=http://www.leeds.gov.uk/docs/5.%20North%20Leeds%20Site%20Proformas.pdf
PROFORMAS[5]=http://www.leeds.gov.uk/docs/6.%20Outer%20North%20East%20Site%20Proformas.pdf
PROFORMAS[6]=http://www.leeds.gov.uk/docs/7.%20Outer%20North%20West%20Site%20Proformas.pdf
PROFORMAS[7]=http://www.leeds.gov.uk/docs/8.%20Outer%20South%20SiteProformas.pdf
PROFORMAS[8]=http://www.leeds.gov.uk/docs/9.%20Outer%20South%20East%20Site%20Proformas.pdf
PROFORMAS[9]=http://www.leeds.gov.uk/docs/10.%20Outer%20South%20West%20Site%20Proformas.pdf
PROFORMAS[10]=http://www.leeds.gov.uk/docs/11.%20Outer%20West%20Site%20Proformas.pdf

# Download proformas
for proforma in ${PROFORMAS[*]}
do
  TARGET_FILE="data/raw/`basename ${proforma}`"
  # Remove %20s for spaces (except the one in Aireborough, just remove that)
  # and normalise SiteProformas inconsistency
  TARGET_FILE=`echo ${TARGET_FILE} | sed -e "s/%20\([^\.]\)/ \1/g" | sed -e "s/%20//" | sed -e "s/SitePro/Site Pro/"`

  if [ ! -f "$TARGET_FILE" ]; then
    curl ${proforma} > ${TARGET_FILE}
  fi
done
