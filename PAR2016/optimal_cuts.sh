#!/bin/bash

python ../Optimization/write_all_optimal_cuts.py --supercuts=supercuts/normal_${version}.json --significances significances/normal_${version} -o outputHash/normal_${version} --mass_windows ../massWindows_Gtt.txt
python ../Optimization/write_all_optimal_cuts.py --supercuts=supercuts/jigsaw_${version}.json --significances significances/jigsaw_${version} -o outputHash/jigsaw_${version} --mass_windows ../massWindows_Gtt.txt
