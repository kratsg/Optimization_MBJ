#!/bin/bash

python ../Optimization/graph-grid.py --summary summary_normal_${version}.json --lumi 35 -o normal_${version} --do-run1 --run1-excl ../Optimization/run1_limit.csv --run1-1sigma ../Optimization/run1_limit_1sigma.csv -b
#python ../Optimization/graph-grid.py --summary summary_jigsaw_${version}.json --lumi 35 -o jigsaw_${version} --do-run1 --run1-excl ../Optimization/run1_limit.csv --run1-1sigma ../Optimization/run1_limit_1sigma.csv -b

python ../Optimization/graph-cuts.py --summary summary_normal_${version}.json --lumi 35 -o normal_${version} --do-run1 --run1-excl ../Optimization/run1_limit.csv --run1-1sigma ../Optimization/run1_limit_1sigma.csv -b --outputHash outputHash/normal_${version} --supercuts supercuts/normal_${version}.json
#python ../Optimization/graph-cuts.py --summary summary_jigsaw_${version}.json --lumi 35 -o jigsaw_${version} --do-run1 --run1-excl ../Optimization/run1_limit.csv --run1-1sigma ../Optimization/run1_limit_1sigma.csv -b --outputHash outputHash/jigsaw_${version} --supercuts supercuts/jigsaw_${version}.json

