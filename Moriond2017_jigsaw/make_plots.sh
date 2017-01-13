#!/bin/bash

python ../Optimization/graph-grid.py --summary summary_jigsaw_${version}.json --lumi 35 -o jigsaw_${version} --do-run2 --run2-excl ../run2_limit.csv --run2-1sigma ../run2_limit_1sigma.csv -b
python ../Optimization/graph-cuts.py --summary summary_jigsaw_${version}.json --lumi 35 -o jigsaw_${version} -b --outputHash outputHash/jigsaw_${version} --supercuts supercuts/jigsaw_${version}.json
