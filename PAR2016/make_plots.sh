#!/bin/bash

python ../Optimization/graph-grid.py --lumi 35 --outfile normal --cutdir cuts/normal --sigdir significances/normal --massWindows ../massWindows_Gtt.txt --run1_csvfile ../Optimization/run1_limit.csv --run1_1sigma_csvfile ../Optimization/run1_limit_1sigma.csv
python ../Optimization/graph-grid.py --lumi 35 --outfile jigsaw --cutdir cuts/jigsaw --sigdir significances/jigsaw --massWindows ../massWindows_Gtt.txt --run1_csvfile ../Optimization/run1_limit.csv --run1_1sigma_csvfile ../Optimization/run1_limit_1sigma.csv

python ../Optimization/graph-cuts.py --lumi 35 --outfile normal --supercuts supercuts/normal.json --sigdir significances/normal --hashdir outputHash/normal --massWindows ../massWindows_Gtt.txt
python ../Optimization/graph-cuts.py --lumi 35 --outfile jigsaw --supercuts supercuts/jigsaw.json --sigdir significances/jigsaw --hashdir outputHash/jigsaw --massWindows ../massWindows_Gtt.txt
