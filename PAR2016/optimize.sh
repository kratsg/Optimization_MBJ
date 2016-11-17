#!/bin/bash

python ../Optimization/optimize.py optimize --signal $(awk '{print $1"*"}' ../massWindows_Gtt.txt | tr '\n' ' ') --bkgd $(cat bkgdFiles | sed "s/$/.json/g" | tr '\n' ' ') --searchDirectory=cuts/normal -b --o=significances/normal --bkgdUncertainty=0.3 --bkgdStatUncertainty=0.3 --insignificance=0.5 --lumi 35
python ../Optimization/optimize.py optimize --signal $(awk '{print $1"*"}' ../massWindows_Gtt.txt | tr '\n' ' ') --bkgd $(cat bkgdFiles | sed "s/$/.json/g" | tr '\n' ' ') --searchDirectory=cuts/jigsaw -b --o=significances/jigsaw --bkgdUncertainty=0.3 --bkgdStatUncertainty=0.3 --insignificance=0.5 --lumi 35
