#!/bin/bash

python ../Optimization/summary-comparison.py --base-summary summary_normal_v1.json --comp-summary summary_normal_${version}.json --lumi 35 -o normal_${version} -b
python ../Optimization/summary-comparison.py --base-summary summary_jigsaw_v1.json --comp-summary summary_jigsaw_${version}.json --lumi 35 -o jigsaw_${version} -b
