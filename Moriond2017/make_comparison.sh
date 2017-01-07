#!/bin/bash

python ../Optimization/summary-comparison.py --base-summary summary_baseline_v1.json --comp-summary summary_baseline_${version}.json --lumi 35 -o baseline_${version} -b
