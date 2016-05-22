#!/bin/bash

python ../Optimization/tableOfBackgrounds.py ~/hf_tag02_v1/*.merged --lumi 10 --include-dids $(cat bkgdFiles | tr '\n' ' ')
