#!/bin/bash

python ../Optimization/graph-grid.py --summary summary_baseline_${version}.json --lumi 35 -o baseline_${version} --do-run1 --run1-excl ../Optimization/run1_limit.csv --run1-1sigma ../Optimization/run1_limit_1sigma.csv -b

python ../Optimization/graph-cuts.py --summary summary_baseline_${version}.json --lumi 35 -o baseline_${version} --do-run1 --run1-excl ../Optimization/run1_limit.csv --run1-1sigma ../Optimization/run1_limit_1sigma.csv -b --outputHash outputHash/baseline_${version} --supercuts supercuts/baseline_${version}.json

