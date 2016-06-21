#!/bin/bash

for f in regions/SRCR.json regions/VR.json
do
  python ../Optimization/tableOfBackgrounds.py --regions ${f} \
    --did_to_group ../did_to_group.json --lumi 10 \
    --include-dids $(cat bkgdFiles | tr '\n' ' ') \
    --hide-raw --hide-weighted --hide-invalid-dids
done
