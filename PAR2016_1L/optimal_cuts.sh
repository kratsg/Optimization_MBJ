#!/bin/bash

python ../Optimization/optimize.py summary --searchDirectory significances/normal_${version} --massWindows ../massWindows_Gtt.txt --output summary_normal_${version}.json
python ../Optimization/optimize.py hash summary_normal_${version}.json --supercuts supercuts/normal_${version}.json -o outputHash/normal_${version} --use-summary

#python ../Optimization/optimize.py summary --searchDirectory significances/jigsaw_${version} --massWindows ../massWindows_Gtt.txt --output summary_jigsaw_${version}.json
#python ../Optimization/optimize.py hash summary_jigsaw_${version}.json --supercuts supercuts/jigsaw_${version}.json -o outputHash/jigsaw_${version} --use-summary
