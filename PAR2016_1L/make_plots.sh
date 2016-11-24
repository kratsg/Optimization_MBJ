#!/bin/bash

python ../Optimization/graph-grid.py --lumi 35 --outfile normal_${version} --cutdir cuts/normal_${version} --sigdir significances/normal_${version} --massWindows ../massWindows_Gtt.txt --run1_csvfile ../Optimization/run1_limit.csv --run1_1sigma_csvfile ../Optimization/run1_limit_1sigma.csv
python ../Optimization/graph-grid.py --lumi 35 --outfile jigsaw_${version} --cutdir cuts/jigsaw_${version} --sigdir significances/jigsaw_${version} --massWindows ../massWindows_Gtt.txt --run1_csvfile ../Optimization/run1_limit.csv --run1_1sigma_csvfile ../Optimization/run1_limit_1sigma.csv

python ../Optimization/graph-cuts.py --lumi 35 --outfile normal_${version} --supercuts supercuts/normal_${version}.json --sigdir significances/normal_${version} --hashdir outputHash/normal_${version} --massWindows ../massWindows_Gtt.txt
python ../Optimization/graph-cuts.py --lumi 35 --outfile jigsaw_${version} --supercuts supercuts/jigsaw_${version}.json --sigdir significances/jigsaw_${version} --hashdir outputHash/jigsaw_${version} --massWindows ../massWindows_Gtt.txt
