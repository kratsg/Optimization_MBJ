#!/bin/bash

python graph-grid-mlb.py --summary summary_baseline_${version}.json --lumi 10 -o baseline_${version} --do-run2 --run2-excl run2_limit.csv --run2-1sigma run2_limit_1sigma.csv -b --g-min=1000 --g-max=2000 --l-max=1600

python graph-cuts-mlb.py --summary summary_baseline_${version}.json --lumi 10 -o baseline_${version} -b --outputHash outputHash/baseline_${version} --supercuts supercuts/baseline_${version}.json --g-min=1000 --g-max=2000 --l-max=1600

#python ../Optimization/graph-grid.py --summary summary_baseline_${version}_ttbarScaled.json --lumi 35 -o baseline_${version}_ttbarScaled --do-run2 --run2-excl ../run2_limit.csv --run2-1sigma ../run2_limit_1sigma.csv -b
#python ../Optimization/graph-cuts.py --summary summary_baseline_${version}_ttbarScaled.json --lumi 35 -o baseline_${version}_ttbarScaled -b --outputHash outputHash_ttbarScaled/baseline_${version} --supercuts supercuts/baseline_${version}.json

