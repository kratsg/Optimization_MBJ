#!/bin/bash

python ../Optimization/optimize.py summary --searchDirectory significances/baseline_${version} --massWindows ../massWindows_Gtt.txt --output summary_baseline_${version}.json
python ../Optimization/optimize.py hash summary_baseline_${version}.json --supercuts supercuts/baseline_${version}.json -o outputHash/baseline_${version} --use-summary
