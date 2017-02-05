#!/bin/bash

#python ../Optimization/optimize.py optimize --signal $(awk '{print $1"*"}' ../massWindows_Gtt.txt | tr '\n' ' ') --bkgd $(cat bkgdFiles | sed "s/$/.json/g" | tr '\n' ' ') --searchDirectory=cuts/baseline_${version} -b --o=significances/baseline_${version} --bkgdUncertainty=0.3 --bkgdStatUncertainty=0.3 --insignificance=0.5 --lumi 10

rooptimize optimize --signal 3701* --bkgd  31* 36* 34* 410000 407009 407010 407018 407019 407020 407021 407011 410013 410014 410011 410012 410025 410026 410018 410019 410020 410021 --searchDirectory=cuts/baseline_${version} -b --o=significances/baseline_${version} --bkgdUncertainty=0.3 --bkgdStatUncertainty=0.3 --insignificance=0.5 --lumi 10

#python ../Optimization/optimize.py optimize --signal 3701* --bkgd  31* 36* 34* 410000 407012 410013 410014 410011 410012 410025 410026 410018 410019 410020 410021 --searchDirectory=cuts/baseline_${version} -b --o=significances/baseline_${version} --bkgdUncertainty=0.3 --bkgdStatUncertainty=0.3 --insignificance=0.5 --lumi 10

#python ../Optimization/optimize.py optimize --signal $(awk '{print $1"*"}' ../massWindows_Gtt.txt | tr '\n' ' ') --bkgd $(cat bkgdFiles | sed "s/$/.json/g" | tr '\n' ' ') --searchDirectory=cuts/baseline_${version} -b --o=significances_ttbarScaled/baseline_${version} --bkgdUncertainty=0.3 --bkgdStatUncertainty=0.3 --insignificance=0.5 --lumi 35 --rescale rescale_${version}.json --did-to-group ../did_to_group.json
