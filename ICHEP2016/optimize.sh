#!/bin/bash

#python ../Optimization/optimize.py optimize --signal $(awk '{print $1"*"}' ../massWindows_Gtt.txt | tr '\n' ' ') --bkgd $(cat bkgdFiles | sed "s/$/.json/g" | tr '\n' ' ') --searchDirectory=cuts/baseline_${version} -b --o=significances/baseline_${version} --bkgdUncertainty=0.3 --bkgdStatUncertainty=0.3 --insignificance=0.5 --lumi 10

#rooptimize optimize --signal 3701* --bkgd 36* 34* 31* 41* 407* --searchDirectory=cuts/baseline_${version} -b --o=significances/baseline_${version} --bkgdUncertainty=0.3 --bkgdStatUncertainty=0.3 --insignificance=0.5 --lumi 10

#python ../Optimization/optimize.py optimize --signal 3701* --bkgd  31* 36* 34* 410000 407012 410013 410014 410011 410012 410025 410026 410018 410019 410020 410021 410066 410067 410068 410073 410074 410075 410080 41001* --searchDirectory=cuts/baseline_${version} -b --o=significances/baseline_${version} --bkgdUncertainty=0.3 --bkgdStatUncertainty=0.3 --insignificance=0.5 --lumi 10

rooptimize optimize --signal 3701* --bkgd 407012 --searchDirectory=cuts/baseline_${version} -b --o=significances/baseline_${version} --bkgdUncertainty=0.3 --bkgdStatUncertainty=0.3 --insignificance=0.5 --lumi 10

#python ../Optimization/optimize.py optimize --signal $(awk '{print $1"*"}' ../massWindows_Gtt.txt | tr '\n' ' ') --bkgd $(cat bkgdFiles | sed "s/$/.json/g" | tr '\n' ' ') --searchDirectory=cuts/baseline_${version} -b --o=significances_ttbarScaled/baseline_${version} --bkgdUncertainty=0.3 --bkgdStatUncertainty=0.3 --insignificance=0.5 --lumi 35 --rescale rescale_${version}.json --did-to-group ../did_to_group.json
