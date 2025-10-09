#!/bin/bash
echo -n "{"
MDATPHEALTH="$(mdatp health 2>&1)" >> null

PATTERNHEALTH=".*healthy\\s*:\\s*true.*"
if [[ $MDATPHEALTH =~ $PATTERNHEALTH ]]; then echo -n "\"health\":\"ok\","; else echo -n "\"health\":\"error\","; fi

PATTERNRTP=".*real_time_protection_enabled\\s*:\\s*true.*"
if [[ $MDATPHEALTH =~ $PATTERNRTP ]]; then echo -n "\"real_time_protection_enabled\":\"ok\""; else echo -n "\"real_time_protection_enabled\":\"disabled\""; fi

echo -n "}"