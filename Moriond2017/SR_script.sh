#!/bin/bash

files=$(find /Users/kratsg/2.4.19-0-0/${version}/*.root  -not -iname "*Gbb*" -not -iname "*data*")

baseDir="SR/${version}"
rm -rf $baseDir
mkdir -p $baseDir

for i in 1 2 3
do
  supercutsLocation="regions_${version}/SR-${i}.json"
  cutsLocation="${baseDir}/SR${i}Cuts"

  #outputNMinus1="n-1/SR-${i}"
  #python ../Optimization/do_n-1_cuts.py ${files[*]} --supercuts $supercutsLocation --output $outputNMinus1 --boundaries boundaries.json -f --tree nominal --eventWeight weight_mc

  python ../Optimization/optimize.py cut ${files[*]} --supercuts=$supercutsLocation -o $cutsLocation --numpy -b --eventWeight "event_weight" --weightsFile ../Optimization/weights.json --tree oTree --ncores=7

  for lumi in 35
  do
    significancesLocation="${baseDir}/SR${i}Significances_${lumi}"

    python ../Optimization/optimize.py optimize --signal $(awk '{print $1"*"}' ../massWindows_Gtt.txt | tr '\n' ' ') --bkgd $(cat bkgdFiles | sed "s/$/.json/g" | tr '\n' ' ') --searchDirectory=$cutsLocation -b -o $significancesLocation --bkgdUncertainty=0.3 --bkgdStatUncertainty=0.3 --insignificance=0.5 --lumi $lumi

    summaryLocation="${baseDir}/summary_SR${i}_${lumi}.json"
    python ../Optimization/optimize.py summary --searchDirectory $significancesLocation --massWindows ../massWindows_Gtt.txt --output $summaryLocation

    outputHashLocation="${baseDir}/outputHash_SR${i}_${lumi}"
    python ../Optimization/optimize.py hash $summaryLocation --supercuts $supercutsLocation -o $outputHashLocation --use-summary

    outputFilePlots="SR${i}_${lumi}"
    python ../Optimization/graph-grid.py --summary $summaryLocation --lumi $lumi -o $outputFilePlots --do-run1 --run1-excl ../Optimization/run1_limit.csv --run1-1sigma ../Optimization/run1_limit_1sigma.csv -b
    python ../Optimization/graph-cuts.py --summary $summaryLocation --lumi $lumi -o $outputFilePlots --do-run1 --run1-excl ../Optimization/run1_limit.csv --run1-1sigma ../Optimization/run1_limit_1sigma.csv -b --outputHash $outputHashLocation --supercuts $supercutsLocation

  done
done

for lumi in 35
do
  python ../Optimization/find_optimal_signal_region.py --lumi $lumi --basedir $baseDir --massWindows ../massWindows_Gtt.txt --run1_csvfile ../Optimization/run1_limit.csv --run1_1sigma_csvfile ../Optimization/run1_limit_1sigma.csv --numSRs 3
done
