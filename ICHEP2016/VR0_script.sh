#!/bin/bash

# we use 1L files for both 0L and 1L control regions
files=$(find /Users/kratsg/2.4.19-0-0/${version}/*.root  -not -iname "*Gbb*" -not -iname "*data*")

baseDir="VR0/${version}"
rm -rf $baseDir
mkdir -p $baseDir

for i in 1 2 3
do
  supercutsLocation="regions_${version}/VR0-${i}.json"
  cutsLocation="${baseDir}/VR0${i}Cuts"

  #outputNMinus1="n-1/VR0-${i}"
  #python ../Optimization/do_n-1_cuts.py ${files[*]} --supercuts $supercutsLocation --output $outputNMinus1 --boundaries boundaries.json -f --tree nominal --eventWeight weight_mc

  python ../Optimization/optimize.py cut ${files[*]} --supercuts=$supercutsLocation -o $cutsLocation --numpy -b --eventWeight "event_weight" --weightsFile ../Optimization/weights.json --tree oTree --ncores=7

  for lumi in 35
  do
    significancesLocation="${baseDir}/VR0${i}Significances_${lumi}"

    python ../Optimization/optimize.py optimize --signal $(awk '{print $1"*"}' ../massWindows_Gtt.txt | tr '\n' ' ') --bkgd $(cat bkgdFiles | sed "s/$/.json/g" | tr '\n' ' ') --searchDirectory=$cutsLocation -b -o $significancesLocation --bkgdUncertainty=0.3 --bkgdStatUncertainty=0.3 --insignificance=0.5 --lumi $lumi

    summaryLocation="${baseDir}/summary_VR0${i}_${lumi}.json"
    python ../Optimization/optimize.py summary --searchDirectory $significancesLocation --massWindows ../massWindows_Gtt.txt --output $summaryLocation

    outputHashLocation="${baseDir}/outputHash_VR0${i}_${lumi}"
    python ../Optimization/optimize.py hash $summaryLocation --supercuts $supercutsLocation -o $outputHashLocation --use-summary

    outputFilePlots="VR0${i}_${lumi}_${version}"
    python ../Optimization/graph-grid.py --summary $summaryLocation --lumi $lumi -o $outputFilePlots --do-run2 --run2-excl ../run2_limit.csv --run2-1sigma ../run2_limit_1sigma.csv -b
    python ../Optimization/graph-cuts.py --summary $summaryLocation --lumi $lumi -o $outputFilePlots -b --outputHash $outputHashLocation --supercuts $supercutsLocation

  done
done
