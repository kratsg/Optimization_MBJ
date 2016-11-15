#!/bin/bash

python ../Optimization/write_all_optimal_cuts.py --supercuts=supercuts/normal.json --significances significances/normal -o outputHash/normal --mass_windows ../massWindows_Gtt.txt
python ../Optimization/write_all_optimal_cuts.py --supercuts=supercuts/jigsaw.json --significances significances/jigsaw -o outputHash/jigsaw --mass_windows ../massWindows_Gtt.txt
