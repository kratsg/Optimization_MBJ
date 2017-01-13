#!/bin/bash

python ../Optimization/optimize.py summary --searchDirectory significances/jigsaw_${version} --massWindows ../massWindows_Gtt.txt --output summary_jigsaw_${version}.json
python ../Optimization/optimize.py hash summary_jigsaw_${version}.json --supercuts supercuts/jigsaw_${version}.json -o outputHash/jigsaw_${version} --use-summary
