#!/bin/bash

for lumi in 35
do

  python ../Optimization/summary-comparison.py --base-summary summary_baseline_${version}.json --comp-summary summary_Gtt${version}_optimalSR_${lumi}.json --lumi ${lumi} -o Gtt${version}_optimalSR_${lumi} -b

done
