#!/bin/bash

# we use 1L files for both 0L and 1L control regions
#files=$(find /Users/kratsg/2.4.19-0-0/1L/*.root  -not -iname "*Gbb*" -not -iname "*data*")
#files+=($(find /faxbox2/user/mleblanc/multib_ichep2k16/hf_tag2.4.11-1-0/optin/user.*.root* -print0 | xargs -0))
#files+=($(find /faxbox2/user/kratsg/MBJ/2.4.24-1-0/files/HF_tag2.4.24-1-0/user.*/*.root* -not -iname "*Gbb*" -not -iname "*data*" -not -iname "*Gtb*"))
files+=($(find /faxbox/user/mleblanc/optin/user.*/user.*.root* -print0 | xargs -0))

baseDir="CR/${version}"
rm -rf $baseDir
mkdir -p $baseDir

for i in 1 2 3
do
  supercutsLocation="regions_${version}/CR-${i}.json"
  cutsLocation="${baseDir}/CR${i}Cuts"

  #outputNMinus1="n-1/CR-${i}"
  #python ../Optimization/do_n-1_cuts.py ${files[*]} --supercuts $supercutsLocation --output $outputNMinus1 --boundaries boundaries.json -f --tree nominal --eventWeight weight_mc
  
  echo 'cut'
  rooptimize cut ${files[*]} --supercuts=$supercutsLocation -o $cutsLocation --numpy -b --eventWeight "weight_mc" --weightsFile ../Optimization/weights.json --tree nominal --ncores=12  

  for lumi in 10
  do
    significancesLocation="${baseDir}/CR${i}Significances_${lumi}"

#    rooptimize optimize --signal $(awk '{print $1"*"}' ../massWindows_Gtt.txt | tr '\n' ' ') --bkgd $(cat bkgdFiles | sed "s/$/.json/g" | tr '\n' ' ') --searchDirectory=$cutsLocation -b -o $significancesLocation --bkgdUncertainty=0.3 --bkgdStatUncertainty=0.3 --insignificance=0.5 --lumi $lumi
    rooptimize optimize --signal 3701* --bkgd 31* 36* 34* 410000 407012 410013 410014 410011 410012 410025 410026 410018 410019 410020 410021 410066 410067 410068 410073 410074 410075 410080 41001* --searchDirectory=$cutsLocation -b -o $significancesLocation --bkgdUncertainty=0.3 --bkgdStatUncertainty=0.3 --insignificance=0.5 --lumi $lumi

    summaryLocation="${baseDir}/summary_CR${i}_${lumi}.json"
    rooptimize summary --searchDirectory $significancesLocation --massWindows ../massWindows_Gtt.txt --output $summaryLocation

    outputHashLocation="${baseDir}/outputHash_CR${i}_${lumi}"
    rooptimize hash $summaryLocation --supercuts $supercutsLocation -o $outputHashLocation --use-summary

    outputFilePlots="CR${i}_${lumi}_${version}"
    python graph-grid-mlb.py --summary $summaryLocation --lumi $lumi -o $outputFilePlots --do-run2 --run2-excl run2_limit.csv --run2-1sigma run2_limit_1sigma.csv -b  --g-min=1000 --g-max=2000 --l-max=1600
    python graph-cuts-mlb.py --summary $summaryLocation --lumi $lumi -o $outputFilePlots -b --outputHash $outputHashLocation --supercuts $supercutsLocation  --g-min=1000 --g-max=2000 --l-max=1600

  done
done
