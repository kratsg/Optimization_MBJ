#!/bin/bash

for f in regions_${version}/SRCR.json regions_${version}/VR.json
do
  python ../Optimization/tableOfBackgrounds.py --regions ${f} \
    --did_to_group ../did_to_group.json --lumi 35 \
    --include-dids $(cat bkgdFiles | tr '\n' ' ') \
    --hide-raw --hide-weighted --hide-invalid-dids
done
