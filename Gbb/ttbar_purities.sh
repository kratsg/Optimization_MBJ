#!/bin/bash

python ../Optimization/tableOfBackgrounds.py ~/hf_tag02_v1/*.merged --lumi 6 --include-dids $(cat bkgdFiles | tr '\n' ' ')
python ../Optimization/tableOfBackgroundsVR.py ~/hf_tag02_v1/*.merged --lumi 6 --include-dids $(cat bkgdFiles | tr '\n' ' ')
