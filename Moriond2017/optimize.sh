#!/bin/bash

python ../Optimization/optimize.py optimize --signal $(awk '{print $1"*"}' ../massWindows_Gtt.txt | tr '\n' ' ') --bkgd $(cat bkgdFiles | sed "s/$/.json/g" | tr '\n' ' ') --searchDirectory=cuts/baseline_${version} -b --o=significances/baseline_${version} --bkgdUncertainty=0.3 --bkgdStatUncertainty=0.3 --insignificance=0.5 --lumi 35
